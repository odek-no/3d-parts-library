// clang-format off
include<BOSL2\std.scad>;
// clang-format on

$fn = $preview ? 64 : 200;

extra_for_better_removal = 0.001;

mb_x = 51.6;
mb_y = 42.1;

module microbit_connector(pins_to_show = [], pin_text = "40...1", anchor = CENTER, spin = 0, orient = UP)
{
  pin_width = 0.5;
  pin_distance = 1.278;

  degree = 40;
  connector_rests_side_width = 11.6;
  connector_rests_middle_width = 24.3;

  well_offset_z = degree == 40 ? 7.2 : 0;
  well_offset_y = degree == 40 ? 0.3 : 0;

  connector_x = 57.2;
  connector_y = 10.5;
  connector_z = 10.4;

  wall = 3;

  fastener_x = 5.6;
  fastener_y = 3;
  fastener_spacing = connector_x - fastener_x + 2;
  total_x = fastener_spacing + fastener_x;
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
          tag("remove") cuboid([ connector_x, connector_y, 15 ], anchor = CENTER);

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

        back(4.9) position(RIGHT)
          text3d(pin_text, h = 0.2, size = 4, font = "Arial", orient = UP, spin = 180, anchor = BOT + FWD + LEFT);
      }
    }
    children();
  }
}

module microbit_connector_hole(wall, anchor = CENTER, spin = 0, orient = UP)
{
  // Warning: Numbers repeated from microbit_connector module
  connector_x = 57.2;
  fastener_x = 5.6;
  fastener_spacing = connector_x - fastener_x + 2;
  total_x = fastener_spacing + fastener_x;
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

module microbit_battery_pack(anchor = CENTER, spin = 0, orient = UP)
{
  battery_pack_space_x = 53.5;
  battery_pack_space_y = 25.8;
  battery_pack_space_z = 15.0;
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

module microbit_soldering_guide(text = "micro:bit", pins_to_show = [], pins_to_bend = [], pin_text = "40...1")
{
  pin_width = 0.5;
  pin_space_width = 0.4;
  pin_distance = 1.278;
  bend_length = 5;

  diff() cuboid([ 51.2, 11, 1 ])
  {
    position(TOP + FWD) cuboid([ 51.2, 1, 9 ], anchor = TOP + FWD);
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
      }
    }
    color("red") back(1) position(TOP + FWD + LEFT)
      text3d(pin_text, h = 0.4, size = 4, font = "Arial", orient = UP, spin = 0, anchor = BOT + FWD + LEFT);
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