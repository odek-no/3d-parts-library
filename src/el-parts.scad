// clang-format off
include<BOSL2\std.scad>;
// clang-format on

$fn = $preview ? 64 : 200;

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
  button_fastener_wall = 3;
  button_fastener_wall_top = 2;
  button_fastener_thickness = 3;
  button_fastener_height_above_box = 2.6;

  button_fastener_width = button_fastener_wall * 2 + button_fastener_isize_x;
  button_fastener_height = button_fastener_wall_top + button_fastener_isize_z + button_fastener_height_above_box;

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
            tag("remove") position(TOP) down(button_fastener_wall_top) cuboid(
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
            tag("remove") position(TOP) down(button_fastener_wall_top) cuboid(
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

module button_fastener_stick(n, spacing = 25, extra_length = 0)
{
  button_fastener_thickness = 3;
  button_fastener_x = 4.7 - get_slop();
  button_fastener_z = 2.0 - get_slop();
  button_hole_size = 12.06;

  button_fastener_y = (n - 1) * spacing + button_hole_size + button_fastener_thickness * 2 + extra_length;

  cuboid([ button_fastener_x, button_fastener_y, button_fastener_z ], chamfer = button_fastener_z / 2, edges = [TOP],
         except = [ BACK, LEFT, RIGHT ], anchor = BOT);
}

module button_fastener()
{
  button_fastener_thickness = 3;
  button_fastener_x = 4.7 - get_slop();
  button_fastener_z = 2.0 - get_slop();
  button_hole_size = 12.06;

  button_fastener_y = 5.5;
  button_fastener_y_gap = 9;

  spring_wall = 0.6;

  yrot(90)
  {
    ycopies(n = 2, spacing = button_fastener_y + button_fastener_y_gap) zrot(180 * $idx)
      cuboid([ button_fastener_x, button_fastener_y, button_fastener_z ], rounding = button_fastener_z / 4,
             edges = [TOP], except = [ BACK, LEFT, RIGHT ], anchor = BOT)
    {
      back(0.4) position(TOP + BACK) cuboid([ button_fastener_x, 2.6, 1.1 ], anchor = BOT + BACK);
    }

    diff() left(button_fastener_x / 2) pie_slice(ang = 180, l = button_fastener_x,
                                                 d = button_fastener_y_gap + spring_wall * 2, orient = RIGHT, spin = 90)
      tag("remove") down(button_fastener_x / 2 + extra_for_better_removal / 2)
        pie_slice(ang = 180, l = button_fastener_x + extra_for_better_removal, d = button_fastener_y_gap);
  }
}

module button_cap(form_svg = "standard_button_cap.svg", size = [ 15, 15 ], offset = 0)
{
  cap_size = 14;
  cap_height = 4;
  cap_bottom_size = 7;
  wall = 2;

  cap_fastener_height = 2;
  button_pole_top_size = 3.8;
  button_pole_top_height = 3.0;
  button_pole_bottom_size = 1.8;
  button_pole_bottom_height = 0.8;
  button_pole_height_space = cap_height + cap_fastener_height - wall;
  assert(button_pole_height_space > 3.1);

  button_index = part == "a" ? 0 : part == "b" ? 1 : part == "c" ? 2 : part == "d" ? 3 : 0;
  cap_pole_extra_margin = 0.11;

  offset_y = offset;

  difference()
  {
    union()
    {
      _button_cap_extrude(form_svg, size);
      up(cap_height) back(offset_y) zcyl(h = cap_fastener_height, d = cap_bottom_size, anchor = BOT);
    }
    up(cap_height + cap_fastener_height) back(offset_y) cuboid(
      [
        button_pole_top_size + cap_pole_extra_margin, button_pole_top_size + cap_pole_extra_margin,
        button_pole_height_space
      ],
      anchor = TOP);
  }
}

module _button_cap_extrude(form_svg, size)
{
  cap_size = 14;
  cap_height = 4;
  rounding = 1;
  button_max_from_original_sizes = 18;
  scale_factor = cap_size / button_max_from_original_sizes;

  original_width = size[0];
  original_height = size[1];

  echo("size", size);

  button_x = original_width * scale_factor;
  button_y = original_height * scale_factor;
  echo("button_x", button_x);
  echo("button_y", button_y);

  // Round off
  minkowski()
  {
    left(button_x / 2) fwd(button_y / 2) resize([ button_x, button_y, 0 ])
      linear_extrude(height = cap_height - rounding * 2) import(file = form_svg);
    up(rounding) sphere(r = rounding);
  }
}