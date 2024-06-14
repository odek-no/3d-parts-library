// clang-format off
include<box.scad>;
// clang-format on

$slop = 0.08;
wall = 2;

controller_x = 60;
controller_y = 100;
controller_z = 20;

part = "box";

if (part == "preview")
{
  xdistribute(spacing = 100)
  {
    box_with_sliding_close(controller_x, controller_y, controller_z, wall);
    lid_for_box_with_sliding_close(controller_x, controller_y, controller_z, wall);
    button_grid(n = [ 2, 3 ], show_fasteners_x = true, show_fasteners_y = true);
    button_fastener(n = 2);
  }
}
else if (part == "box")
{
  box_with_sliding_close(controller_x, controller_y, controller_z, wall, inner_walls = [ 40, 20 ]);
}
else if (part == "lid")
{
  lid_for_box_with_sliding_close(controller_x, controller_y, controller_z, wall);
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
else if (part == "button_fastener")
{
  button_fastener(n = 2);
}
