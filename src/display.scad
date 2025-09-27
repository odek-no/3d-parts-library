// clang-format off
include<BOSL2\std.scad>;
// clang-format on

$fn = $preview ? 64 : 200;

extra_for_better_removal = 0.001;

module oled_96x64(type = "hw", anchor = CENTER, spin = 0, orient = UP)
{
  // types: hw (hw-239a), clone1

  connector_fastener_length = 10.9;
  connector_fastener_thickness = 3;
  connector_fastener_height = 4.25;

  chip_x = type == "hw" ? 27.6 : type == "clone1" ? 28.8 : 0;
  chip_y = type == "hw" ? 27.9 : type == "clone1" ? 27.8 : 0;

  chip_z = 4;

  chip_blue_thickness = 1.3;

  oled_x = 25;
  oled_y = 14;
  oled_offset_y = 5 + connector_fastener_thickness;

  pins_x = 10;
  pins_y = 2;
  pin_offset_y = 0.6 + connector_fastener_thickness;

  wall = 1.2;
  extra_wall = 0.3;

  hole_d = 2.1;

  corners_h = 1.6 - extra_wall;

  chip_hole_offset = 4;

  total_x = chip_x + connector_fastener_thickness * 2;
  total_y = chip_y + connector_fastener_thickness * 2;
  total_z = wall + extra_wall + corners_h + connector_fastener_height + chip_blue_thickness;

  attachable(anchor = anchor, spin = spin, orient = orient, size = [ total_x, total_y, total_z ])
  {
    down(total_z / 2) tag_diff("keep", keep = "keep_always")
      cuboid([ total_x, total_y, wall + extra_wall ], anchor = BOT)
    {

      // Room for pins
      tag("remove") fwd(pin_offset_y) position(TOP + BACK) up(extra_for_better_removal)
        cuboid([ pins_x, pins_y, extra_wall + extra_for_better_removal ], anchor = TOP + BACK);

      // Window for oled
      tag("remove") fwd(oled_offset_y) down(extra_for_better_removal / 2) position(BOT + BACK)
        cuboid([ oled_x, oled_y, wall + extra_wall + extra_for_better_removal ], anchor = BOT + BACK);

      position(TOP) grid_copies(n = 2, spacing = [ chip_x - 6, chip_y - 3 ])
      {
        cuboid([ 6, 3, corners_h ], anchor = BOT);
        // tag("remove") up(corners_h + extra_for_better_removal)
        //   zcyl(d = hole_d, h = extra_wall + corners_h + extra_for_better_removal, anchor = TOP);
      }

      // Fasteners
      xcopies(n = 2, spacing = chip_x - connector_fastener_length + connector_fastener_thickness * 2) position(TOP)
        fastener_pair(distance = chip_y, height_above_bottom = corners_h + chip_blue_thickness, anchor = BOT,
                      spin = 90);

      // Stopping x movement
      position(TOP) grid_copies(
        n = 2, spacing = [ total_x - connector_fastener_thickness, total_y - connector_fastener_thickness * 3 ])
        cuboid(
          [
            connector_fastener_thickness, connector_fastener_thickness, corners_h + chip_blue_thickness +
            connector_fastener_height
          ],
          anchor = BOT);
    }

    children();
  }
}

module oled_96x64_hole(type = "hw", wall, anchor = CENTER, spin = 0, orient = UP)
{
  // Warning: Numbers repeated
  connector_fastener_thickness = 3;
  chip_x = type == "hw" ? 27.6 : type == "clone1" ? 28.8 : 0;
  chip_y = type == "hw" ? 27.9 : type == "clone1" ? 27.8 : 0;

  total_x = chip_x + connector_fastener_thickness * 2;
  total_y = chip_y + connector_fastener_thickness * 2;
  total_z = wall + extra_for_better_removal;

  // This only works if anchor is BOT where this is attached
  up_down = orient == UP ? 1 : -1;

  down(up_down * extra_for_better_removal / 2)
    attachable(anchor = anchor, spin = spin, orient = orient, size = [ total_x, total_y, total_z ])
  {
    cuboid([ total_x, total_y, total_z ]);
    children();
  }
}

module fastener_oled_96x64()
{
  chip_y = 28;
  button_fastener_long(gap = chip_y, $slop = 0.08);
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

module four_digit_display_catalex(mounting_wall = 1.6, anchor = CENTER, spin = 0, orient = UP)
{
  chip_x_including_pins = 47.5;
  chip_x = 42.3;
  chip_y = 24.2;
  display_x = 30.4;
  display_y = 14.4;
  display_z = 7;

  display_offset_x = 7;

  total_x = chip_x_including_pins;
  total_y = chip_y;
  total_z = display_z;

  margin_to_wall = mounting_wall > 2.4 ? 2.4 : mounting_wall;

  attachable(anchor = anchor, spin = spin, orient = orient, size = [ total_x, total_y, total_z ])
  {
    // We want the center of the display to be the center
    left((total_x - display_x) / 2 - display_offset_x) tag_diff("keep", keep = "keep_always")
      cuboid([ total_x, total_y, total_z ])
    {
      tag("remove") position(RIGHT) left(display_offset_x)
        cuboid([ display_x, display_y, display_z + extra_for_better_removal ], anchor = RIGHT);

      up(extra_for_better_removal)
      {
        tag("remove") position(TOP + RIGHT) left(chip_x / 2 - 2 + 0.5)
          grid_copies(n = 2, spacing = [ chip_x - 4, chip_y - 4 ])
            zcyl(d = 2.7, h = display_z - margin_to_wall, anchor = TOP + RIGHT);
      }

      tag("remove") position(BOT + LEFT) up(margin_to_wall) left(extra_for_better_removal)
        cuboid([ 20, 12, 5 + display_z - margin_to_wall ], anchor = BOT + LEFT);
    }

    // Not sure if this needs to be moved as well
    children();
  }
}

module four_digit_display_catalex_hole(wall, anchor = CENTER, spin = 0, orient = UP)
{
  // Warning: Numbers repeated
  chip_x_including_pins = 47.5;
  chip_x = 42.3;
  chip_y = 24.2;
  display_x = 30.4;

  total_x = chip_x_including_pins;
  total_y = chip_y;
  total_z = wall + extra_for_better_removal;

  display_offset_x = 7;

  // This only works if anchor is BOT where this is attatched
  up_down = orient == UP ? 1 : -1;

  attachable(anchor = anchor, spin = spin, orient = orient, size = [ total_x, total_y, total_z ])
  {
    // We want the center of the display to be the center
    left((total_x - display_x) / 2 - display_offset_x) down(up_down * extra_for_better_removal / 2)
    {
      cuboid([ total_x, total_y, total_z ]);
    }

    // Not sure if this needs to be moved as well
    children();
  }
}