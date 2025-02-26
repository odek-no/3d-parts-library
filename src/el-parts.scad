// clang-format off
include<BOSL2\std.scad>;
// clang-format on

$fn = $preview ? 64 : 200;

extra_for_better_removal = 0.001;

module button_grid(n = [ 2, 2 ], spacing = [ 25, 25 ], use_minimal_spacing = false, markings = [], wall = 2,
                   extra_wall = 1, show_fasteners_x = false, show_fasteners_y = true, buttons_to_ignore = [],
                   anchor = CENTER, spin = 0, orient = UP)
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

  minimal_spacing = 18; // button_hole_width + button_fastener_thickness * 2;
  acutal_spacing = use_minimal_spacing ? [ minimal_spacing, minimal_spacing ] : spacing;

  total_x = (n[0] - 1) * acutal_spacing[0] + button_hole_width +
            (show_fasteners_x ? button_fastener_thickness * 2 : grid_margin_to_edge * 2);
  total_y = (n[1] - 1) * acutal_spacing[1] + button_hole_length +
            (show_fasteners_y ? button_fastener_thickness * 2 : grid_margin_to_edge * 2);

  total_z = wall + extra_wall + button_fastener_height;

  size = [ total_x, total_y, total_z ];

  attachable(anchor = anchor, spin = spin, orient = orient, size = size)
  {
    down(total_z / 2) tag_diff("keep", keep = "keep_always")
      cuboid([ total_x, total_y, wall + extra_wall ], anchor = BOT)
    {
      grid_copies(n = n, spacing = acutal_spacing)
      {
        if (!in_list($idx, buttons_to_ignore))
        {

          {
            // Square hole for button body
            tag("remove") up(extra_for_better_removal) position(TOP)
              cuboid([ button_hole_width, button_hole_length, extra_wall + extra_for_better_removal ], anchor = TOP);
            // Hole for button pole
            tag("remove") down(extra_for_better_removal / 2) position(BOT)
              cyl(d = button_inner_d, h = wall + extra_for_better_removal, anchor = BOT);
          }

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
    }
    children();
  }
}

module button_grid_hole(wall, n = [ 2, 2 ], spacing = [ 25, 25 ], use_minimal_spacing = false, show_fasteners_x = false,
                        show_fasteners_y = true, anchor = CENTER, spin = 0, orient = UP)
{
  // Warning: Numbers repeated from microbit_connector module
  grid_margin_to_edge = 1;
  button_hole_width = 12.06;
  button_hole_length = 12.06;
  button_fastener_thickness = 3;

  minimal_spacing = 18; // button_hole_width + button_fastener_thickness * 2;
  acutal_spacing = use_minimal_spacing ? [ minimal_spacing, minimal_spacing ] : spacing;

  total_x = (n[0] - 1) * acutal_spacing[0] + button_hole_width +
            (show_fasteners_x ? button_fastener_thickness * 2 : grid_margin_to_edge * 2);
  total_y = (n[1] - 1) * acutal_spacing[1] + button_hole_length +
            (show_fasteners_y ? button_fastener_thickness * 2 : grid_margin_to_edge * 2);

  total_z = wall + extra_for_better_removal;

  up_down = orient == UP ? 1 : -1;

  // This only works if anchor is BOT where this is attatched
  down(up_down * extra_for_better_removal / 2)
    attachable(anchor = anchor, spin = spin, orient = orient, size = [ total_x, total_y, total_z ])
  {
    cuboid([ total_x, total_y, total_z ]);
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
  button_fastener_y_gap = 8;

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

module button_fastener_long(gap)
{
  button_fastener_thickness = 3;
  button_fastener_x = 4.7 - get_slop();
  button_fastener_z = 2.0 - get_slop();
  button_hole_size = 12.06;

  overlap = 2.6;

  button_fastener_y = 5.5;
  button_fastener_y_gap = gap;

  spring_wall = 0.6;

  yrot(90)
  {
    ycopies(n = 2, spacing = button_fastener_y + button_fastener_y_gap - overlap * 2) zrot(180 * $idx)
      cuboid([ button_fastener_x, button_fastener_y, button_fastener_z ], rounding = button_fastener_z / 4,
             edges = [TOP], except = [ BACK, LEFT, RIGHT ], anchor = BOT);
    up(button_fastener_z) cuboid([ button_fastener_x, button_fastener_y_gap, 1.1 ], anchor = BOT);
  }
}

module button_cap(form_svg = "standard_button_cap.svg", size = [ 15, 15 ], offset = [ 0, 0 ], anchor = CENTER, spin = 0,
                  orient = UP)
{
  wall = 2;
  cap_height = 4;
  cap_fastener_height = 3;
  cap_fastener_d = 7;

  button_pole_top_size = 3.8;
  button_pole_top_height = 3.0;
  button_pole_bottom_size = 1.8;
  button_pole_bottom_height = 0.8;
  button_pole_height_space = cap_height + cap_fastener_height - wall;
  // We need the space for the button cap to be a bit higher than the button pole
  assert(button_pole_height_space > 3.1);

  button_index = part == "a" ? 0 : part == "b" ? 1 : part == "c" ? 2 : part == "d" ? 3 : 0;
  cap_pole_extra_margin = 0.11;

  offset_x = offset[0];
  offset_y = offset[1];

  rounding = 1;

  width_wo_rounding = size[0] - rounding * 2;
  height_wo_rounding = size[1] - rounding * 2;

  total_height = cap_height + cap_fastener_height;

  attachable(anchor = anchor, spin = spin, orient = orient, size = [ size[0], size[1], total_height ])
  {
    down(total_height / 2) difference()
    {
      union()
      {
        minkowski()
        {
          resize([ width_wo_rounding, height_wo_rounding, 0 ]) linear_extrude(height = cap_height - rounding * 2)
            import(file = form_svg, center = true);
          up(rounding) sphere(r = rounding);
        }

        up(cap_height) right(offset_x) back(offset_y) zcyl(h = cap_fastener_height, d = cap_fastener_d, anchor = BOT);
      }
      up(cap_height + cap_fastener_height + extra_for_better_removal) right(offset_x) back(offset_y) cuboid(
        [
          button_pole_top_size + cap_pole_extra_margin, button_pole_top_size + cap_pole_extra_margin,
          button_pole_height_space +
          extra_for_better_removal
        ],
        anchor = TOP);
    }
    children();
  }
}

module four_digit_display_seeed_studio(anchor = CENTER, spin = 0, orient = UP)
{
  chip_x = 42.3;
  chip_y = 24.2;
  display_x = 30.4;
  display_y = 14.4;
  display_z = 7;

  display_offset_x = 3;

  total_x = chip_x;
  total_y = chip_y;
  total_z = display_z;

  attachable(anchor = anchor, spin = spin, orient = orient, size = [ total_x, total_y, total_z ])
  {
    // We want the center of the display to be the center
    left(display_offset_x) tag_diff("keep", keep = "keep_always") cuboid([ total_x, total_y, total_z ])
    {
      tag("remove") position(RIGHT) left(display_offset_x)
        cuboid([ display_x, display_y, display_z + extra_for_better_removal ], anchor = RIGHT);

      up(extra_for_better_removal)
      {
        tag("remove") position(TOP + RIGHT) ycopies(n = 2, spacing = 20) left(9.2)
          zcyl(d = 2.3, h = 5 + extra_for_better_removal, anchor = TOP + RIGHT);
        tag("remove") position(TOP + LEFT) right(0.9)
          zcyl(d = 2.3, h = 5 + extra_for_better_removal, anchor = TOP + LEFT);
      }
    }
    children();
  }
}

module four_digit_display_seeed_studio_hole(wall, anchor = CENTER, spin = 0, orient = UP)
{
  // Warning: Numbers repeated
  chip_x = 42.3;
  chip_y = 24.2;

  total_x = chip_x;
  total_y = chip_y;
  total_z = wall + extra_for_better_removal;

  display_offset_x = 3;

  // This only works if anchor is BOT where this is attatched
  up_down = orient == UP ? 1 : -1;
  // We want the center of the display to be the center
  left(display_offset_x) down(up_down * extra_for_better_removal / 2)
    attachable(anchor = anchor, spin = spin, orient = orient, size = [ total_x, total_y, total_z ])
  {
    cuboid([ total_x, total_y, total_z ]);
    children();
  }
}

module plug_four_digit_display_seeed_studio() { plug_single(d = 2.0, h = 5); }

module small_on_off_switch(anchor = CENTER, spin = 0, orient = UP)
{
  // TODO: Make this typical on the back of the box
  body_x = 8.5;
  body_y = 14.5;

  switch_x = body_x + 1.2 * 2;
  switch_y = body_y + 1.2 * 2;

  wall = 2;

  display_offset_x = 2.9;

  total_x = switch_x;
  total_y = switch_y;
  total_z = wall;

  attachable(anchor = anchor, spin = spin, orient = orient, size = [ total_x, total_y, total_z ])
  {
    tag_diff("keep", keep = "keep_always") cuboid([ total_x, total_y, total_z ])
    {
      tag("remove") cuboid([ body_x, body_y, wall + extra_for_better_removal ]);
    }
    children();
  }
}

module small_on_off_switch_hole(wall, anchor = CENTER, spin = 0, orient = UP)
{
  // Warning: Numbers repeated
  body_x = 8.3;
  body_y = 14.4;

  switch_x = body_x + 1.2 * 2;
  switch_y = body_y + 1.2 * 2;

  total_x = switch_x;
  total_y = switch_y;
  total_z = wall + extra_for_better_removal;

  // This only works if anchor is BOT where this is attatched
  up_down = orient == UP ? 1 : -1;
  down(up_down * extra_for_better_removal / 2)
    attachable(anchor = anchor, spin = spin, orient = orient, size = [ total_x, total_y, total_z ])
  {
    cuboid([ total_x, total_y, total_z ]);
    children();
  }
}

module plug_single(d, h)
{
  cuboid([ 3, d + 1, d ]) { position(LEFT + FWD) xcyl(d = d, h = h, anchor = RIGHT + FWD); }
}

module sliding_potentiometer(wall, anchor = CENTER, spin = 0, orient = UP)
{
  side_wall = 1.2;

  widthPothole = 73.6 + side_wall * 2;
  depthPothole = 12.6 + side_wall * 2;
  heightPothole = 4;

  widthKnobHole = 54;
  depthKnobHole = 2;
  heightKnobHole = 14;

  connector_fastener_thickness = 3;

  total_x = widthPothole;

  total_y = depthPothole - side_wall * 2 + connector_fastener_thickness * 2;
  total_z = wall;

  attachable(anchor = anchor, spin = spin, orient = orient, size = [ total_x, total_y, total_z ])
  {
    tag_diff("keep", keep = "keep_always") cuboid([ total_x, total_y, wall ])
    {
      // Hole for knob
      tag("remove") cuboid([ widthKnobHole, depthKnobHole, wall + extra_for_better_removal ]);

      // Fit the potentiometer
      position(TOP) up(extra_for_better_removal) cuboid([ widthPothole, depthPothole, heightPothole ], anchor = BOT)
      {
        tag("remove") cuboid(
          [ widthPothole - side_wall * 2, depthPothole - side_wall * 2, heightPothole + extra_for_better_removal ]);
      }

      // Fasteners
      xcopies(n = 2, spacing = 40) position(TOP)
        fastener_pair(depthPothole - side_wall * 2, 11, anchor = BOT, spin = 90);
    }
    children();
  }
}

module sliding_potentiometer_hole(wall, anchor = CENTER, spin = 0, orient = UP)
{
  // Warning: Numbers repeated
  side_wall = 1.2;

  widthPothole = 73.6 + side_wall * 2;
  depthPothole = 12.6 + side_wall * 2;
  heightPothole = 4;

  widthKnobHole = 54;
  depthKnobHole = 2;
  heightKnobHole = 14;

  connector_fastener_thickness = 3;

  total_x = widthPothole;
  total_y = depthPothole - side_wall * 2 + connector_fastener_thickness * 2;
  total_z = wall + extra_for_better_removal;

  // This only works if anchor is BOT where this is attatched
  up_down = orient == UP ? 1 : -1;
  // We want the center of the display to be the center
  down(up_down * extra_for_better_removal / 2)
    attachable(anchor = anchor, spin = spin, orient = orient, size = [ total_x, total_y, total_z ])
  {
    cuboid([ total_x, total_y, total_z ]);
    children();
  }
}

module sliding_potentiometer_knob(anchor = CENTER, spin = 0, orient = UP)
{
  width = 10;
  depth = 10;
  height = 12;
  widthHole = 4.5;
  depthHole = 1.4;
  heightHole = 10;
  difference()
  {
    cuboid([ width, depth, height ], anchor = [ -1, -1, -1 ], rounding = 1);
    translate([ width / 2 - widthHole / 2, depth / 2 - depthHole / 2, height - heightHole ])
    {
      cube([ widthHole, depthHole, heightHole ]);
    }
  }
}

module fastener_pair(distance, height_above_bottom, anchor = CENTER, spin = 0, orient = UP)
{
  connector_fastener_isize_x = 4.9;
  connector_fastener_isize_z = 2.25;
  connector_fastener_wall = 3;
  connector_fastener_wall_top = 2;
  connector_fastener_thickness = 3;
  connector_fastener_width = connector_fastener_wall * 2 + connector_fastener_isize_x;
  connector_fastener_height = connector_fastener_wall_top + connector_fastener_isize_z + height_above_bottom;
  connector_fastener_spacing = distance + connector_fastener_thickness;

  total_x = connector_fastener_wall * 2 + distance;
  total_y = connector_fastener_width;
  total_z = connector_fastener_height;

  // We want the center of the display to be the center
  down(connector_fastener_height) tag_scope()
    attachable(anchor = anchor, spin = spin, orient = orient, size = [ total_x, total_y, total_z ])
  {

    tag_diff("keep", keep = "keep_always") position(TOP + BACK) xcopies(n = 2, spacing = connector_fastener_spacing)
      cuboid([ connector_fastener_thickness, connector_fastener_width, connector_fastener_height ], anchor = BOT + BACK)
    {
      tag("remove") position(TOP) down(connector_fastener_wall_top) cuboid(
        [
          connector_fastener_thickness + extra_for_better_removal, connector_fastener_isize_x,
          connector_fastener_isize_z
        ],
        anchor = TOP);
    }

    children();
  }
}

module toggle_button_grid(n = [ 2, 2 ], spacing = [ 15, 15 ], use_minimal_spacing = false, anchor = CENTER, spin = 0,
                          orient = UP)
{
  wall = 6;
  extra_wall = 1;
  grid_margin_to_edge = 1;

  button_hole_width = 8.05;
  button_hole_length = 13.1;
  button_hole_height = 6;
  button_inner_d = 6.4;

  // Can't be to narrow because of the nut
  minimal_spacing = [ 11 + grid_margin_to_edge, 13 + grid_margin_to_edge ];
  acutal_spacing = use_minimal_spacing ? minimal_spacing : spacing;

  total_x = (n[0] - 1) * acutal_spacing[0] + button_hole_width + grid_margin_to_edge * 2;
  total_y = (n[1] - 1) * acutal_spacing[1] + button_hole_length + grid_margin_to_edge * 2;

  total_z = wall + extra_wall;

  size = [ total_x, total_y, total_z ];

  attachable(anchor = anchor, spin = spin, orient = orient, size = size)
  {
    down(total_z / 2) tag_diff("keep", keep = "keep_always")
      cuboid([ total_x, total_y, wall + extra_wall ], anchor = BOT)
    {
      grid_copies(n = n, spacing = acutal_spacing)
      {
        // Square hole for button body
        tag("remove") up(extra_for_better_removal) position(TOP)
          cuboid([ button_hole_width, button_hole_length, extra_wall + extra_for_better_removal ], anchor = TOP);
        // Hole for button pole
        tag("remove") down(extra_for_better_removal / 2) position(BOT)
          cyl(d = button_inner_d, h = wall + extra_for_better_removal, anchor = BOT);
      }
    }
    children();
  }
}

module toggle_button_grid_hole(wall, n = [ 2, 2 ], spacing = [ 15, 15 ], use_minimal_spacing = false, anchor = CENTER,
                               spin = 0, orient = UP)
{
  // Warning: Numbers repeated
  grid_margin_to_edge = 1;

  button_hole_width = 8.05;
  button_hole_length = 13.1;
  button_hole_height = 6;

  minimal_spacing = [ button_hole_width + grid_margin_to_edge, button_hole_length + grid_margin_to_edge ];
  acutal_spacing = use_minimal_spacing ? minimal_spacing : spacing;

  total_x = (n[0] - 1) * acutal_spacing[0] + button_hole_width + grid_margin_to_edge * 2;
  total_y = (n[1] - 1) * acutal_spacing[1] + button_hole_length + grid_margin_to_edge * 2;

  total_z = wall + extra_for_better_removal;

  up_down = orient == UP ? 1 : -1;

  // This only works if anchor is BOT where this is attatched
  down(up_down * extra_for_better_removal / 2)
    attachable(anchor = anchor, spin = spin, orient = orient, size = [ total_x, total_y, total_z ])
  {
    cuboid([ total_x, total_y, total_z ]);
    children();
  }
}

module servo_motor_tg9z(wall, anchor = CENTER, spin = 0, orient = UP)
{
  side_wall = 1.2;

  widthPothole = 73.6 + side_wall * 2;
  depthPothole = 12.6 + side_wall * 2;
  heightPothole = 4;

  widthKnobHole = 54;
  depthKnobHole = 2;
  heightKnobHole = 14;

  connector_fastener_thickness = 3;

  total_x = widthPothole;

  total_y = depthPothole - side_wall * 2 + connector_fastener_thickness * 2;
  total_z = wall;

  attachable(anchor = anchor, spin = spin, orient = orient, size = [ total_x, total_y, total_z ])
  {
    tag_diff("keep", keep = "keep_always") cuboid([ total_x, total_y, wall ])
    {
      // Hole for knob
      tag("remove") cuboid([ widthKnobHole, depthKnobHole, wall + extra_for_better_removal ]);

      // Fit the potentiometer
      position(TOP) up(extra_for_better_removal) cuboid([ widthPothole, depthPothole, heightPothole ], anchor = BOT)
      {
        tag("remove") cuboid(
          [ widthPothole - side_wall * 2, depthPothole - side_wall * 2, heightPothole + extra_for_better_removal ]);
      }

      // Fasteners
      xcopies(n = 2, spacing = 40) position(TOP)
        fastener_pair(depthPothole - side_wall * 2, 11, anchor = BOT, spin = 90);
    }
    children();
  }
}
