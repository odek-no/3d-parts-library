// clang-format off
include<BOSL2\std.scad>;
include<BOSL2\threading.scad>;
include<el-parts.scad>;
// clang-format on

$fn = $preview ? 64 : 200;

extra_for_better_removal = 0.001;

led_with_cap_d = 7.1;
led_d = 5.1;
led_extra_wall = 2.5;
led_shine_through_z = 0.4;
led_shine_through_d = 10;

big_button_pitch = 4;

function calculate_base_d(cap_d, cap_wall) = let(margin_button_and_base = 2) cap_d
                                             - cap_wall * 2 - margin_button_and_base;

function calculate_button_spacing(cap_d, cap_wall, base_wall, chamfer, rounding) =
  let(base_d = calculate_base_d(cap_d, cap_wall), inner_base_d = base_d - base_wall * 2, button_size = 12.06,
      button_grid_extra_spacing_for_fasteners_etc = 4, square_length = inner_base_d * sqrt(2) / 2) square_length
  - button_size - button_grid_extra_spacing_for_fasteners_etc - (chamfer ? chamfer * 1.4 : rounding * 1.4);

module big_button_cap(d = 90, height = 20, wall = 1.2, base_wall = 2, chamfer = 5, rounding = undef)
{
  cap_tactile_button_inner_height = 2.5;
  cap_tactile_button_extra_height = 0;
  tactile_button_d = 7.0;
  tactile_button_wall = 3;

  button_spacing = calculate_button_spacing(d, wall, base_wall, chamfer, rounding);
  tactile_button_row_count = button_spacing > 18 ? 2 : 1;
  echo("button_spacing", button_spacing);

  diff() zcyl(h = height, d = d, anchor = BOT, chamfer2 = chamfer, rounding2 = rounding)
  {
    tag("remove") down(extra_for_better_removal) position(BOT)
      zcyl(h = height - wall + extra_for_better_removal, d = d - wall * 2, anchor = BOT, chamfer2 = chamfer,
           rounding2 = rounding);

    // Thinner wall to let led shine thorugh
    tag("remove") position(TOP) down(led_shine_through_z)
      zcyl(h = wall - led_shine_through_z + extra_for_better_removal, d1 = led_shine_through_d + 5,
           d2 = led_shine_through_d, anchor = TOP);

    tag("keep") position(TOP) down(wall) grid_copies(n = tactile_button_row_count, spacing = button_spacing)
    {
      down(cap_tactile_button_extra_height)
        tube(wall = tactile_button_wall, id = tactile_button_d, height = cap_tactile_button_inner_height, anchor = TOP);
      if (cap_tactile_button_extra_height > 0)
      {
        zcyl(d = tactile_button_d + tactile_button_wall * 2, h = cap_tactile_button_extra_height, anchor = TOP);
      }
    }
  }
}

module big_button_base(cap_d = 90, height = 20, wall = 2, cap_wall = 1.2, chamfer = 5, rounding = undef, $slop = 0.30)
{
  l_rod = 9;

  base_height = height;

  base_d = calculate_base_d(cap_d, cap_wall);
  inner_base_d = base_d - wall * 2;
  rod_d = base_d - 4;
  inner_rod_d = rod_d - wall * 4;

  echo("base_d and rod_d", base_d, rod_d);

  button_spacing = calculate_button_spacing(cap_d, cap_wall, wall, chamfer, rounding);
  tactile_button_row_count = button_spacing > 18 ? 2 : 1;
  echo("button_spacing", button_spacing);

  diff() zcyl(h = base_height, d = base_d, anchor = BOT, chamfer2 = chamfer, rounding2 = rounding)
  {
    // Space inside
    tag("remove") position(BOT) down(extra_for_better_removal)
      zcyl(h = base_height - wall + extra_for_better_removal, d = inner_base_d, anchor = BOT, chamfer2 = chamfer,
           rounding2 = rounding);

    // Extra tube to rest rod on
    // TODO: rod_d
    tag("keep") position(BOT)
      tube(h = 3, od1 = inner_base_d, id1 = inner_rod_d, od2 = base_d, id2 = inner_base_d, anchor = BOT);

    // The rod
    position(BOT) threaded_rod(d = rod_d, l = l_rod, pitch = big_button_pitch, anchor = TOP)
    {
      tag("remove") zcyl(d = inner_rod_d, h = l_rod + extra_for_better_removal);
    }

    // TODO: do this with tags instead
    difference()
    {
      wall_button_grid = 3;
      union()
      {
        // Buttons
        position(TOP)
        {
          tag("remove") button_grid_hole(wall, n = [ tactile_button_row_count, tactile_button_row_count ],
                                         spacing = [ button_spacing, button_spacing ], orient = DOWN, anchor = BOT);
          tag("keep")
            button_grid(n = [ tactile_button_row_count, tactile_button_row_count ],
                        spacing = [ button_spacing, button_spacing ], markings = [], anchor = BOT, orient = DOWN);
        }

        // Led extra wall
        tag("keep") position(TOP) zcyl(d = led_d + wall * 2, h = wall_button_grid + led_extra_wall, anchor = TOP);
      }

      // Led

      tag("keep") up(extra_for_better_removal / 2) position(TOP)
        zcyl(d = led_d, h = wall_button_grid + led_extra_wall + extra_for_better_removal, anchor = TOP);
    }
  }
}

module big_button_bottom_threaded_hole(cap_d = 90, wall = 2, cap_wall = 1.2, anchor = CENTER, spin = 0, orient = UP,
                                       $slop = 0.30)
{
  l_thread = 11;

  base_d = calculate_base_d(cap_d, cap_wall);
  outer_wall_d = base_d + wall * 2;
  rod_d = base_d - 4;

  echo("base_d and rod_d", base_d, rod_d);
  echo("outer_wall_d", outer_wall_d);

  total_d = outer_wall_d;
  total_z = l_thread;

  attachable(anchor = anchor, spin = spin, orient = orient, d = total_d, h = total_z)
  {
    tag_diff("keep", keep = "keep_always") zcyl(d = outer_wall_d, h = l_thread)
    {
      tag("remove")
        threaded_rod(d = rod_d, l = l_thread + extra_for_better_removal, pitch = big_button_pitch, internal = true);
    }

    children();
  }
}

module big_button_bottom_threaded_hole_hole(wall, cap_d = 90, bottom_wall = 2, cap_wall = 1.2, anchor = CENTER,
                                            spin = 0, orient = UP)
{
  base_d = calculate_base_d(cap_d, cap_wall);
  inner_base_d = base_d - bottom_wall * 2;
  rod_d = base_d - 4;
  echo("base_d and rod_d", base_d, rod_d);
  total_d = rod_d;

  total_z = wall + extra_for_better_removal;

  // This only works if anchor is BOT where this is attatched

  down(extra_for_better_removal / 2) attachable(anchor = anchor, spin = spin, orient = orient, d = total_d, h = total_z)
  {
    zcyl(d = total_d, h = total_z);
    children();
  }
}

module big_button_bottom(size = 105, cap_d = 90, height = 18, wall = 2, cap_wall = 1.2, chamfer = undef, rounding = 2,
                         use_cyl_bottom = true)
{
  l_rod = 9;
  l_hole = height + l_rod - wall;

  base_d = calculate_base_d(cap_d, cap_wall);
  inner_base_d = base_d - wall * 2;
  echo("inner_base_d aka rod_d", inner_base_d);

  diff() threaded_rod(d = inner_base_d, l = l_rod, pitch = big_button_pitch, anchor = BOT)
  {
    tag("remove") position(TOP) up(extra_for_better_removal)
      zcyl(d = inner_base_d - wall * 2 - 2, h = l_hole + extra_for_better_removal, anchor = TOP);

    if (use_cyl_bottom)
    {
      position(BOT) zcyl(d = size, h = height, anchor = TOP, chamfer = chamfer, rounding = rounding)
      {
        tag("remove") zcyl(d = size - wall * 2, h = height - wall * 2, chamfer = chamfer, rounding = rounding);
      }
    }
    else
    {
      position(BOT) cuboid([ size, size, height ], chamfer = chamfer, rounding = rounding, anchor = TOP)
      {
        tag("remove")
          cuboid([ size - wall * 2, size - wall * 2, height - wall * 2 ], chamfer = chamfer, rounding = rounding);
      }
    }
  }
}
