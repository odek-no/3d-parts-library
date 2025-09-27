// clang-format off
include<BOSL2\std.scad>;
// clang-format on

$fn = $preview ? 64 : 200;

MICROBIT_BATTERY_PACK_X = 53.5;
MICROBIT_BATTERY_PACK_Y = 25.8;
MICROBIT_BATTERY_PACK_Z = 15.0;

extra_for_better_removal = 0.001;

mb_x = 51.6;
mb_y = 42.1;
mb_connector_x = 57.2;
mb_buttons_size = 6.5 + 0.3;

module microbit_connector_flush(show_buttons = true, anchor = CENTER, spin = 0, orient = UP)
{
  connector_offset_y = 36;
  connector_space_z = 3;
  connector_space_y = 10.6;
  connector_side_wall_space_y = connector_space_y + 0.7;
  connector_space_x = mb_connector_x;

  mb_including_connector = connector_offset_y + connector_side_wall_space_y;

  wall_thinnest = 1.2;
  wall_compensation_when_hide_buttons_to_prevent_push = show_buttons ? 0 : 0.3;
  wall_compensation_when_hide_buttons = show_buttons ? 0 : wall_thinnest;
  wall = wall_thinnest + wall_compensation_when_hide_buttons + wall_compensation_when_hide_buttons_to_prevent_push;
  wall_extra = 3;
  wall_total = wall + wall_extra;
  wall_sides = 2;
  total_x = mb_connector_x + wall_sides * 2;
  total_y = mb_including_connector + wall_sides * 2;
  total_z = wall_total + 5.9;
  size = [ total_x, total_y, total_z ];

  // TODO: Able to hide buttons: Need to assert a certain wall

  led_offset_y = 11.5;
  led_x = 20;
  led_y = 21;

  echo("led_x, led_y", led_x, led_y);

  buttons_offset_y = 18;
  buttons_spacing = 40;

  connector_fastener_center_offset = 21;

  down(total_z / 2) attachable(anchor = anchor, spin = spin, orient = orient, size = size)
  {
    tag_diff("keep", keep = "keep_always") cuboid([ total_x, total_y, wall_total ], anchor = BOT)
    {
      fwd(wall_sides)
      {

        // Space for led
        position(BOT + BACK) fwd(led_offset_y)
        {
          tag("remove") down(extra_for_better_removal / 2)
            cuboid([ led_x, led_y, wall_total + extra_for_better_removal ], anchor = BOT + BACK);
        }

        // Space for buttons
        tag("remove") position(BOT + BACK) up(wall_compensation_when_hide_buttons) down(extra_for_better_removal / 2)
          fwd(buttons_offset_y) xcopies(n = 2, spacing = buttons_spacing)
        {
          cuboid([ mb_buttons_size, mb_buttons_size, wall_total + extra_for_better_removal ], anchor = BOT + BACK);
          // Space for the soldered pins
          back(1) up(wall_total - wall_compensation_when_hide_buttons + extra_for_better_removal)
            xcopies(n = 2, spacing = mb_buttons_size - 2)
              cuboid([ 2, mb_buttons_size + 2, 0.8 + extra_for_better_removal ], anchor = TOP + BACK);
        }

        // Space for connector
        tag("remove") position(TOP + BACK) up(extra_for_better_removal) fwd(connector_offset_y)
        {
          cuboid([ connector_space_x, connector_space_y, connector_space_z + extra_for_better_removal ],
                 anchor = TOP + BACK);

          // Space for the thin wall in each end of the connector
          xcopies(n = 2, spacing = connector_space_x - 1.2) cuboid(
            [ 1.2, connector_side_wall_space_y, connector_space_z + extra_for_better_removal ], anchor = TOP + BACK);
        }

        // connector_fastener
        // TODO: Make connector as attachable part
        connector_fastener_isize_x = 4.9;
        connector_fastener_isize_z = 2.25;
        connector_fastener_wall = 3;
        connector_fastener_wall_top = 2;
        connector_fastener_thickness = 3;
        connector_fastener_height_above_box = 1.7;
        connector_fastener_width = connector_fastener_wall * 2 + connector_fastener_isize_x;
        connector_fastener_height =
          connector_fastener_wall_top + connector_fastener_isize_z + connector_fastener_height_above_box;
        echo("connector_fastener_height", connector_fastener_height);
        connector_fastener_spacing = mb_x + connector_fastener_thickness + 0.8;

        fwd(connector_fastener_center_offset - connector_fastener_width / 2) position(TOP + BACK)
          xcopies(n = 2, spacing = connector_fastener_spacing) cuboid(
            [ connector_fastener_thickness, connector_fastener_width, connector_fastener_height ], anchor = BOT + BACK)
        {
          tag("remove") position(TOP) down(connector_fastener_wall_top) cuboid(
            [
              connector_fastener_thickness + extra_for_better_removal, connector_fastener_isize_x,
              connector_fastener_isize_z
            ],
            anchor = TOP);
        }
      }
    }
    children();
  }
}

module microbit_connector_flush_hole(wall, anchor = CENTER, spin = 0, orient = UP)
{
  // Warning: Numbers repeated
  connector_offset_y = 36;
  connector_space_z = 3;
  connector_space_y = 10.6;
  connector_side_wall_space_y = connector_space_y + 0.7;

  mb_including_connector = connector_offset_y + connector_side_wall_space_y;

  wall_sides = 2;
  total_x = mb_connector_x + wall_sides * 2;
  total_y = mb_including_connector + wall_sides * 2;

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

module microbit_connector(pins_to_show = [], pin_text = "40...1", anchor = CENTER, spin = 0, orient = UP,
                          use_extra_support = false)
{
  pin_width = 0.5;
  pin_distance = 1.278;

  extra_support_x = use_extra_support ? 1.2 * 2 : 0;

  degree = 40;

  connector_rests_side_width = 11.6;
  connector_rests_middle_width = 24.3;

  well_offset_z = degree == 40 ? 7.2 : 0;
  well_offset_y = degree == 40 ? 0.3 : 0;

  connector_y = 10.5;
  connector_z = 10.4;

  wall = 3;

  fastener_x = 5.6;
  fastener_y = 3;
  fastener_spacing = mb_connector_x - fastener_x + 2;
  total_x = fastener_spacing + fastener_x + extra_support_x;
  total_y = 22.5;
  total_z = wall + 10; // this is not accurate, but it's good enough for now

  size = [ total_x, total_y, total_z ];

  attachable(anchor = anchor, spin = spin, orient = orient, size = size)
  {
    down(total_z / 2) zrot(180) tag_diff("keep", keep = "keep_always") cuboid([ total_x, total_y, wall ], anchor = BOT)
    {
      fwd(0.1)
      {
        xrot(degree)
        {
          // Hole in wall
          tag("remove") cuboid([ mb_connector_x, connector_y, 15 ], anchor = CENTER);

          // Support for the connector
          tag("keep_always") up(well_offset_z) fwd(well_offset_y)
          {
            cuboid([ connector_rests_middle_width, 10, 2.5 ], anchor = TOP);
            xcopies(spacing = 40, n = 2) cuboid([ connector_rests_side_width, 10, 2.5 ], anchor = TOP);
            up(1) xrot(-degree) xcopies(spacing = 13.2, n = 4)
              prismoid(size1 = [ 2, 3 ], size2 = [ 2, 9 ], shift = [ 0, 4 ], h = 5, anchor = TOP);
          }
        }
      }

      // Holes for fasteners
      position(TOP + BACK) xcopies(n = 2, spacing = fastener_spacing)
      {
        cuboid([ fastener_x, fastener_y, 3 ], anchor = BOT + BACK)
        {
          fastener_extra_y_to_remove_from_fastener_base = 0.5;
          // These values need to be adjusted if angle is changed

          back(1.32) down(0.6) xrot(degree) position(TOP) cuboid([ fastener_x, fastener_y, 5.8 + 6 ], anchor = BOT)
          {
            tag("remove") position(TOP + BACK) down(2) back(extra_for_better_removal)
              cuboid([ 1.6, fastener_y + fastener_extra_y_to_remove_from_fastener_base, 5.8 ], anchor = TOP + BACK);
          }
        }
      }

      if (use_extra_support)
      {
        position(TOP + BACK) fwd(5) xcopies(n = 2, spacing = fastener_spacing + 6.8)
          cuboid([ 1.2, 10, 12 ], anchor = BOT, chamfer = 2, edges = [ FWD, BACK ], except = [ BOT, LEFT, RIGHT ]);
      }

      // Markings for pins
      color("red") fwd(5.2) position(TOP + BACK)
      {
        // All the pins for reference
        // xcopies(spacing = pin_distance, n = 40) cuboid([ pin_width, 2, 0.2 ], anchor = BOT + FWD);

        // Use 40+1 so we can have pin 1 at right(1*pin_distance), etc.
        left((40 + 1) * pin_distance / 2)
        {
          for (pin_to_show = pins_to_show)
          {
            right(pin_to_show * pin_distance) cuboid([ pin_width, 4, 0.2 ], anchor = BOT + FWD);
          }
        }

        back(4.9) position(RIGHT) left(extra_support_x / 2)
          text3d(pin_text, h = 0.2, size = 4, font = "Arial", orient = UP, spin = 180, anchor = BOT + FWD + LEFT);
      }
    }
    children();
  }
}

module microbit_connector_hole(wall, anchor = CENTER, spin = 0, orient = UP, use_extra_support = false)
{
  // Warning: Numbers repeated from microbit_connector module
  extra_support_x = use_extra_support ? 1.2 : 0;
  fastener_x = 5.6;
  fastener_spacing = mb_connector_x - fastener_x + 2;
  total_x = fastener_spacing + fastener_x + extra_support_x;
  total_y = 22.5;
  total_z = wall + extra_for_better_removal;

  // This only works if anchor is BOT where this is attatched
  down(extra_for_better_removal / 2)
    attachable(anchor = anchor, spin = spin, orient = orient, size = [ total_x, total_y, total_z ])
  {
    cuboid([ total_x, total_y, total_z ]);
    children();
  }
}

module microbit_connector_inside(anchor = CENTER, spin = 0, orient = UP)
{
  pin_width = 0.5;
  pin_distance = 1.278;

  connector_rests_side_width = 11.6;
  connector_rests_middle_width = 24.3;

  connector_y = 10.5;
  connector_short_rest_y = 8;
  connector_z = 10.4;

  wall = 2;

  fastener_x = 7;
  fastener_hole_width = 1.6;
  fastener_width_against_center = 0.9;
  fastener_hole_extra_offset = 0.8;
  fastener_y = 3;
  total_x = mb_connector_x +
            (fastener_x - fastener_width_against_center - fastener_hole_width - fastener_hole_extra_offset) * 2;
  fastener_spacing = total_x;

  fastener_height = 5.8;
  fastener_total_height = fastener_height + 2;
  fastener_offset_z = 1;

  total_y = 18;
  total_z = wall + fastener_total_height - fastener_offset_z; // this is not accurate, but it's good enough for now

  echo("microbit_connector_inside total_x", total_x);

  size = [ total_x, total_y, total_z ];

  attachable(anchor = anchor, spin = spin, orient = orient, size = size)
  {
    down(total_z / 2) tag_diff("keep", keep = "keep_always") cuboid([ total_x, total_y, wall ], anchor = BOT)
    {
      // Holes for the connector
      back(5.4)
      {
        tag("remove") position(FWD) xcopies(spacing = 54.4, n = 2)
          cuboid([ 2.8, connector_y, wall + extra_for_better_removal ], anchor = FWD);
        tag("remove") position(FWD) back(connector_y - connector_short_rest_y) xcopies(spacing = 26.4, n = 2)
          cuboid([ 2.1, connector_short_rest_y, wall + extra_for_better_removal ], anchor = FWD);
      }

      // Holes for the pins
      tag("remove") position(FWD + BOT) fwd(extra_for_better_removal) down(extra_for_better_removal / 2) cuboid(
        [ 50.6, fastener_height + extra_for_better_removal, total_z + extra_for_better_removal ], anchor = FWD + BOT);
      // tag("remove") position(FWD) back(fastener_y)
      //   cuboid([ 50.4, 5 - fastener_y, wall + extra_for_better_removal ], anchor = FWD);

      // Holes for fasteners
      position(TOP + FWD) xcopies(n = 2, spacing = fastener_spacing)
      {

        fastener_extra_y_to_remove_from_fastener_base = 2.5;
        // These values need to be adjusted if angle is changed
        offset_anchor = $idx == 0 ? LEFT : RIGHT;
        offset_anchor_hole = $idx == 0 ? RIGHT : LEFT;
        offset_x = $idx == 0 ? -1 : 1;
        down(fastener_offset_z) left(offset_x * 0)
          cuboid([ fastener_x, fastener_y, fastener_total_height ], anchor = BOT + FWD + offset_anchor)
        {
          tag("remove") right(offset_x * fastener_width_against_center) position(BOT + FWD + offset_anchor_hole)
            fwd(extra_for_better_removal) cuboid(
              [ fastener_hole_width, fastener_y + fastener_extra_y_to_remove_from_fastener_base, fastener_height ],
              anchor = BOT + FWD + offset_anchor_hole);
        }
      }
    }
    children();
  }
}

module microbit_connector_inside_hole(wall, anchor = CENTER, spin = 0, orient = UP)
{
  // Warning: Numbers repeated
  fastener_x = 7;
  fastener_hole_width = 1.6;
  fastener_width_against_center = 0.9;
  fastener_hole_extra_offset = 0.8;
  fastener_y = 3;
  total_x = mb_connector_x +
            (fastener_x - fastener_width_against_center - fastener_hole_width - fastener_hole_extra_offset) * 2;

  total_y = 18;
  total_z = wall + extra_for_better_removal;

  // This only works if anchor is BOT where this is attatched
  down(extra_for_better_removal / 2)
    attachable(anchor = anchor, spin = spin, orient = orient, size = [ total_x, total_y, total_z ])
  {
    cuboid([ total_x, total_y, total_z ]);
    children();
  }
}

module microbit_battery_pack(anchor = CENTER, spin = 0, orient = UP)
{
  battery_pack_space_x = MICROBIT_BATTERY_PACK_X;
  battery_pack_space_y = MICROBIT_BATTERY_PACK_Y;
  battery_pack_space_z = MICROBIT_BATTERY_PACK_Z;
  attachable(anchor = anchor, spin = spin, orient = orient,
             size = [ battery_pack_space_x, battery_pack_space_y, battery_pack_space_z ])
  {
    cuboid([ battery_pack_space_x, battery_pack_space_y, battery_pack_space_z ]);
    children();
  }
}

module microbit_battery_pack_wire_hole(wall, anchor = CENTER, spin = 0, orient = UP)
{
  x = 6;
  y = 4.5;
  // This only works if anchor is BOT where this is attatched
  down(extra_for_better_removal / 2)
    attachable(anchor = anchor, spin = spin, orient = orient, size = [ x, y, wall + extra_for_better_removal ])
  {
    cuboid([ x, y, wall + extra_for_better_removal ]);
    children();
  }
}

module microbit_connector_fastener()
{
  connector_fastener_w = 2.4;
  connector_fastener_w_max = 5.4;
  connector_fastener_l = 11;
  connector_fastener_h = 1.5;
  connector_fastener_head_size = 3;
  connector_fastener_head_y = 8;

  cuboid([ connector_fastener_l + connector_fastener_head_size / 2, connector_fastener_w, connector_fastener_h ],
         anchor = BOT, chamfer = connector_fastener_h / 2, edges = [RIGHT])
  {
    back((connector_fastener_head_y - connector_fastener_w_max) / 2) position(BOT + LEFT + BACK)
      cuboid([ connector_fastener_head_size, connector_fastener_head_y, connector_fastener_h ], anchor = BOT + BACK,
             rounding = 0);

    // fwd(3.5) position(BOT) xcyl(d = 1.1, h = connector_fastener_l + connector_fastener_head_size / 2, anchor = BOT);

    position(BOT + LEFT + BACK)
      cuboid([ 8, connector_fastener_w_max, connector_fastener_h ], anchor = BOT + LEFT + BACK);
  }
}

module microbit_soldering_guide(text = "micro:bit", pins_to_show = [], pins_to_bend = [], pins_to_bend_short = [],
                                pin_text = "40...1")
{
  pin_width = 0.5;
  pin_space_width = 0.4;
  pin_distance = 1.278;
  bend_length = 6;
  bend_length_short = 3;

  extra_rest = 3 * 2;

  diff() cuboid([ 51.2 + extra_rest, 11, 1 ])
  {
    position(TOP + FWD) cuboid([ 51.2 + extra_rest, 1, 9 ], anchor = TOP + FWD);
    position(TOP) xcopies(n = 2, spacing = 51.2 + extra_rest + 1) cuboid([ 1, 11, 9 ], anchor = TOP);
    // Markings for pins
    color("red") position(TOP + BACK)
    {
      // All the pins for reference
      // xcopies(spacing = pin_distance, n = 40) cuboid([ pin_width, 2, 0.2 ], anchor = BOT + FWD);

      // Walls between pins
      // fwd(2) down(1) xcopies(spacing = pin_distance, n = 39) cuboid([ pin_space_width, 3, 2 ], anchor = BOT + FWD);

      // Use 40+1 so we can have pin 1 at right(1*pin_distance), etc.
      fwd(0) right((40 + 1) * pin_distance / 2)
      {
        for (pin_to_show = pins_to_show)
        {
          left(pin_to_show * pin_distance) { cuboid([ pin_width, 4 + bend_length, 0.2 ], anchor = BOT + BACK); }
        }
      }

      right((40 + 1) * pin_distance / 2)
      {
        for (pin_to_bend = pins_to_bend)
        {
          left(pin_to_bend * pin_distance)
          {
            tag("remove") back(extra_for_better_removal) up(1)
              cuboid([ pin_width * 1.6, bend_length + extra_for_better_removal, 3 ], anchor = TOP + BACK);
          }
        }

        for (pin_to_bend = pins_to_bend_short)
        {
          left(pin_to_bend * pin_distance)
          {
            tag("remove") back(extra_for_better_removal) up(1)
              cuboid([ pin_width * 1.6, bend_length_short + extra_for_better_removal, 3 ], anchor = TOP + BACK);
          }
        }
      }
    }
    color("red") back(1) position(TOP + FWD + LEFT)
      text3d(pin_text, h = 0.2, size = 4, font = "Arial", orient = UP, spin = 0, anchor = BOT + FWD + LEFT);

    // Header text
    fwd(0.5) color("red") position(TOP + BACK + LEFT)
      text3d(text, h = 0.2, size = 4, font = "Arial", orient = UP, spin = 0, anchor = BOT + BACK);
  }
}

module microbit_soldering_guide_v1(text = "micro:bit", pins_to_show = [], pins_to_bend = [], pin_text = "40...1")
{
  pin_width = 0.5;
  pin_space_width = 0.4;
  pin_distance = 1.278;

  y_for_the_bender = 1.6;

  diff() cuboid([ 51.2, 12 + y_for_the_bender, 1 ])
  {
    position(TOP + FWD) cuboid([ 51.2, y_for_the_bender, 10 ], anchor = TOP + FWD);

    // Holes for the plastic in the connector top
    tag("remove") down(extra_for_better_removal / 2) position(BOT) xcopies(n = 2, spacing = 26.5)
      cuboid([ 2, 7.5, 1 + extra_for_better_removal ], anchor = BOT);

    // Markings for pins
    color("red") position(TOP + FWD)
    {
      // All the pins for reference
      // xcopies(spacing = pin_distance, n = 40) cuboid([ pin_width, 2, 0.2 ], anchor = BOT + FWD);

      // Walls between pins
      // fwd(2) down(1) xcopies(spacing = pin_distance, n = 39) cuboid([ pin_space_width, 3, 2 ], anchor = BOT + FWD);

      // Use 40+1 so we can have pin 1 at right(1*pin_distance), etc.
      back(0 + y_for_the_bender) right((40 + 1) * pin_distance / 2)
      {
        for (pin_to_show = pins_to_show)
        {
          left(pin_to_show * pin_distance) { cuboid([ pin_width, 4, 0.2 ], anchor = BOT + FWD); }
        }
      }

      right((40 + 1) * pin_distance / 2)
      {
        for (pin_to_bend = pins_to_bend)
        {
          left(pin_to_bend * pin_distance)
          {
            tag("remove") fwd(extra_for_better_removal) up(extra_for_better_removal)
              cuboid([ pin_width * 1.5, y_for_the_bender + extra_for_better_removal, 4 + extra_for_better_removal ],
                     anchor = TOP + FWD);
          }
        }
      }

      back(1.6 + y_for_the_bender) position(LEFT)
        text3d(pin_text, h = 0.4, size = 4, font = "Arial", orient = UP, spin = 0, anchor = BOT + FWD + LEFT);
    }

    // Header text
    fwd(1) color("red") position(TOP + BACK)
      text3d(text, h = 0.2, size = 4, font = "Arial", orient = UP, spin = 0, anchor = BOT + BACK);
  }
}