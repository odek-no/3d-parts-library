// clang-format off
include<BOSL2\std.scad>;
// clang-format on

$fn = $preview ? 32 : 200;

standard_wall = 2;
standard_inner_wall = 1.2;
extra_for_better_removal = 0.001;

module box_with_sliding_close(controller_x, controller_y, controller_z, wall = standard_wall, inner_walls = [],
                              inner_wall = standard_inner_wall, anchor = CENTER, spin = 0, orient = UP)
{
  empty_x = controller_x - wall * 2;
  empty_y = controller_y - wall * 2;
  lid_lip = 0.5;
  lid_x = empty_x + lid_lip * 2;
  lid_y = empty_y + lid_lip * 2;

  inner_wall_z = controller_z - wall * 2 - lid_lip;

  lid_margin_z = 0.5;

  size = [ controller_x, controller_y, controller_z ];

  attachable(anchor = anchor, spin = spin, orient = orient, size = size)
  {
    tag_scope() down(controller_z / 2) diff()
      cuboid([ controller_x, controller_y, controller_z ], chamfer = 1, anchor = BOT)
    {

      tag("remove") up(extra_for_better_removal)
      {
        position(TOP) cuboid([ empty_x, empty_y, controller_z - wall + extra_for_better_removal ], anchor = TOP);
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

// TODO: add additional friction stops as input
module lid_for_box_with_sliding_close(controller_x, controller_y, controller_z, wall = standard_wall)
{
  empty_x = controller_x - wall * 2;
  empty_y = controller_y - wall * 2;
  lid_lip = 0.5;
  lid_shorter_y = 0.4;
  lid_x = empty_x + lid_lip * 2 - get_slop();
  lid_y = empty_y + lid_lip + wall - lid_shorter_y;
  lid_z = wall - get_slop();

  lid_friction_stop_x = 8;
  lid_friction_stop_y = 1;
  lid_friction_stop_z = 0.4;
  diff() cuboid([ lid_x, lid_y, lid_z ], chamfer = wall / 2, edges = [TOP], anchor = BOT)
  {
    position(BOT + FWD) back(wall) cuboid([ lid_friction_stop_x, lid_friction_stop_y, lid_friction_stop_z ],
                                          rounding = lid_friction_stop_z, edges = [BOT + BACK], anchor = TOP + FWD);

    // position(BOT + BACK) fwd(wall + 1 / 2 + battery_pack_space_y + 1)
    //   cuboid([ lid_friction_stop_width, 1, 0.4 ], rounding = 0.4, edges = [BOT], anchor = TOP + BACK);
  }
}