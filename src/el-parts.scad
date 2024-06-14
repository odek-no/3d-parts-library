// clang-format off
include<BOSL2\std.scad>;
// clang-format on

$fn = $preview ? 64 : 200;

slope = 0.1;
extra_for_better_removal = 0.001;

standard_wall = 2;

module button_grid_hole(wall, n = [ 2, 2 ], spacing = [ 25, 25 ], show_fasteners_x = false, show_fasteners_y = true,
                        anchor = CENTER, spin = 0, orient = UP)
{
  // Warning: Numbers repeated from microbit_connector module
  grid_margin_to_edge = 1;
  button_hole_width = 12.06;
  button_hole_length = 12.06;
  button_fastener_thickness = 3;
  total_x = (n[0] - 1) * spacing[0] + button_hole_width +
            (show_fasteners_x ? button_fastener_thickness * 2 : grid_margin_to_edge * 2);
  total_y = (n[1] - 1) * spacing[1] + button_hole_length +
            (show_fasteners_y ? button_fastener_thickness * 2 : grid_margin_to_edge * 2);

  total_z = wall + extra_for_better_removal;

  // This only works if anchor is BOT where this is attatched
  down(extra_for_better_removal / 2)
    attachable(anchor = anchor, spin = spin, orient = orient, size = [ total_x, total_y, total_z ])
  {
    cuboid([ total_x, total_y, total_z ]);
    children();
  }
}

module button_grid(n = [ 2, 2 ], spacing = [ 25, 25 ], markings = [ "D", "C", "B", "A" ], show_fasteners_x = false,
                   show_fasteners_y = true, anchor = CENTER, spin = 0, orient = UP)
{
  grid_margin_to_edge = 1;

  button_hole_width = 12.06;
  button_hole_length = 12.06;
  button_hole_height = 3.9;
  button_inner_d = 8.4;

  button_fastener_isize_x = 4.9;
  button_fastener_isize_z = 2.25;
  button_fastener_wall = 2;
  button_fastener_thickness = 3;
  button_fastener_height_above_box = 2.7;

  button_fastener_width = button_fastener_wall * 2 + button_fastener_isize_x;
  button_fastener_height = button_fastener_wall + button_fastener_isize_z + button_fastener_height_above_box;

  extra_wall = 1;

  total_x = (n[0] - 1) * spacing[0] + button_hole_width +
            (show_fasteners_x ? button_fastener_thickness * 2 : grid_margin_to_edge * 2);
  total_y = (n[1] - 1) * spacing[1] + button_hole_length +
            (show_fasteners_y ? button_fastener_thickness * 2 : grid_margin_to_edge * 2);

  total_z = standard_wall + extra_wall + button_fastener_height;

  size = [ total_x, total_y, total_z ];

  attachable(anchor = anchor, spin = spin, orient = orient, size = size)
  {
    down(total_z / 2) tag_diff("keep", keep = "keep_always")
      cuboid([ total_x, total_y, standard_wall + extra_wall ], anchor = BOT)
    {
      grid_copies(n = n, spacing = spacing)
      {
        // Square hole for button body
        tag("remove") up(extra_for_better_removal) position(TOP)
          cuboid([ button_hole_width, button_hole_length, extra_wall + extra_for_better_removal ], anchor = TOP);
        // Hole for button pole
        tag("remove") down(extra_for_better_removal / 2) position(BOT)
          cyl(d = button_inner_d, h = standard_wall + extra_for_better_removal, anchor = BOT);

        if (markings)
        {
          // TODO: Fix for other than two columns
          let(offset = $idx % 2 == 0 ? -1 : 1) color("red") tag("keep_always") position(TOP) left(offset * 9)
            text3d(markings[$idx], h = 0.2, size = 4, font = "Arial", orient = UP, anchor = BOT, center = true);
        }
        // Fasten holes for buttons
        if (show_fasteners_x)
        {
          position(TOP) xcopies(n = 2, spacing = button_hole_width + button_fastener_thickness)
            cuboid([ button_fastener_thickness, button_fastener_width, button_fastener_height ], anchor = BOT)
          {
            tag("remove") position(TOP) down(button_fastener_wall) cuboid(
              [
                button_fastener_thickness + extra_for_better_removal, button_fastener_isize_x,
                button_fastener_isize_z
              ],
              anchor = TOP);
          }
        }
        if (show_fasteners_y)
        {
          position(TOP) ycopies(n = 2, spacing = button_hole_width + button_fastener_thickness) cuboid(
            [ button_fastener_thickness, button_fastener_width, button_fastener_height ], anchor = BOT, spin = 90)
          {
            tag("remove") position(TOP) down(button_fastener_wall) cuboid(
              [
                button_fastener_thickness + extra_for_better_removal, button_fastener_isize_x,
                button_fastener_isize_z
              ],
              anchor = TOP);
          }
        }
      }
    }
    children();
  }
}

module button_fastener(n, spacing = 25)
{
  button_fastener_thickness = 3;
  button_fastener_x = 4.7;
  button_fastener_z = 2.0;
  button_hole_size = 12.06;

  button_fastener_y = (n - 1) * spacing + button_hole_size + button_fastener_thickness * 2;

  cuboid([ button_fastener_x, button_fastener_y, button_fastener_z ], chamfer = button_fastener_z / 2, edges = [TOP],
         except = [ BACK, LEFT, RIGHT ], anchor = BOT);
}
