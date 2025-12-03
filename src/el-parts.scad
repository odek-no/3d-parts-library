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
  // OBSOLETE!!!
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

module piezosensor(d, anchor = CENTER, spin = 0, orient = UP)
{
  connector_fastener_length = 10.9;
  connector_fastener_thickness = 3;
  connector_fastener_height = 4.25;
  connector_fastener_isize_x = 4.9;
  connector_fastener_isize_z = 2.25;

  piezo_h = 0.6;
  piezo_wall = 2;
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
          cube([ total_x, connector_fastener_isize_x + 0.2, connector_fastener_isize_z + 0.6 ], anchor = BOT);
        tag("remove") back(d / 2) position(BOT) up(piezo_h + 1) xcopies(n = 2, spacing = 3)
          ycyl(d = 2.5, h = 10, anchor = BOT);
      }
    }

    // Not sure if this needs to be moved as well
    children();
  }
}

module piezosensor_fastener(d) { button_fastener_long(gap = d); }

module ledstrip_ring(d = 83.6, led_count = 16, anchor = CENTER, spin = 0, orient = UP)
{
  // 18 leds: d=93.5 ?
  // 16 leds: d=83.6;

  led_count_per_meter = 60;
  size_per_led = 1000 / led_count_per_meter;

  o = size_per_led * led_count;
  // d = o / PI;
  // 18 count seems to have a good d of 93.2;
  echo("calculated d", o / PI);
  echo("used d", d);

  led_size = 5.2;
  led_strip_thickness = 2.2;
  echo("led_strip_thickness", led_strip_thickness);
  led_strip_width = 10.7;
  strip_thickness = 0.8;
  led_solder_thickness = 1.3;

  inner_wall = 2;

  inner_lower_part_h = 1.2;

  strip_fastener_h = 1;
  strip_fastener_w = 2.2;

  total_d = d + strip_fastener_w * 2;
  total_z = led_strip_width + strip_fastener_h;

  echo("total d included strip_fastener_w", total_d);

  attachable(anchor = anchor, spin = spin, orient = orient, d = total_d, l = total_z)
  {
    down(total_z / 2)
    {
      tag_scope() diff() tube(od = d, id = d - inner_wall * 2, h = led_strip_width, anchor = BOT)
      {
        position(TOP) tube(od = d + strip_fastener_w * 2, id = d - inner_wall * 2, h = strip_fastener_h, anchor = BOT);

        // Space for wires
        tag("remove") up(inner_lower_part_h) position(BOT) back(d / 2)
          cuboid([ 5, d / 2, led_strip_width - inner_lower_part_h ], anchor = BOT);

#tag("keep") up(inner_lower_part_h) position(BOT + BACK) right(1.7)
        cuboid([ 1.2, 4.5, led_strip_width - inner_lower_part_h ], anchor = BOT, spin = 35);
      }
    }

    children();
  }
}

module battery_holder_triangle_aa(is_hole_maker = false, anchor = CENTER, spin = 0, orient = UP)
{
  holder_plus_thickness = 0.55;
  holder_minus_thickness = 0.7;
  battery_h = 50.5;

  wall = 1.2;
  zrot_d = 46.8;

  if (is_hole_maker)
  {
    zrot_copies(n = 3, d = zrot_d) { battery_holder_aa(is_hole_maker = true, spin = 90, anchor = BOT); }
  }
  else
  {

    difference()
    {
      zrot_copies(n = 3, d = zrot_d) { battery_holder_aa(hole_for_minus_plug = $idx == 1, spin = 90, anchor = BOT); }

      zrot_copies(n = 3, d = zrot_d)
      {
        if ($idx != 1)
        {
          up(wall + 3) back(battery_h / 2 + 2.55) left(5.1)
            cuboid([ 5, holder_minus_thickness + 0.2, 11 + extra_for_better_removal ], anchor = BOT);
        }

        if ($idx != 2)
        {
          up(wall + 3) fwd(battery_h / 2 + 2.45) left(5.1)
            cuboid([ 5, holder_plus_thickness + 0.2, 11 + extra_for_better_removal ], anchor = BOT);

          // The little dot
          up(wall + 3) fwd(battery_h / 2 + 2.25) left(6.1)
            cuboid([ 3, 1.1, 11 + extra_for_better_removal ], anchor = BOT);
        }

        // Need to make room once again for the hole for the plus part
        {
          up(2 + wall) fwd(battery_h / 2 + 2.55)
            cuboid([ 12, holder_plus_thickness, 11 + extra_for_better_removal ], anchor = BOT);
        }
      }
    }
  }
}

module battery_holder_2x_aa()
{
  holder_plus_thickness = 0.55;
  holder_minus_thickness = 0.7;
  battery_h = 50.5;
  wall = 1.2;
  battery_d = 14.6;

  spacing = battery_d + wall;

  difference()
  {
    ycopies(n = 2, spacing = spacing)
    {
      zrot($idx % 2 == 0 ? 0 : 180) battery_holder_aa(hole_for_minus_plug = $idx == 0, anchor = BOT);
    }

    // Join the two holders
    up(wall + 3) left(battery_h / 2 + 2.55)
      cuboid([ holder_plus_thickness + 0.2, 8, 11 + extra_for_better_removal ], anchor = BOT);
    // // The little dot
    up(wall + 3) fwd(1.9) left(battery_h / 2 + 2.25) cuboid([ 1.1, 3, 11 + extra_for_better_removal ], anchor = BOT);
  }
}

module battery_holder_aa(hole_for_minus_plug = true, is_hole_maker = false, anchor = CENTER, spin = 0, orient = UP)
{
  wall = 1.2;

  battery_d = 14.6;
  battery_h = 50.5;

  holder_plus_thickness = 0.55;
  holder_plus_height = 11.3;

  holder_minus_thickness = 0.7;
  holder_minus_solder_d = 0.6;
  holder_minus_big_d = 8.8;
  holder_minus_small_d = 3.2;

  plus_part_thickness = 3;
  minus_part_thickness = 3;

  battery_h_spring_adjustment = 2.5;

  hole_maker_slop = 0.1;
  extra_if_hole_maker = is_hole_maker ? hole_maker_slop : 0;

  total_x = battery_h + plus_part_thickness + minus_part_thickness + battery_h_spring_adjustment + extra_if_hole_maker;
  total_y = battery_d + wall * 2 + extra_if_hole_maker;
  total_z = battery_d + wall + extra_if_hole_maker;

  echo("battery_holder_aa total_z", total_z);

  attachable(anchor = anchor, spin = spin, orient = orient, size = [ total_x, total_y, total_z ])
  {
    if (is_hole_maker)
    {
      cuboid([ total_x, total_y, total_z ]);
    }
    else
    {
      down(total_z / 2) tag_scope() diff() cuboid([ total_x, total_y, wall ], anchor = BOT)
      {
        position(TOP + LEFT) right(plus_part_thickness) ycopies(n = 2, spacing = battery_d + wall)
          cuboid([ battery_h + battery_h_spring_adjustment, wall, battery_d ], anchor = BOT + LEFT);

        // Plus
        position(TOP + LEFT) cuboid([ plus_part_thickness, battery_d + wall * 2, 13 ], anchor = BOT + LEFT)
        {
          tag("remove") up(extra_for_better_removal) position(TOP + RIGHT)
          {
            // left(1) back(5) cuboid([ holder_plus_thickness, 11.5, 10 + extra_for_better_removal ], anchor = TOP +
            // RIGHT);
            left(1) cuboid([ holder_plus_thickness, 12, 11 + extra_for_better_removal ], anchor = TOP + RIGHT);
            right(extra_for_better_removal)
              cuboid([ 1 + extra_for_better_removal, 7, 9 + extra_for_better_removal ], anchor = TOP + RIGHT);
          }
        }

        // Minus
        position(TOP + RIGHT) cuboid([ minus_part_thickness, battery_d + wall * 2, 13 ], anchor = BOT + RIGHT)
        {
          tag("remove") up(extra_for_better_removal) position(TOP + LEFT)
          {

            right(1) cuboid([ holder_minus_thickness, 9, 11 + extra_for_better_removal ], anchor = TOP + LEFT);

            left(extra_for_better_removal)
              cuboid([ 1 + extra_for_better_removal, 7, 9 + extra_for_better_removal ], anchor = TOP + LEFT);

            // Hole for wire
            if (hole_for_minus_plug)
            {
              left(extra_for_better_removal / 2)
                cuboid([ minus_part_thickness + extra_for_better_removal, 1, 8 ], anchor = TOP + LEFT);
            }
          }
        }

        tag("remove") position(BOT) down(extra_for_better_removal / 2) xcopies(n = 11, spacing = battery_h / 10)
          cuboid([ 3, battery_d, wall + extra_for_better_removal ], anchor = BOT);
      }
    }
    children();
  }
}