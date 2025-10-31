// clang-format off
include<../../3d-parts-library/src/misc.scad>;
// clang-format on

part = "wire_holder_top_1_1";
if (part == "wire_cutter_guide_1_4")
{
  wire_cutter_guide_as_sliding_lid(d = 1.4);
}
else if (part == "wire_cutter_guide_box")
{
  wire_cutter_guide_sliding_box();
}
else if (part == "wire_cutter_guide_lid_for_drop_zone")
{
  wire_cutter_guide_lid_for_drop_zone($slop = 0.5);
}
else if (part == "wire_cutter_guide_wire_stopper")
{
  wire_cutter_guide_wire_stopper();
}
else if (part == "wire_holder_bottom")
{
  wire_holder_bottom(count = 10);
}
else if (part == "wire_holder_bottom_hatch")
{
  // d is tested to fit a wire with d of 1.1
  wire_holder_bottom_hatch();
}
else if (part == "wire_holder_top_1_4")
{
  // d is tested to fit a wire with d of 1.4
  wire_holder_top(count = 10, d = 1.3);
}
else if (part == "wire_holder_top_1_1")
{
  // d is tested to fit a wire with d of 1.1
  wire_holder_top(count = 10, d = 1.0);
}
