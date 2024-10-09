// clang-format off
include<../../3d-parts-library/src/misc.scad>;
// clang-format on

part = "wire_cutter_guide_lid_for_drop_zone";
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