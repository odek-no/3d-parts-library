// clang-format off
include<BOSL2\std.scad>;
// clang-format on

$fn = $preview ? 32 : 200;

standard_wall = 2.4;
standard_lid_lip = 1;
standard_inner_wall = 1.2;
extra_for_better_removal = 0.001;

// TODO: Make own module for internal walls. Could be grid, or something.

module box_rabbet(width, length, height, wall = 1.2, chamfer = 1.5, rounding = 0, anchor = CENTER, spin = 0,
                  orient = UP)
{
  empty_x = width - wall * 2;
  empty_y = length - wall * 2;
  empty_z = height - wall;

  rabbet_x = width - wall * 2 - get_slop() * 2;
  rabbet_y = length - wall * 2 - get_slop() * 2;

  friction_lock_pin_length = 2;
  friction_lock_hole_length = 2.4;
  friction_lock_hole_d = 0.6;

  size = [ width, length, height ];

  attachable(anchor = anchor, spin = spin, orient = orient, size = size)
  {
    tag_scope() diff() cuboid([ width, length, height ], chamfer = chamfer, rounding = rounding, except = [TOP])
    {
      tag("remove") up(extra_for_better_removal) position(TOP)
        cuboid([ empty_x, empty_y, empty_z + extra_for_better_removal ], chamfer = chamfer, rounding = rounding,
               except = [TOP], anchor = TOP);

      tag("remove") down(1) position(TOP)
      {
        xflip_copy(offset = rabbet_x / 2) ycyl(d = friction_lock_hole_d, h = friction_lock_hole_length, anchor = TOP);
        yflip_copy(offset = rabbet_y / 2) xcyl(d = friction_lock_hole_d, h = friction_lock_hole_length, anchor = TOP);
      }
    }

    children();
  }
}

module box_rabbet_lid(width, length, height = 10, wall = 1.2, rabbet_wall = 0.8, chamfer = 1.5, rounding = 0,
                      anchor = CENTER, spin = 0, orient = UP)
{
  rabbet_x = width - wall * 2 - get_slop() * 2;
  rabbet_y = length - wall * 2 - get_slop() * 2;
  rabbet_z = 5;

  empty_x = width - wall * 2 - rabbet_wall * 2;
  empty_y = length - wall * 2 - rabbet_wall * 2;
  empty_z = height - wall;

  total_height = height + rabbet_z;

  friction_lock_pin_length = 2;
  friction_lock_pin_d = 0.5;

  size = [ width, length, total_height ];

  attachable(anchor = anchor, spin = spin, orient = orient, size = size)
  {
    down(total_height / 2) tag_scope() diff()
      cuboid([ width, length, height ], chamfer = chamfer, rounding = rounding, except = [TOP], anchor = BOT)
    {
      // position(TOP)
      //   rect_tube(size = [ rabbet_x, rabbet_y ], wall = rabbet_wall, h = rabbet_z, chamfer = chamfer, anchor = BOT);

      tag("remove") up(rabbet_z + extra_for_better_removal / 2) position(TOP)
        cuboid([ empty_x, empty_y, empty_z + rabbet_z + extra_for_better_removal ], chamfer = chamfer,
               rounding = rounding, except = [TOP], anchor = TOP);

      position(TOP) cuboid([ rabbet_x, rabbet_y, rabbet_z ], chamfer = chamfer, rounding = rounding,
                           except = [ TOP, BOT ], anchor = BOT)
      {
        tag("keep") down(rabbet_z - friction_lock_pin_d - 1) position(TOP)
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
                   chamfer = 0, rounding = 2, anchor = CENTER, spin = 0, orient = UP)
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
    tag_scope() down(height / 2) diff()
      cuboid([ width, length, height ], chamfer = chamfer, rounding = rounding, anchor = BOT)
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

module box_sliding_lid(width, length, wall = standard_wall, extra_friction_stops = [], anchor = CENTER, spin = 0,
                       orient = UP)
{
  empty_x = width - wall * 2;
  empty_y = length - wall * 2;
  lid_lip = standard_lid_lip;
  lid_shorter_y = 0.4;
  lid_x = empty_x + lid_lip * 2 - get_slop();
  lid_y = empty_y + lid_lip + wall - lid_shorter_y;
  lid_z = wall - get_slop();

  use_friction_lock = false;

  echo("lid", lid_x, lid_y, lid_z);

  lid_friction_stop_x = 8;
  lid_friction_stop_y = 1.4;
  lid_friction_stop_z = 0.6;
  lid_friction_offset_y = 0.1;
  size = [ width, length, lid_z + lid_friction_stop_z ];

  attachable(anchor = anchor, spin = spin, orient = orient, size = size)
  {
    tag_scope() up(size[2] / 2) down(lid_friction_stop_z) xrot(180) diff()
      cuboid([ lid_x, lid_y, lid_z ], chamfer = wall / 2, edges = [TOP], anchor = BOT)
    {
      if (use_friction_lock)
      {
        position(BOT + FWD) back(wall - lid_shorter_y + lid_friction_offset_y)
          cuboid([ lid_friction_stop_x, lid_friction_stop_y, lid_friction_stop_z ], rounding = lid_friction_stop_z,
                 edges = [BOT + BACK + FWD], anchor = TOP + FWD);
      }

      for (extra_friction_stops = extra_friction_stops)
      {
        position(BOT + FWD) back(extra_friction_stops)
          cuboid([ lid_friction_stop_x, lid_friction_stop_y, lid_friction_stop_z ], rounding = lid_friction_stop_z,
                 edges = [BOT + BACK + FWD], anchor = TOP + FWD);
      }

      if (!use_friction_lock)
      {
        position(BOT + FWD) back(wall - lid_shorter_y)
        {
          tag("remove") box_simple_lock_hole(wall, anchor = BOT + FWD);

          tag("keep") box_simple_lock(wall, anchor = BOT + FWD);
        }
      }
    }
    children();
  }
}

module box_simple_lock_fastener()
{
  spring_z = 6 - get_slop();
  spring_h = 9;
  spring_w = 8.3;
  spring_wall = 0.9;
  stopper_thickness = 0.8 - get_slop();
  stopper_length = 12 - get_slop();
  stopper_offset = 3;
  left(stopper_offset) cuboid([ stopper_thickness, stopper_length, spring_z ], anchor = BOT);

  ycopies(n = 2, spacing = 8.2) right(stopper_offset) cuboid([ stopper_thickness, 3.2, spring_z ], anchor = BOT);

  difference()
  {
    linear_extrude(height = spring_z) difference()
    {
      ellipse(d = [ spring_h, spring_w ]);
      ellipse(d = [ spring_h - spring_wall * 2, spring_w - spring_wall * 2 ]);
    }
    left(stopper_offset + stopper_thickness / 2) cuboid([ 10, stopper_length, spring_z ], anchor = BOT + RIGHT);
    right(stopper_offset + stopper_thickness / 2) cuboid([ 10, stopper_length, spring_z ], anchor = BOT + LEFT);
  }
}

module box_simple_lock(wall = standard_wall, anchor = CENTER, spin = 0, orient = UP)
{
  spring_z = 6;
  stopper_length = 12;
  stopper_thickness = 0.8;
  grove = stopper_thickness + 0.3;
  grove_inside = stopper_thickness;
  extra_space_for_screw_driver = 0.8;

  total_x = stopper_length + extra_space_for_screw_driver * 2 ++extra_for_better_removal;
  total_y = spring_z + extra_for_better_removal;
  total_z = wall;

  echo("wall", standard_wall);

  attachable(anchor = anchor, spin = spin, orient = orient, size = [ total_x, total_y, total_z ])
  {

    tag_diff("keep", keep = "keep_always") cuboid([ total_x, total_y, total_z ])
    {
      // Hole through wall
      tag("remove") cuboid([ stopper_length - 4, spring_z, wall ]);

      // Room on lock head side
      position(TOP) tag("remove") cuboid([ stopper_length, spring_z, grove ], anchor = TOP);

      // Extra space for screw driver
      position(TOP) up(extra_for_better_removal) tag("remove")
        cuboid([ stopper_length + extra_space_for_screw_driver * 2, spring_z, grove + extra_for_better_removal ],
               rounding = 1, edges = [BOT], except = [ FWD, BACK ], anchor = TOP);

      // Space for lock down side
      position(BOT) down(extra_for_better_removal) tag("remove")
        cuboid([ stopper_length, spring_z, grove_inside + extra_for_better_removal ], anchor = BOT);
    }

    children();
  }
}

module box_simple_lock_hole(wall = standard_wall, anchor = CENTER, spin = 0, orient = UP)
{
  // Warning: Numbers repeated
  spring_z = 6;
  stopper_length = 12;
  extra_space_for_screw_driver = 0.8;

  total_x = stopper_length + extra_space_for_screw_driver * 2 + extra_for_better_removal;
  total_y = spring_z + extra_for_better_removal;
  total_z = wall;

  // This only works if anchor is BOT where this is attatched
  down(extra_for_better_removal / 2)
    attachable(anchor = anchor, spin = spin, orient = orient, size = [ total_x, total_y, total_z ])
  {
    cuboid([ total_x, total_y, total_z ]);
    children();
  }
}
