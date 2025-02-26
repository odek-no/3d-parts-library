// clang-format off
include<BOSL2\std.scad>;
include<BOSL2\rounding.scad>;
include<BOSL2\screws.scad>;
include<shapes.scad>;

// clang-format on

$fn = $preview ? 32 : 200;

standard_wall = 1.2;
extra_for_better_removal = 0.001;

w = heart_shape_width(200);
l = heart_shape_length(200);
echo(w, l);
back(l / 2) shaped_box(heart_shape(200), w, l, 100, anchor = BOT);

module shaped_box(shape, width, length, height, wall = standard_wall, rounding = 2, anchor = CENTER, spin = 0,
                  orient = UP)
{
  rounding_r = $preview ? 0 : rounding;

  shape_inner = offset(shape, delta = -wall);

  size = [ width, length, height ];
  attachable(anchor = anchor, spin = spin, orient = orient, size = size)
  {
    tag_scope() down(height / 2) diff() offset_sweep(
      shape, height = height, anchor = BOT, bottom = os_circle(r = rounding_r), top = os_circle(r = rounding_r))
    {
      position(TOP) up(extra_for_better_removal) tag("remove")
        offset_sweep(shape_inner, height - wall + extra_for_better_removal, anchor = TOP);

      // position(TOP) up(extra_for_better_removal) tag("remove")
      // offset_sweep(bat_inner_excluded_lid_rest, lid_rest_height + extra_for_better_removal, anchor = TOP);
    }

    children();
  }
}

module bat_box(width, height, wall = standard_wall, chamfer = 0, rounding = 2, screw_fasteners = [], anchor = CENTER,
               spin = 0, orient = UP)
{
  lid_rest = 1.2;
  lid_rest_height_margin = 0.4;
  lid_rest_height = wall + lid_rest_height_margin;
  lid_screw_head_reinforcement = 2;
  screw_fastener_height = height - wall - lid_rest_height - lid_screw_head_reinforcement;
  bat = bat_shape(width);
  bat_inner = offset(bat, delta = -wall - lid_rest);
  bat_inner_excluded_lid_rest = offset(bat, delta = -wall);

  // #region(offset(bat, delta = -4));

  rounding_r = $preview ? 0 : rounding;

  length = get_bat_shape_length(width);

  size = [ width, length, height ];
  attachable(anchor = anchor, spin = spin, orient = orient, size = size)
  {
    tag_scope() down(height / 2) diff() offset_sweep(
      bat, height = height, anchor = BOT, bottom = os_circle(r = rounding_r), top = os_circle(r = rounding_r))
    {
      position(TOP) up(extra_for_better_removal) tag("remove")
        offset_sweep(bat_inner, height - wall + extra_for_better_removal, anchor = TOP);

      position(TOP) up(extra_for_better_removal) tag("remove")
        offset_sweep(bat_inner_excluded_lid_rest, lid_rest_height + extra_for_better_removal, anchor = TOP);

      tag_diff("keep", keep = "keep_always") position(BOT) for (screw_fastener = screw_fasteners)
      {
        left(screw_fastener[0]) fwd(screw_fastener[1])
          cuboid([ 8, 8, height - wall * 2 - lid_rest_height_margin ], anchor = BOT)
        {
          tag("remove") position(TOP) screw_hole("#4-32", length = 6, anchor = TOP);
        }
      }
    }

    children();
  }
}

module bat_lid(width, wall = standard_wall, screw_fasteners = [], anchor = CENTER, spin = 0, orient = UP)
{
  lid_rest = 1.2;
  lid_screw_head_reinforcement = 2;
  lid_margin = 0.2;
  bat = bat_shape(width);
  bat_inner_excluded_lid_rest_with_margin = offset(bat, delta = -wall - lid_margin);

  total_width = width - (wall + lid_margin) * 2;
  total_length = get_bat_shape_length(width) - (wall + lid_margin) * 2;

  counter_bore = 0.8;

  size = [ total_width, total_length, height ];
  attachable(anchor = anchor, spin = spin, orient = orient, size = size)
  {
    tag_scope() down(height / 2) diff() offset_sweep(bat_inner_excluded_lid_rest_with_margin, wall)
    {
      for (screw_fastener = screw_fasteners)
      {
        left(screw_fastener[0]) fwd(screw_fastener[1])
        {
          position(TOP) zcyl(d = 8, h = lid_screw_head_reinforcement, anchor = BOT);
          position(BOT) screw_hole("#5-32", head = "flat large", length = wall + 5, anchor = TOP, orient = DOWN);
        }
      }
    }

    children();
  }
}