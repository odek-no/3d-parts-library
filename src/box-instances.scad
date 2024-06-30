// clang-format off
include<box.scad>;
// clang-format on

width = 50;
length = 50;
height = 40;
wall = 1.2;
chamfer = 0;
rounding = 1.5;

// diff() cube([ 50, 60, 70 ], center = true) edge_profile([TOP]) mask2d_rabbet(size = 10);

part = "box_simple_lock";

if (part == "preview")
{
  xdistribute(spacing = 80)
  {
    box_rabbet(50, 50, 40, wall = wall, chamfer = chamfer, rounding = rounding, anchor = BOT);

    box_rabbet_lid(50, 50, height = 10, wall = wall, chamfer = chamfer, rounding = rounding, anchor = BOT,
                   $slop = 0.06);
  }
}
else if (part == "box_sliding")
{
  box_sliding(width, length, height, wall = wal, chamfer = chamfer, rounding = rounding);
}
else if (part == "box_sliding_lid")
{
  box_sliding_lid(width, length, height, wall = wall, chamfer = chamfer, rounding = rounding, $slop = 0.08);
}
else if (part == "box_rabbet")
{
  box_rabbet(width, length, height, wall = wall, chamfer = chamfer, rounding = rounding);
}
else if (part == "box_rabbet_lid")
{
  box_rabbet_lid(width, length, height, wall = wall, chamfer = chamfer, rounding = rounding, $slop = 0.06);
}
else if (part == "box_simple_lock")
{
  box_simple_lock();
}