// clang-format off
include<box.scad>;
// clang-format on

width = 50;
length = 50;
height = 10;
wall = 1.2;

// diff() cube([ 50, 60, 70 ], center = true) edge_profile([TOP]) mask2d_rabbet(size = 10);

part = "preview";

if (part == "preview")
{
  xdistribute(spacing = 50)
  {
    box_rabbet(width, length * 2, height, wall = wall, anchor = BOT);
    down(5) box_rabbet_stackable(width, length, height, wall = wall, anchor = BOT, $slop = 0.12);
    box_rabbet_lid(width, length * 2, height = 10, wall = wall, anchor = BOT, $slop = 0.05);
  }
}
else if (part == "box_sliding")
{
  box_sliding(width, length, height, wall = wall);
}
else if (part == "box_sliding_lid")
{
  box_sliding_lid(width, length, height, wall = wall, $slop = 0.08);
}
else if (part == "box_rabbet")
{
  box_rabbet(width, length, height, wall = wall);
}
else if (part == "box_rabbet_stackable")
{
  box_rabbet_stackable(width, length, height, wall = wall, $slop = 0.06);
}
else if (part == "box_rabbet_lid")
{
  box_rabbet_lid(width, length, height, wall = wall, $slop = 0.06);
}