// clang-format off
include<box.scad>;
// clang-format on

d = 50;
use_small_d_for_lid = false;

holes = [ 16, 4 ];

width = 160;
length = 160;
height = 30;
wall = 1.2;
chamfer = 0;
rounding = 1.5;
lid_rabbet_z = 5;
friction_locks = false;

// diff() cube([ 50, 60, 70 ], center = true) edge_profile([TOP]) mask2d_rabbet(size = 10);

part = "preview";

if (part == "preview")
{
  xdistribute(spacing = 80)
  {
    box_rabbet(50, 50, 40, wall = 1.2, chamfer = 0, rounding = 1.5, anchor = BOT);

    box_rabbet_lid(50, 50, height = 10, wall = 1.2, chamfer = 0, rounding = 1.5, anchor = BOT, $slop = 0.06);

    box_sliding(50, 50, 40, wall = 2.4, chamfer = 0, rounding = 1.5, anchor = BOT);

    box_sliding_lid(50, 50, wall = 2.4, anchor = BOT, $slop = 0.06);
  }
}
else if (part == "box_sliding")
{
  box_sliding(width, length, height, chamfer = chamfer, rounding = rounding);
}
else if (part == "box_sliding_lid")
{
  use_friction_lock = true;
  box_sliding_lid(width, length, use_friction_lock = use_friction_lock, $slop = 0.08);
}
else if (part == "box_rabbet")
{
  box_rabbet(width, length, height, wall = wall, chamfer = chamfer, rounding = rounding,
             friction_locks = friction_locks);
}
else if (part == "box_rabbet_lid")
{
  box_rabbet_lid(width, length, height, wall = wall, chamfer = chamfer, rounding = rounding, rabbet_z = lid_rabbet_z,
                 $slop = 0.06);
}
else if (part == "box_cylinder")
{
  box_cylinder(d = d, height = height, wall = wall, use_small_d_for_lid = use_small_d_for_lid, holes = holes);
}
else if (part == "box_cylinder_lid")
{
  box_cylinder_lid(d = d, wall = wall, use_small_d_for_lid = use_small_d_for_lid);
}
else if (part == "box_cylinder_lid_preview")
{
  xdistribute(spacing = 50)
  {
    box_cylinder_lid(d = d, wall = wall);
    box_cylinder(d = d, height = height, wall = wall, holes = holes);

    box_cylinder(d = d, height = height, wall = wall, use_small_d_for_lid = true, holes = holes);

    box_cylinder_lid(d = d, wall = wall, use_small_d_for_lid = true);
  }
}
else if (part == "box_simple_lock")
{
  box_simple_lock();
}
else if (part == "box_shape")
{
  box_shape(200, 140, height, "D:/code/batbit/artwork/batman-logo.svg");
}