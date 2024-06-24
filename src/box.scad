// clang-format off
include<BOSL2\std.scad>;
// clang-format on

$fn = $preview ? 32 : 200;

standard_wall = 2.4;
standard_lid_lip = 1;
standard_inner_wall = 1.2;
extra_for_better_removal = 0.001;

// TODO: Make own module for internal walls. Could be grid, or something.

module box_rabbet(width, length, height, wall = 1.2, chamfer = 2, anchor = CENTER, spin = 0, orient = UP)
{
  empty_x = width - wall * 2;
  empty_y = length - wall * 2;
  empty_z = height - wall;

  rabbet_x = width - wall * 2 - get_slop() * 2;
  rabbet_y = length - wall * 2 - get_slop() * 2;

  friction_lock_pin_length = 2;
  friction_lock_hole_length = 2.5;
  friction_lock_pin_d = 0.4;
  friction_lock_hole_d = 0.6;

  size = [ width, length, height ];

  attachable(anchor = anchor, spin = spin, orient = orient, size = size)
  {
    tag_scope() diff() cuboid([ width, length, height ], chamfer = chamfer, except = [TOP])
    {
      tag("remove") up(extra_for_better_removal) position(TOP) cuboid(
        [ empty_x, empty_y, empty_z + extra_for_better_removal ], chamfer = chamfer, except = [TOP], anchor = TOP);

      tag("remove") down(1) position(TOP)
      {
        xflip_copy(offset = rabbet_x / 2) ycyl(d = friction_lock_hole_d, h = friction_lock_hole_length, anchor = TOP);
        yflip_copy(offset = rabbet_y / 2) xcyl(d = friction_lock_hole_d, h = friction_lock_hole_length, anchor = TOP);
      }
    }

    children();
  }
}

module box_rabbet_stackable(width, length, height, wall = 1.2, rabbet_wall = 0.8, chamfer = 2, anchor = CENTER,
                            spin = 0, orient = UP)
{
  rabbet_z = 5;

  empty_x = width - wall * 2;
  empty_y = length - wall * 2;
  empty_z = height - wall;

  rabbet_x = width - wall * 2 - get_slop() * 2;
  rabbet_y = length - wall * 2 - get_slop() * 2;

  friction_lock_pin_length = 2;
  friction_lock_hole_length = 2.5;
  friction_lock_pin_d = 0.4;
  friction_lock_hole_d = 0.6;

  total_height = height + rabbet_z;
  size = [ width, length, total_height ];

  attachable(anchor = anchor, spin = spin, orient = orient, size = size)
  {
    tag_scope() diff() cuboid([ width, length, height + rabbet_z ], chamfer = chamfer, except = [ TOP, BOT ])
    {
      tag("remove") up(extra_for_better_removal) position(TOP)
        cuboid([ empty_x, empty_y, empty_z + extra_for_better_removal ], chamfer = chamfer, except = [ TOP, BOT ],
               anchor = TOP);

      tag("remove") down(extra_for_better_removal) position(BOT) cuboid(
        [ width + extra_for_better_removal, length + extra_for_better_removal, rabbet_z + extra_for_better_removal ],
        chamfer = chamfer, except = [ TOP, BOT ], anchor = BOT);

      tag("keep") position(BOT)
        rect_tube(size = [ rabbet_x, rabbet_y ], wall = rabbet_wall, h = rabbet_z, chamfer = chamfer, anchor = BOT)
      {
        tag("keep") down(1) position(TOP)
        {
          xflip_copy(offset = rabbet_x / 2) ycyl(d = friction_lock_pin_d, h = friction_lock_pin_length, anchor = TOP);
          yflip_copy(offset = rabbet_y / 2) xcyl(d = friction_lock_pin_d, h = friction_lock_pin_length, anchor = TOP);
        }
      }

      tag("remove") down(1) position(TOP)
      {
        xflip_copy(offset = rabbet_x / 2) ycyl(d = friction_lock_hole_d, h = friction_lock_hole_length, anchor = TOP);
        yflip_copy(offset = rabbet_y / 2) xcyl(d = friction_lock_hole_d, h = friction_lock_hole_length, anchor = TOP);
      }
    }

    children();
  }
}

module box_rabbet_lid(width, length, height = 10, wall = 1.2, rabbet_wall = 0.8, chamfer = 2, anchor = CENTER, spin = 0,
                      orient = UP)
{
  rabbet_x = width - wall * 2 - get_slop() * 2;
  rabbet_y = length - wall * 2 - get_slop() * 2;
  rabbet_z = 5;

  empty_x = width - wall * 2 - rabbet_wall * 2;
  empty_y = length - wall * 2 - rabbet_wall * 2;
  empty_z = height - wall;

  total_height = height + rabbet_z;

  friction_lock_pin_length = 2;
  friction_lock_hole_length = 2.5;
  friction_lock_pin_d = 0.4;
  friction_lock_hole_d = 0.6;

  size = [ width, length, total_height ];

  attachable(anchor = anchor, spin = spin, orient = orient, size = size)
  {
    down(total_height / 2) tag_scope() diff()
      cuboid([ width, length, height ], chamfer = chamfer, except = [TOP], anchor = BOT)
    {
      // position(TOP)
      //   rect_tube(size = [ rabbet_x, rabbet_y ], wall = rabbet_wall, h = rabbet_z, chamfer = chamfer, anchor = BOT);

      tag("remove") up(rabbet_z + extra_for_better_removal / 2) position(TOP)
        cuboid([ empty_x, empty_y, empty_z + rabbet_z + extra_for_better_removal ], chamfer = chamfer, except = [TOP],
               anchor = TOP);

      position(TOP) cuboid([ rabbet_x, rabbet_y, rabbet_z ], chamfer = chamfer, except = [ TOP, BOT ], anchor = BOT)
      {
        tag("keep") down(1) position(TOP)
        {
          xflip_copy(offset = rabbet_x / 2) ycyl(d = friction_lock_pin_d, h = friction_lock_pin_length, anchor = TOP);
          yflip_copy(offset = rabbet_y / 2) xcyl(d = friction_lock_pin_d, h = friction_lock_pin_length, anchor = TOP);
        }
      }
    }

    children();
  }
}

module box_sliding(width, length, height, wall = standard_wall, inner_walls = [], inner_wall = standard_inner_wall,
                   anchor = CENTER, spin = 0, orient = UP)
{
  empty_x = width - wall * 2;
  empty_y = length - wall * 2;
  lid_lip = standard_lid_lip;
  lid_x = empty_x + lid_lip * 2;
  lid_y = empty_y + lid_lip * 2;

  inner_wall_z = height - wall * 2 - lid_lip;

  lid_margin_z = 0.5;

  size = [ width, length, height ];

  attachable(anchor = anchor, spin = spin, orient = orient, size = size)
  {
    tag_scope() down(height / 2) diff() cuboid([ width, length, height ], chamfer = 1, anchor = BOT)
    {

      tag("remove") up(extra_for_better_removal)
      {
        position(TOP) cuboid([ empty_x, empty_y, height - wall + extra_for_better_removal ], anchor = TOP);
      }

      tag("remove") up(extra_for_better_removal / 2) fwd(extra_for_better_removal / 2) position(TOP + FWD)
        cuboid([ empty_x, wall + extra_for_better_removal, wall + lid_margin_z + extra_for_better_removal ],
               anchor = TOP + FWD);

      tag("remove") down(lid_margin_z) fwd(wall / 2) position(TOP)
        cuboid([ lid_x, lid_y + wall, wall ], chamfer = wall / 2, edges = [TOP], anchor = TOP);

      tag("keep") up(wall) back(wall) position(BOT + FWD)
      {
        for (i = inner_walls)
        {
          back(i) cuboid([ empty_x, inner_wall, inner_wall_z ], anchor = BOT + FWD);
        }
      }
    }

    children();
  }
}

module box_sliding_lid(width, length, height, wall = standard_wall, extra_friction_stops = [])
{
  empty_x = width - wall * 2;
  empty_y = length - wall * 2;
  lid_lip = standard_lid_lip;
  lid_shorter_y = 0.4;
  lid_x = empty_x + lid_lip * 2 - get_slop();
  lid_y = empty_y + lid_lip + wall - lid_shorter_y;
  lid_z = wall - get_slop();

  echo("lid", lid_x, lid_y, lid_z);

  lid_friction_stop_x = 8;
  lid_friction_stop_y = 1.4;
  lid_friction_stop_z = 0.6;
  lid_friction_offset_y = 0.1;

#up(lid_z) xrot(180) diff() cuboid([ lid_x, lid_y, lid_z ], chamfer = wall / 2, edges = [TOP], anchor = BOT)
  {
    position(BOT + FWD) back(wall - lid_shorter_y + lid_friction_offset_y)
      cuboid([ lid_friction_stop_x, lid_friction_stop_y, lid_friction_stop_z ], rounding = lid_friction_stop_z,
             edges = [BOT + BACK + FWD], anchor = TOP + FWD);

    for (extra_friction_stops = extra_friction_stops)
    {
      position(BOT + FWD) back(extra_friction_stops)
        cuboid([ lid_friction_stop_x, lid_friction_stop_y, lid_friction_stop_z ], rounding = lid_friction_stop_z,
               edges = [BOT + BACK + FWD], anchor = TOP + FWD);
    }
  }
}