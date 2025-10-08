// clang-format off
include<BOSL2\std.scad>;
include<BOSL2\threading.scad>;
// clang-format on

$fn = $preview ? 32 : 200;

BOX_STANDARD_INNER_WALL = 1.2;

standard_wall = 2.4;
standard_lid_lip = 1;
extra_for_better_removal = 0.001;

// TODO: Make own module for internal walls. Could be grid, or something.

module box_cylinder(d, height, wall = 1.2, use_small_d_for_lid = false, holes = [], anchor = CENTER, spin = 0,
                    orient = UP, $slop = 0.3)
{
  rod_margin = use_small_d_for_lid ? 0 : 2;
  rod_margin_bottom = use_small_d_for_lid ? 1 : 0;
  threaded_l = 6 - wall;
  threaded_pitch = 3;
  // The $slop is "eaten" away when lid is same d as box, so need to compensate by removing from outer thread instead.
  threaded_d_min = use_small_d_for_lid ? d - wall * 2 - threaded_pitch - get_slop() * 4 : d;
  threaded_d_max = threaded_d_min + threaded_pitch;
  // This seems to work fine for pitch less than 5 at least. Not accurate when pitch is 10.
  threaded_d_pitch = threaded_d_min + threaded_pitch / 2 - 0.5;

  rod_rest_h = use_small_d_for_lid ? 3 : 0;

  empty_d = d - wall * 2;
  empty_height = use_small_d_for_lid ? height - wall - rod_rest_h : height - wall;

  empty_d_upper = threaded_d_min - wall * 2;
  empty_height_upper = threaded_l;

  rod_anchor = use_small_d_for_lid ? BOT : TOP;

  holes_extra_margin = use_small_d_for_lid ? 0 : rod_margin + threaded_l;

  attachable(anchor = anchor, spin = spin, orient = orient, d = d, l = height)
  {
    tag_scope() diff() zcyl(d = d, height = height, anchor = BOT)
    {
      tag("remove") up(wall + extra_for_better_removal) position(BOT)
        zcyl(d = empty_d, height = empty_height + extra_for_better_removal, anchor = BOT);

      if (use_small_d_for_lid)
      {
        // Remove inside of tube to rest rod on
        tag("remove") down(rod_rest_h - extra_for_better_removal / 2) position(TOP) zcyl(
          h = rod_rest_h + extra_for_better_removal, d1 = d - wall * 2, d2 = threaded_d_min - wall * 2, anchor = BOT);
      }

      position(TOP) down(rod_margin) up(rod_margin_bottom)
        threaded_rod(d = [ threaded_d_min, threaded_d_pitch, threaded_d_max ], l = threaded_l, pitch = threaded_pitch,
                     anchor = rod_anchor, internal = false)

      {
        if (use_small_d_for_lid)
        {
          // Hole in rod
          tag("remove") up(extra_for_better_removal) position(TOP)
            zcyl(d = empty_d_upper, height = empty_height_upper + rod_margin_bottom + extra_for_better_removal,
                 anchor = TOP);

          // Tube to handle margin bottom
          tag("keep") position(BOT)
            tube(h = rod_margin_bottom, od = threaded_d_min, id = threaded_d_min - wall * 2, anchor = TOP);
        }
      }

      if (use_small_d_for_lid)
      {
        // Tube to rest rod on
        tag("keep") down(rod_rest_h) position(TOP)
          tube(h = rod_rest_h, od1 = d, id1 = d - wall * 2, od2 = threaded_d_min, id2 = threaded_d_min - wall * 2,
               anchor = BOT);
      }

      if (len(holes) == 2)
      {
        hole_h = 8;
        hole_margin = 2;

        //
        // holes_needed =  (height - wall - rod_rest_h - holes_extra_margin)/(hole_h+hole_margin);
        holes_needed = floor((height - wall - 0 - holes_extra_margin + hole_margin) / (hole_h + hole_margin));

        position(BOT) up(wall) rot_copies(n = holes[0]) tag("remove")
          zcopies(spacing = hole_h + hole_margin, n = holes_needed, sp = [ 0, 0, 0 ])
            cuboid([ d + extra_for_better_removal, holes[1], hole_h ], anchor = BOT);
      }
    }

    children();
  }
}

module box_cylinder_lid(d, height = 10, wall = 1.2, use_small_d_for_lid = false, anchor = CENTER, spin = 0, orient = UP,
                        $slop = 0.3)
{
  // Seems like the slop is 4 times for internal threaded_rod.
  wall_including_slop = wall * 2 + get_slop() * 4;
  threaded_l = height - wall;
  threaded_pitch = 3;
  threaded_d_min = use_small_d_for_lid ? d - wall_including_slop - threaded_pitch : d;
  threaded_d_max = threaded_d_min + threaded_pitch;
  // This seems to work fine for pitch less than 5 at least. Not accurate when pitch is 10.
  threaded_d_pitch = threaded_d_min + threaded_pitch / 2 - 0.5;

  lid_d = use_small_d_for_lid ? d : threaded_d_max + wall_including_slop;

  attachable(anchor = anchor, spin = spin, orient = orient, d = lid_d, l = height)
  {
    tag_scope() diff() zcyl(d = lid_d, height = height, anchor = BOT)
    {
      tag("remove") position(TOP) up(extra_for_better_removal)
        threaded_rod(d = [ threaded_d_min, threaded_d_pitch, threaded_d_max ],
                     l = threaded_l + extra_for_better_removal, pitch = threaded_pitch, anchor = TOP, internal = true);
    }

    children();
  }
}

module box_rabbet(width, length, height, wall = 1.2, chamfer = 1.5, rounding = 0, friction_locks = true,
                  anchor = CENTER, spin = 0, orient = UP)
{
  empty_x = width - wall * 2;
  empty_y = length - wall * 2;
  empty_z = height - wall;

  rabbet_x = width - wall * 2 - get_slop() * 2;
  rabbet_y = length - wall * 2 - get_slop() * 2;

  friction_lock_pin_length = 2;
  friction_lock_hole_length = 2.4;
  friction_lock_hole_d = 0.6;

  size = [ width, length, height ];

  attachable(anchor = anchor, spin = spin, orient = orient, size = size)
  {
    tag_scope() diff() cuboid([ width, length, height ], chamfer = chamfer, rounding = rounding, except = [TOP])
    {
      tag("remove") up(extra_for_better_removal) position(TOP)
        cuboid([ empty_x, empty_y, empty_z + extra_for_better_removal ], chamfer = chamfer, rounding = rounding,
               except = [TOP], anchor = TOP);

      if (friction_locks)
      {
        tag("remove") down(1) position(TOP)
        {
          xflip_copy(offset = rabbet_x / 2) ycyl(d = friction_lock_hole_d, h = friction_lock_hole_length, anchor = TOP);
          yflip_copy(offset = rabbet_y / 2) xcyl(d = friction_lock_hole_d, h = friction_lock_hole_length, anchor = TOP);
        }
      }
    }

    children();
  }
}

module box_rabbet_lid(width, length, height = 10, wall = 1.2, rabbet_wall = 0.8, chamfer = 1.5, rounding = 0,
                      rabbet_z = 5, anchor = CENTER, spin = 0, orient = UP)
{
  rabbet_x = width - wall * 2 - get_slop() * 2;
  rabbet_y = length - wall * 2 - get_slop() * 2;

  empty_x = width - wall * 2 - rabbet_wall * 2;
  empty_y = length - wall * 2 - rabbet_wall * 2;
  empty_z = height - wall;

  echo("box_rabbet_lid empty_x and empty_y", empty_x, empty_y);

  total_height = height + rabbet_z;

  friction_lock_pin_length = 2;
  friction_lock_pin_d = 0.5;

  size = [ width, length, total_height ];

  attachable(anchor = anchor, spin = spin, orient = orient, size = size)
  {
    down(total_height / 2) tag_scope() diff()
      cuboid([ width, length, height ], chamfer = chamfer, rounding = rounding, except = [TOP], anchor = BOT)
    {
      // position(TOP)
      //   rect_tube(size = [ rabbet_x, rabbet_y ], wall = rabbet_wall, h = rabbet_z, chamfer = chamfer, anchor = BOT);

      tag("remove") up(rabbet_z + extra_for_better_removal / 2) position(TOP)
        cuboid([ empty_x, empty_y, empty_z + rabbet_z + extra_for_better_removal ], chamfer = chamfer,
               rounding = rounding, except = [TOP], anchor = TOP);

      position(TOP) cuboid([ rabbet_x, rabbet_y, rabbet_z ], chamfer = chamfer, rounding = rounding,
                           except = [ TOP, BOT ], anchor = BOT)
      {
        tag("keep") down(rabbet_z - friction_lock_pin_d - 1) position(TOP)
        {
          xflip_copy(offset = rabbet_x / 2) ycyl(d = friction_lock_pin_d, h = friction_lock_pin_length, anchor = TOP);
          yflip_copy(offset = rabbet_y / 2) xcyl(d = friction_lock_pin_d, h = friction_lock_pin_length, anchor = TOP);
        }
      }
    }

    children();
  }
}

module box_sliding(width, length, height, wall = standard_wall, inner_walls = [], inner_wall = BOX_STANDARD_INNER_WALL,
                   chamfer = 0, rounding = 2, anchor = CENTER, spin = 0, orient = UP)
{
  empty_x = width - wall * 2;
  empty_y = length - wall * 2;
  lid_lip = standard_lid_lip;
  lid_x = empty_x + lid_lip * 2;
  lid_y = empty_y + lid_lip * 2;

  inner_wall_z = height - wall * 2 - lid_lip;

  lid_margin_z = 0.5;

  size = [ width, length, height ];

  attachable(anchor = anchor, spin = spin, orient = orient, size = size)
  {
    tag_scope() down(height / 2) diff()
      cuboid([ width, length, height ], chamfer = chamfer, rounding = rounding, anchor = BOT)
    {

      tag("remove") up(extra_for_better_removal)
      {
        position(TOP) cuboid([ empty_x, empty_y, height - wall + extra_for_better_removal ], anchor = TOP);
      }

      tag("remove") up(extra_for_better_removal / 2) fwd(extra_for_better_removal / 2) position(TOP + FWD)
        cuboid([ empty_x, wall + extra_for_better_removal, wall + lid_margin_z + extra_for_better_removal ],
               anchor = TOP + FWD);

      tag("remove") down(lid_margin_z) fwd(wall / 2) position(TOP)
        cuboid([ lid_x, lid_y + wall, wall ], chamfer = wall / 2, edges = [TOP], anchor = TOP);

      tag("keep") up(wall) back(wall) position(BOT + FWD)
      {
        for (i = inner_walls)
        {
          back(i) cuboid([ empty_x, inner_wall, inner_wall_z ], anchor = BOT + FWD);
        }
      }
    }

    children();
  }
}

module box_sliding_lid(width, length, wall = standard_wall, extra_friction_stops = [], use_friction_lock = false,
                       use_simple_lock = false, large_simple_lock = false, anchor = CENTER, spin = 0, orient = UP,
                       $slop = 0.08)
{
  empty_x = width - wall * 2;
  empty_y = length - wall * 2;
  lid_lip = standard_lid_lip;
  lid_shorter_y = 0.4;
  lid_x = empty_x + lid_lip * 2 - get_slop();
  lid_y = empty_y + lid_lip + wall - lid_shorter_y;
  lid_z = wall - get_slop();

  echo("lid", lid_x, lid_y, lid_z);

  has_friction_stops = use_friction_lock || len(extra_friction_stops) > 0 ? true : false;
  lid_friction_stop_x = 8;
  lid_friction_stop_y = 1.4;
  lid_friction_stop_z = 0.6;
  lid_friction_offset_y = 0.1;
  extra_z_because_of_friction_stops = has_friction_stops ? lid_friction_stop_z : 0;
  size = [ lid_x, lid_y, lid_z + extra_z_because_of_friction_stops ];
  attachable(anchor = anchor, spin = spin, orient = orient, size = size)
  {
    tag_scope() up(size[2] / 2) down(extra_z_because_of_friction_stops) xrot(180) diff()
      cuboid([ lid_x, lid_y, lid_z ], chamfer = wall / 2, edges = [TOP], anchor = BOT)
    {
      if (use_friction_lock)
      {
        position(BOT + FWD) back(wall - lid_shorter_y + lid_friction_offset_y)
          cuboid([ lid_friction_stop_x, lid_friction_stop_y, lid_friction_stop_z ], rounding = lid_friction_stop_z,
                 edges = [BOT + BACK + FWD], anchor = TOP + FWD);
      }

      for (extra_friction_stops = extra_friction_stops)
      {
        position(BOT + FWD) back(extra_friction_stops)
          cuboid([ lid_friction_stop_x, lid_friction_stop_y, lid_friction_stop_z ], rounding = lid_friction_stop_z,
                 edges = [BOT + BACK + FWD], anchor = TOP + FWD);
      }

      if (use_simple_lock)
      {
        position(BOT + FWD) back(wall - lid_shorter_y)
        {
          simple_lock_width = large_simple_lock ? 9 : 6;
          tag("remove") box_simple_lock_hole(width = simple_lock_width, wall = wall, anchor = BOT + FWD);

          tag("keep") box_simple_lock(width = simple_lock_width, wall = wall, anchor = BOT + FWD);
        }
      }
    }
    children();
  }
}

module box_simple_lock_fastener(large_simple_lock = false, $slop = 0.1)
{
  simple_lock_width = large_simple_lock ? 9 : 6;
  spring_z = simple_lock_width - get_slop();
  spring_h = 9;
  spring_w = 8.3;
  spring_wall = 0.9;
  stopper_thickness = 0.8 - get_slop();
  stopper_length = 12 - get_slop();
  stopper_offset = 3;
  left(stopper_offset) cuboid([ stopper_thickness, stopper_length, spring_z ], anchor = BOT);

  ycopies(n = 2, spacing = 8.2) right(stopper_offset) cuboid([ stopper_thickness, 3.2, spring_z ], anchor = BOT);

  difference()
  {
    linear_extrude(height = spring_z) difference()
    {
      ellipse(d = [ spring_h, spring_w ]);
      ellipse(d = [ spring_h - spring_wall * 2, spring_w - spring_wall * 2 ]);
    }
    left(stopper_offset + stopper_thickness / 2) cuboid([ 10, stopper_length, spring_z ], anchor = BOT + RIGHT);
    right(stopper_offset + stopper_thickness / 2) cuboid([ 10, stopper_length, spring_z ], anchor = BOT + LEFT);
  }
}

module box_simple_lock(width = 6, wall = standard_wall, anchor = CENTER, spin = 0, orient = UP)
{
  spring_z = width;
  stopper_length = 12;
  stopper_thickness = 0.8;
  grove = stopper_thickness + 0.3;
  grove_inside = stopper_thickness;
  extra_space_for_screw_driver = 0.8;

  total_x = stopper_length + extra_space_for_screw_driver * 2 + extra_for_better_removal;
  total_y = spring_z + extra_for_better_removal;
  total_z = wall;

  echo("wall", standard_wall);

  attachable(anchor = anchor, spin = spin, orient = orient, size = [ total_x, total_y, total_z ])
  {

    tag_diff("keep", keep = "keep_always") cuboid([ total_x, total_y, total_z ])
    {
      // Hole through wall
      tag("remove") cuboid([ stopper_length - 4, spring_z, wall ]);

      // Room on lock head side
      position(TOP) tag("remove") cuboid([ stopper_length, spring_z, grove ], anchor = TOP);

      // Extra space for screw driver
      position(TOP) up(extra_for_better_removal) tag("remove")
        cuboid([ stopper_length + extra_space_for_screw_driver * 2, spring_z, grove + extra_for_better_removal ],
               rounding = 1, edges = [BOT], except = [ FWD, BACK ], anchor = TOP);

      // Space for lock down side
      position(BOT) down(extra_for_better_removal) tag("remove")
        cuboid([ stopper_length, spring_z, grove_inside + extra_for_better_removal ], anchor = BOT);
    }

    children();
  }
}

module box_simple_lock_hole(width = 6, wall = standard_wall, anchor = CENTER, spin = 0, orient = UP)
{
  // Warning: Numbers repeated
  spring_z = width;
  stopper_length = 12;
  extra_space_for_screw_driver = 0.8;

  total_x = stopper_length + extra_space_for_screw_driver * 2 + extra_for_better_removal;
  total_y = spring_z + extra_for_better_removal;
  total_z = wall;

  // This only works if anchor is BOT where this is attatched
  down(extra_for_better_removal / 2)
    attachable(anchor = anchor, spin = spin, orient = orient, size = [ total_x, total_y, total_z ])
  {
    cuboid([ total_x, total_y, total_z ]);
    children();
  }
}

module box_shape(width, length, height, shape, wall = standard_wall, chamfer = 0, rounding = 2, anchor = CENTER,
                 spin = 0, orient = UP)
{
}

module experiment_bit_lid_half_chamfered(anchor = CENTER, spin = 0, orient = UP)
{
  // This is needed in the box to make room for this lid
  // tag("remove") down(lid_margin_z) position(TOP) zcyl(d = d - wall, h = wall, chamfer2 = wall / 2, anchor = TOP);
  // tag("remove") position(TOP + BACK)
  //   cuboid([ d, d / 2, lid_margin_z + wall + extra_for_better_removal ], anchor = TOP + BACK);

  lid_margin_z = 0.5;
  lid_d = d - wall;
  lid_z = wall - get_slop();
  total_z = lid_z + lid_margin_z;

  attachable(anchor = anchor, spin = spin, orient = orient, d = lid_d, h = total_z)
  {
    tag_scope() diff() zcyl(d = lid_d, h = lid_z, chamfer2 = wall / 2, anchor = CENTER)
    {
      push_back = wall - 0.6;
      position(CENTER + FWD) back(push_back)
      {
        simple_lock_width = 9;
        tag("remove") box_simple_lock_hole(width = simple_lock_width, wall = lid_z + extra_for_better_removal,
                                           anchor = CENTER + FWD);

        tag("keep") box_simple_lock(width = simple_lock_width, wall = lid_z, anchor = CENTER + FWD);
      }

      position(BOT) difference()
      {
        tube(od = d, wall = lid_z, h = lid_margin_z + wall, anchor = BOT);

        cuboid([ d, d / 2, lid_margin_z + wall + extra_for_better_removal ], anchor = BOT + FWD);
      }
    }
    children();
  }
}