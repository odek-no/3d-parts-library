// clang-format off
include<box.scad>;
include<el-parts.scad>;
include<jst.scad>;
include<microbit.scad>;
// clang-format on
$slop = 0.08;

part = "lid";

if (part == "box")
{
  box_sliding(64, 104, 20, wall = 2.4, inner_walls = []);
}
else if (part == "lid")
{
  box_sliding_lid(50, 50, 20, wall = 2.4, $slop = 0.09, anchor = BOT);
}
else if (part == "microbit_connector")
{
  microbit_connector(pins_to_show = [ 1, 23, 24, 25, 26, 35 ], pin_text = " G         23...1   ");
}
else if (part == "microbit_connector_fastener")
{
  microbit_connector_fastener();
}
else if (part == "button_grid")
{
  button_grid(n = [ 2, 2 ]);
}
else if (part == "button_fastener_stick")
{
  button_fastener_stick(n = 2);
}
else if (part == "button_fastener")
{
  button_fastener($slop = 0.08);
}
else if (part == "button_cap")
{
  button_cap(size = [ 10, 16 ], offset = [ 0, 0 ]);
}
else if (part == "jst")
{
  xdistribute(spacing = 20)
  {
    jst_male(n = 4);
    jst_female(n = 4);
  }
}
else if (part == "test")
{
}
