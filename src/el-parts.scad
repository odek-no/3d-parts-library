// clang-format off
include<BOSL2\std.scad>;
// clang-format on

ELPARTS_BATTERY_3AA_Y = 48.5;

$fn = $preview ? 64 : 200;

extra_for_better_removal = 0.001;

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

module sonar_hcsr04(anchor = CENTER, spin = 0, orient = UP)
{
  connector_fastener_length = 10.9;
  connector_fastener_thickness = 3;
  connector_fastener_height = 4.25;

  chip_x = 45.5;
  chip_y_including_pins = 26.6;
  chip_y = 20.5;
  chip_z = 7;
  chip_blue_thickness = 1.65;

  mic_d = 16.2;
  mic_spacing = 42.8 - mic_d;
  mic_offset_y = 2;

  holes_d = 1.8;
  holes_offset_xy = 0.5;

  wall = 1.2;

  fastener_offset_y = (chip_y_including_pins - chip_y) / 2 - connector_fastener_thickness / 2;

  // pins
  tallest_component_z = 1.4;

  total_x = chip_x;
  total_y = chip_y_including_pins + connector_fastener_thickness;
  total_z = wall + tallest_component_z;

  mic_offset_because_of_pins = (total_y) / 2 - connector_fastener_thickness - mic_offset_y - mic_d / 2;
  echo("mic_offset_because_of_pins", mic_offset_because_of_pins);

  attachable(anchor = anchor, spin = spin, orient = orient, size = [ total_x, total_y, total_z ])
  {
    tag_diff("keep", keep = "keep_always") cuboid([ total_x, total_y, total_z ])
    {
      // Holes for mics
      tag("remove") position(BOT + BACK) down(extra_for_better_removal / 2)
        fwd(mic_offset_y + connector_fastener_thickness) xcopies(n = 2, spacing = mic_spacing)
          zcyl(d = mic_d, h = total_z + extra_for_better_removal, anchor = BOT + BACK);

      // Holes for fasteners
      // tag("remove") position(TOP + BACK) up(extra_for_better_removal)
      //   fwd(holes_offset_xy + (chip_y - holes_d - holes_offset_xy * 2) / 2 + connector_fastener_thickness)
      //   grid_copies(
      //     n = [ 2, 2 ], spacing = [ chip_x - holes_d - holes_offset_xy * 2, chip_y - holes_d - holes_offset_xy * 2 ])
      //     zcyl(d = holes_d, h = total_z - wall + extra_for_better_removal, anchor = TOP + BACK);

      // Holes for components (this is fore the old 5v with Oscillator )
      // tag("remove") position(TOP + BACK) up(extra_for_better_removal) back(extra_for_better_removal)
      //   cuboid([ 11.2, 5.8 + extra_for_better_removal, tallest_component_z + extra_for_better_removal ], rounding =
      //   2,
      //          except = [ TOP, BOT, BACK ], anchor = TOP + BACK);

      tag("remove") position(TOP + FWD) up(extra_for_better_removal) fwd(extra_for_better_removal)
        cuboid([ 11, 10 + extra_for_better_removal, tallest_component_z + extra_for_better_removal ], rounding = 2,
               except = [ TOP, BOT, FWD ], anchor = TOP + FWD);

      // Fasteners
      back(fastener_offset_y) xcopies(n = 2, spacing = chip_x - connector_fastener_length) position(TOP)
        fastener_pair(distance = chip_y, height_above_bottom = chip_blue_thickness, anchor = BOT, spin = 90);
    }

    // Not sure if this needs to be moved as well
    children();
  }
}

module sonar_hcsr04_hole(wall, anchor = CENTER, spin = 0, orient = UP)
{
  // Warning: Numbers repeated
  connector_fastener_thickness = 3;
  chip_x = 45.5;
  chip_y_including_pins = 26.6;

  total_x = chip_x;
  total_y = chip_y_including_pins + connector_fastener_thickness;
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

module sonar_tube(length = 25)
{
  mic_d = 16.1;

  length_part1 = 10;
  length_part2 = length - length_part1;

  tube(h = length_part1, id = mic_d, wall = 1.2, anchor = BOT)
  {
    position(TOP) tube(h = length_part2, id1 = mic_d, id2 = 10, wall = 1.2, anchor = BOT);
  }
}

module battery_holder_3AA(show_battery = false, anchor = CENTER, spin = 0, orient = UP)
{
  screw_hole_height = 6;
  extra_room_other_places_than_screw = 1.4;
  total_x = 58;
  total_y = ELPARTS_BATTERY_3AA_Y;
  total_z = 16.6 + screw_hole_height + extra_room_other_places_than_screw;
  screw_d = 3.5;
  screw_spacing = 30;
  screw_offset_x = 29.1;
  rest_d = 8;
  rest_margin_x = 4;
  rest_margin_y = 0.5;

  attachable(anchor = anchor, spin = spin, orient = orient, size = [ total_x, total_y, total_z ])
  {
    diff()
    {
      right(screw_offset_x) ycopies(spacing = screw_spacing, n = 2) position(BOT + LEFT)
        tube(id = screw_d, wall = 2, h = screw_hole_height, anchor = BOT);
      position(BOT) grid_copies(
        n = [ 2, 2 ], spacing = [ (total_x)-rest_d - rest_margin_x * 2, total_y - rest_d - rest_margin_y * 2 ])
        zcyl(d = rest_d, h = extra_room_other_places_than_screw + screw_hole_height, anchor = BOT);
      if (show_battery)
      {
        color([ 0.5, 0.5, 0.5, 0.6 ]) position(BOT) cuboid([ total_x, total_y, total_z ], anchor = BOT);
      }
    }
    children();
  }
}

module piezosensor(d = 27.4, anchor = CENTER, spin = 0, orient = UP)
{
  connector_fastener_length = 10.9;
  connector_fastener_thickness = 3;
  connector_fastener_height = 4.25;
  connector_fastener_isize_x = 4.9;
  connector_fastener_isize_z = 2.25;

  piezo_h = 0.4;
  piezo_wall = 1.6;
  piezo_tall_h = piezo_h + 4;

  total_x = d + piezo_wall * 2;
  total_y = d + piezo_wall * 2;
  total_z = piezo_tall_h;

  attachable(anchor = anchor, spin = spin, orient = orient, size = [ total_x, total_y, total_z ])
  {
    down(total_z / 2) tag_diff("keep", keep = "keep_always") cuboid([ total_x, total_y, 0 ])
    {
      position(TOP) tube(id = d, wall = piezo_wall, h = piezo_h, anchor = BOT);
      position(TOP) tube(id = d, wall = piezo_wall, h = piezo_tall_h, anchor = BOT)
      {
        tag("remove") position(BOT) up(piezo_h)
          cube([ total_x, connector_fastener_isize_x, connector_fastener_isize_z ], anchor = BOT);
        tag("remove") fwd(d / 2) position(BOT) up(piezo_h) xcopies(n = 2, spacing = 3)
          ycyl(d = 2, h = 10, anchor = BOT);
      }
    }

    // Not sure if this needs to be moved as well
    children();
  }
}

module piezosensor_fastener(d = 27.4) { button_fastener_long(gap = d, $slop = 0.08); }

module ledstrip_ring(d = 95.5, led_count = 18, anchor = CENTER, spin = 0, orient = UP)
{
  led_count_per_meter = 60;
  size_per_led = 1000 / led_count_per_meter;

  o = size_per_led * led_count;
  // d = o / PI;
  echo("calculated d", o / PI);
  echo("used d", d);

  led_size = 5.2;
  led_thickness = 2.2;
  strip_width = 10.5;
  strip_thickness = 0.8;
  led_solder_thickness = 1.3;

  h_before_led = (strip_width - led_size) / 2;

  inner_wall = 1.2;
  outer_wall = 1.2;

  closing_height = 1;
  total_d = d + led_thickness * 2 + outer_wall * 2;
  total_z = strip_width + closing_height;

  echo("total d included space and walls", total_d);
  echo("total outer ring space", inner_wall + outer_wall + led_thickness);

  attachable(anchor = anchor, spin = spin, orient = orient, d = total_d, l = total_z)
  {
    down(total_z / 2)
    {
      // Outer part
      tag_scope() diff() tube(id = d + led_thickness * 2, wall = outer_wall, h = strip_width, anchor = BOT) {}

      // Inner part
      tag_scope() diff() tube(od = d, wall = inner_wall, h = strip_width, anchor = BOT)
      {
        // Opening
        tag("remove") back(d / 2) cuboid([ 10, d / 2, strip_width ]);
      }

      // closing
      // up(strip_width) tube(od = total_d, id = d - inner_wall * 2, h = closing_height, anchor = BOT);
    }

    children();
  }
}