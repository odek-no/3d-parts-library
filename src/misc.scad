// clang-format off
include<BOSL2\std.scad>;
include<box.scad>;
// clang-format on

$fn = $preview ? 64 : 200;

extra_for_better_removal = 0.001;

// Fore wire_d 1.1 and 1.4

module wire_cutter_guide_as_sliding_lid(d = 1.4)
{
  wire_cutter_offset_x = 0.4;
  base_x = 16 / 2 - wire_cutter_offset_x + 10;
  base_y = 30;
  ruler_x = 100;
  ruler_y = 30;
  box_wall = 2.4;

  box_x = 40;
  box_y = 122;

  tag_diff("keep", keep = "keep_always")
    box_sliding_lid(box_x, box_y, wall = box_wall, use_simple_lock = false, anchor = TOP, $slop = 0.1, orient = DOWN)
  {
    tag("remove") cuboid([ base_y, box_y, box_wall ]);
    tag("keep_always") position(TOP) back(base_x / 2) fwd((ruler_x + base_x) / 2) zrot(-90) yrot(180)
      wire_cutter_guide(d);
  }
}

module wire_cutter_guide_sliding_box(height = 15)
{
  box_wall = 2.4;
  box_x = 40;
  box_y = 122;
  diff() box_sliding(box_x, box_y, height, wall = box_wall, anchor = BOT)
  {
    // Hole for lid_for_drop_zone
    tag("remove") position(TOP + BACK) cuboid([ 10 + 1, box_wall, box_wall + 1 ], anchor = TOP + BACK);
  }
}

module wire_cutter_guide(d = 1.4)
{
  wire_cutter_offset_x = 0.4;
  wire_1_1_d = 1.6;
  wire_1_4_d = 1.9;
  base_x = 16 / 2 - wire_cutter_offset_x + 10;
  base_y = 30;
  ruler_x = 100;
  ruler_y = 30;
  wire_d = d == 1.1 ? wire_1_1_d : wire_1_4_d;
  wire_d_offset_z = 0.4;
  total_x = base_x + ruler_x + extra_for_better_removal;
  // Making this llarger than 2.4 makes something weird with the ruler lines and ruler numbers.
  // Need to fix model in Bamu to make it print the lines and numbers.
  bottom_lid_z = 3.2; // 2.4;
  bottom_lid_y = 10;  // 2.4;
  bottom_lid_x = ruler_x;
  bottom_lid_extra_margin_top_z = 0.4;
  base_z = wire_d + wire_d_offset_z + bottom_lid_z + bottom_lid_extra_margin_top_z;
  ruler_z = base_z;
  ruler_solid_end_y = 5;
  tag_scope() diff() cuboid([ base_x, base_y, base_z ], anchor = BOT)
  {

    // Hole for wire
    up(ruler_z - wire_d - wire_d_offset_z) position(BOT + LEFT) left(extra_for_better_removal / 2) tag("remove")
      xcyl(d = wire_d, h = total_x - ruler_solid_end_y, anchor = BOT + LEFT)
    {
      // Tube to guide wire inside hole after beeing cut
      right(base_x) position(LEFT) xcyl(l = 10, d1 = wire_d + 2, d2 = wire_d, anchor = LEFT);
    }

    // Wire text
    // wire_text = str("d=", d, " mm");
    // color("red") fwd(1) right(5) position(TOP + LEFT)
    //   text3d(wire_text, h = 0.2, size = 5, font = "Arial", anchor = BOT + LEFT);

    // Holder for cutter
    right(wire_cutter_offset_x) down(wire_d + wire_d_offset_z + 1) position(TOP + RIGHT)
      cuboid([ 16, base_y, 11 ], anchor = BOT)
    {
      tag("remove") right(4.5) down(extra_for_better_removal / 2) position(BOT + LEFT)
        cuboid([ 3.5, 11, 10 + extra_for_better_removal ], anchor = BOT + LEFT);

      position(TOP) right(0.483) down(2.738) yrot(-20) cuboid([ 16, base_y, 20 ], anchor = BOT)
      {
        tag("remove") up(extra_for_better_removal / 2) position(TOP)
          cuboid([ 5.5, 14, 20 + extra_for_better_removal ], anchor = TOP);

        left(1.5) tag("remove") up(extra_for_better_removal / 2) position(TOP)
          zcyl(d = 10, h = 20 + extra_for_better_removal, anchor = TOP);

        right(1.5) tag("remove") up(extra_for_better_removal) position(TOP)
          zcyl(d = 10, h = 10 + extra_for_better_removal, anchor = TOP);
      }
    }

    // Ruler
    position(BOT + RIGHT) cuboid([ ruler_x, ruler_y, ruler_z ], anchor = BOT + LEFT)
    {
      // Visible space on top of ruler
      position(TOP + LEFT) up(extra_for_better_removal + 0.2) tag("remove")
        cuboid([ ruler_x - ruler_solid_end_y, 0.8, 0.2 + wire_d_offset_z + wire_d / 2 + extra_for_better_removal ],
               anchor = TOP + LEFT);

      // Drop zone?
      position(BOT + RIGHT) left(5) down(extra_for_better_removal) tag("remove")
        cuboid([ ruler_x - 2 - 5, wire_d, ruler_z - wire_d_offset_z - wire_d / 2 + extra_for_better_removal ],
               anchor = BOT + RIGHT);

      // Holes for a stop pin
      down(wire_d_offset_z + wire_d / 2 - 1.4 / 2) position(TOP) tag("remove") xcopies(n = 19, spacing = 5)
      {
        cuboid([ 1.4, ruler_y + extra_for_better_removal, 1.4 + 0.4 ], anchor = TOP + LEFT);
      }

      // Ruler lines
      color("red") position(TOP)
      {
        xcopies(n = 11, spacing = 10) { cuboid([ 0.4, 15, 0.2 ], anchor = BOT + RIGHT); }
      }
      color("green") position(TOP) { xcopies(n = 10, spacing = 10) cuboid([ 0.4, 10, 0.2 ], anchor = BOT + RIGHT); }

      // Ruler numbers
      yflip_copy()
      {
        text_orient = $idx == 0 ? UP : DOWN;
        text_anchor = $idx == 0 ? BOT : TOP;
        color("red") position(TOP + FWD)
        {
          xcopies(n = 11, spacing = 10)
          {
            if ($idx > 0 && $idx < 10)
            {
              back(2) text3d(str($idx), h = 0.2, size = 4, font = "Arial", anchor = text_anchor, orient = text_orient);
            }
          }
        }
      }

      // Hole for lid
      tag("remove") down(extra_for_better_removal) right(extra_for_better_removal) position(BOT + RIGHT)
        cuboid([ bottom_lid_x, bottom_lid_y, bottom_lid_z + extra_for_better_removal ], chamfer = bottom_lid_z / 2,
               edges = [TOP], except = [ LEFT, RIGHT ], anchor = TOP + LEFT, orient = DOWN);
    }
  }
}

module wire_cutter_guide_lid_for_drop_zone($slop = 0.5)
{
  bottom_lid_z = 3.2;
  wall = bottom_lid_z - get_slop();

  ruler_x = 100;

  width = 10 - get_slop();
  length = ruler_x - 1;

  xrot(180) cuboid([ width, length, wall ], chamfer = wall / 2, edges = [TOP], except = [ FWD, BACK ], anchor = BOT)
  {
    position(FWD + TOP) cuboid([ width, 4, 8 ], anchor = BACK + TOP);
  }
}

module wire_cutter_guide_wire_stopper()
{
  cuboid([ 1.3, 20, 1.7 ], anchor = BOT) { position(FWD + BOT) cuboid([ 10, 4, 6 ], anchor = BOT + BACK); }
}

module wire_holder(count = 1)
{
  base_y = 30;
  base_h = 2.4;
  extra_h = 20;
  holder_h = 10;
  width = 1.2;
  spacing_between_holder_arms = 0.3;
  spacing_between_holders = 15;
  holder_y = 5;

  cuboid([ count * spacing_between_holders, base_y, base_h ], anchor = FWD, orient = FWD)
  {
    position(FWD) cuboid([ count * spacing_between_holders, holder_y, extra_h ], anchor = BOT + FWD) position(TOP)
      xcopies(n = count, spacing = spacing_between_holders)
    {
      xflip_copy(offset = width / 2 + spacing_between_holder_arms) cuboid([ width, holder_y, holder_h ], anchor = BOT)
      {
        position(TOP + LEFT) yrot(-45) cuboid([ 4, holder_y, width ], anchor = TOP + LEFT);
      }
    }
  }
}