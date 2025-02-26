// clang-format off
include<BOSL2\screws.scad>;
include<box.scad>;
include<el-parts.scad>;
include<jst.scad>;
include<microbit.scad>;
include<misc.scad>;
// clang-format on
$slop = 0.08;

part = "screw_test";

if (part == "box")
{
  box_sliding(64, 104, 20, wall = 2.4, inner_walls = []);
}
else if (part == "lid")
{
  box_sliding_lid(50, 50, 20, wall = 2.4, $slop = 0.09, anchor = BOT);
}
else if (part == "microbit_connector_flush")
{
  microbit_connector_flush(show_buttons = false, anchor = BOT);
}
else if (part == "microbit_connector")
{
  // microbit_connector_inside(anchor = BOT);
  // microbit_connector(pins_to_show = [ 1, 23, 24, 25, 26, 35 ], pin_text = " G         23...1   ");
}
else if (part == "microbit_connector_fastener")
{
  microbit_connector_fastener();
}
else if (part == "button_grid")
{
  button_grid(n = [ 2, 2 ]);
}
else if (part == "toggle_button_grid")
{
  diff() cuboid([ 30, 40, 2.4 ], anchor = BOT)
  {
    tag("remove") position(BOT)
      toggle_button_grid_hole(wall = 2.4, n = [ 2, 2 ], use_minimal_spacing = true, anchor = BOT);
    tag("keep") position(BOT) toggle_button_grid(n = [ 2, 2 ], use_minimal_spacing = true, anchor = BOT);
  }
}
else if (part == "button_fastener_stick")
{
  button_fastener_stick(n = 2);
}
else if (part == "button_fastener")
{
  button_fastener($slop = 0.08);
}
else if (part == "button_fastener_long")
{
  // button_fastener_long(gap = 52, $slop = 0.08);
  button_fastener_long(gap = 12.6, $slop = 0.08);
}
else if (part == "button_cap")
{
  button_cap(size = [ 10, 16 ], offset = [ 0, 0 ]);
}
else if (part == "jst")
{
  xdistribute(spacing = 20)
  {
    jst_male(n = 4);
    jst_female(n = 4);
  }
}
else if (part == "four_digit_display_seeed_studio")
{
  // fwd(50) four_digit_display_seeed_studio(orient = DOWN);

  diff() cuboid([ 60, 26, 1.2 ], anchor = BOT)
  {
    tag("remove") position(BOT + LEFT) four_digit_display_seeed_studio_hole(wall = 1.2, anchor = BOT + LEFT);
    tag("keep") position(BOT + LEFT) four_digit_display_seeed_studio(anchor = BOT + LEFT);

    left(3)
    {
      tag("remove") position(BOT + RIGHT) small_on_off_switch_hole(wall = 1.2, anchor = BOT + RIGHT);
      tag("keep") position(BOT + RIGHT) small_on_off_switch(anchor = BOT + RIGHT);
    }
  }
}
else if (part == "sliding_potentiometer")
{
  diff() cuboid([ 80, 20, 2.4 ], anchor = BOT)
  {
    tag("remove") position(BOT) sliding_potentiometer_hole(wall = 2.4, anchor = BOT);
    tag("keep") position(BOT) sliding_potentiometer(wall = 2.4, anchor = BOT);
  }
}
else if (part == "sliding_potentiometer_knob")
{
  sliding_potentiometer_knob();
}
else if (part == "plug_four_digit_display_seeed_studio")
{
  plug_four_digit_display_seeed_studio();
}
else if (part == "push_card_test_2x2_old")
{
  controller_x = 45;
  controller_y = 45;
  controller_z = 5;
  wall = 2.4;

  push_card_x = 35;
  push_card_y = 35;
  push_card_extra_margin = 0.4;
  push_card_hole_x = push_card_x + push_card_extra_margin;
  push_card_hole_y = push_card_y + push_card_extra_margin;
  push_card_hole_z = 2;
  button_grid_standard_wall = 2;
  button_grid_extra_height_to_hide_buttons_z = 3.5;
  button_grid_wall = button_grid_standard_wall + button_grid_extra_height_to_hide_buttons_z + push_card_hole_z;
  // diff() box_sliding(controller_x, controller_y, controller_z, wall, anchor = BOT)

  difference()
  {

    diff() cuboid([ controller_x, controller_y, wall ], anchor = BOT)
    {
      position(BOT)
      {
        // Buttons
        tag("remove") button_grid_hole(wall = wall, n = [ 2, 2 ], use_minimal_spacing = true, anchor = BOT);
        tag("keep") button_grid(n = [ 2, 2 ], use_minimal_spacing = true, wall = button_grid_wall, anchor = BOT);
      }
    }

    down(extra_for_better_removal) diff()
      cuboid([ push_card_hole_x, push_card_hole_y, push_card_hole_z + extra_for_better_removal ], anchor = BOT)
    {
      tag("remove") position(RIGHT + FWD) cuboid([ 10, 10, 10 ], spin = 45);
    }
  }
}
else if (part == "push_card_test_2x2")
{
  controller_x = 45;
  controller_y = 45;
  controller_z = 5;
  wall = 2.4;

  push_card_x = 35;
  push_card_y = 35;
  push_card_extra_margin = 0.4;
  push_card_hole_x = push_card_x + push_card_extra_margin;
  push_card_hole_y = push_card_y + push_card_extra_margin;
  push_card_hole_z = 2;
  button_grid_standard_wall = 2;
  button_grid_extra_height_to_hide_buttons_z = 3.5;
  button_grid_wall = button_grid_standard_wall + button_grid_extra_height_to_hide_buttons_z + push_card_hole_z;
  // diff() box_sliding(controller_x, controller_y, controller_z, wall, anchor = BOT)

  button_grid(n = [ 2, 2 ], use_minimal_spacing = true, wall = button_grid_wall, anchor = BOT);

  // difference()
  // {

  //   diff() cuboid([ controller_x, controller_y, wall ], anchor = BOT)
  //   {
  //     position(BOT)
  //     {
  //       // Buttons
  //       tag("remove") button_grid_hole(wall = wall, n = [ 2, 2 ], use_minimal_spacing = true, anchor = BOT);

  //     }
  //   }

  //   down(extra_for_better_removal) diff()
  //     cuboid([ push_card_hole_x, push_card_hole_y, push_card_hole_z + extra_for_better_removal ], anchor = BOT)
  //   {
  //     tag("remove") position(RIGHT + FWD) cuboid([ 10, 10, 10 ], spin = 45);
  //   }
  // }
}
else if (part == "push_card_test_2x2_card")
{
  visible_buttons = [ true, false, true, true ];
  push_card_x = 35;
  push_card_y = 35;
  push_card_z = 2;
  button_spacing = 18;
  punch_d = 5;
  punch_h = 1;

  num_of_buttons = 2;

  diff() cuboid([ push_card_x, push_card_y, push_card_z ], anchor = BOT)
  {
    tag("remove") position(LEFT + FWD) cuboid([ 10, 10, 10 ], spin = 45);

    position(TOP) grid_copies(n = num_of_buttons, spacing = button_spacing)
    {
      if (visible_buttons[$idx])
      {
        zcyl(d = punch_d, h = punch_h, anchor = BOT);
      }
    }
  }
}
else if (part == "push_card_test_2x2_card_2")
{
  visible_buttons = [ false, true, false, false ];
  push_card_x = 35;
  push_card_y = 35;
  push_card_z = 2;
  button_spacing = 18;
  punch_d = 5;
  punch_h = 1;

  num_of_buttons = 2;

  diff() cuboid([ push_card_x, push_card_y, push_card_z ], anchor = BOT)
  {
    tag("remove") position(LEFT + FWD) cuboid([ 10, 10, 10 ], spin = 45);

    position(TOP) grid_copies(n = num_of_buttons, spacing = button_spacing)
    {
      if (visible_buttons[$idx])
      {
        zcyl(d = punch_d, h = punch_h, anchor = BOT);
      }
    }
  }
}
else if (part == "screw_test")
{
  // Screw head hole with reinforcement
  diff() cuboid([ 20, 20, 1.2 ], anchor = BOT)
  {
    position(TOP) zcyl(d = 10, h = 2, anchor = BOT);
#position(BOT) screw_hole("#6-32", head = "flat", length = 5, anchor = TOP, orient = DOWN);
  }

  left(30)
    // Screw hole
    diff() cuboid([ 15, 15, 10 ], anchor = BOT)
  {
#position(TOP) screw_hole("#4-32", length = 6, anchor = TOP);
  }
}