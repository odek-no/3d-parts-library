// clang-format off
include<BOSL2\std.scad>;
// clang-format on

$fn = $preview ? 32 : 200;

extra_for_better_remove = 0.001;

jst_male_dim = [ 2.2, 2.9 ];
jst_female_dim = [ 2.0, 2.9 ];

jst_spacing = 3.5;

jst_male_small_opening = 1.6;
jst_female_small_opening = 1.7;

housing_wall_top = 0.8;
housing_wall = 1;
housing_height_male = 13;
housing_height_female = 10;
housing_mating_height = 4;

housing_x = 4;

housing_mating_slope = 0.2;

friction_d = 0.6;
friction_h = 3;
friction_offset_female = 0.6;
friction_offset_male = housing_mating_height - friction_offset_female - friction_d;

module jst_female(n = 5)
{
  housing_y = n * jst_spacing + 3 / 2;

  wall_to_remove = (housing_x - jst_female_dim[1]) / 2;
  diff() cuboid(
    [ housing_x + housing_wall * 2, housing_y + housing_wall * 2, housing_height_female + housing_mating_height ],
    anchor = BOT)
  {
    tag("remove") position(TOP) up(extra_for_better_remove) cuboid(
      [
        housing_x + housing_mating_slope * 2, housing_y + housing_mating_slope * 2, housing_mating_height +
        extra_for_better_remove
      ],
      anchor = TOP);

    tag("remove") down(friction_offset_female)
    {
      position(LEFT + TOP) right(housing_wall)
        ycyl(h = friction_h + housing_mating_slope, d = friction_d + housing_mating_slope, anchor = TOP);
      position(RIGHT + TOP) left(housing_wall)
        ycyl(h = friction_h + housing_mating_slope, d = friction_d + housing_mating_slope, anchor = TOP);
    }

    position(BOT) cuboid([ housing_x, housing_y, housing_height_female ], anchor = BOT)
    {
      tag("remove") ycopies(spacing = jst_spacing, n = n)
      {
        position(BOT)
          cuboid([ jst_female_dim[1], jst_female_dim[0], housing_height_female - housing_wall_top ], anchor = BOT);
        // Extra room for start of wire
        position(BOT) cuboid([ jst_female_dim[1], jst_female_dim[0] + 0.8, 4 ], anchor = BOT);
        position(TOP) left((jst_female_dim[1] - jst_female_small_opening) / 2)
          cuboid([ jst_female_small_opening, jst_female_dim[0], housing_wall_top ], anchor = TOP);

        up(1) right(housing_wall) position(BOT + RIGHT)
          cuboid([ wall_to_remove + housing_wall, 2, 5.2 ], anchor = BOT + RIGHT);
        tag("keep") up(0.6) yrot(-15) left(0.95) position(BOT + RIGHT)
          cuboid([ wall_to_remove, 2 - 0.2, 5.0 ], anchor = BOT + RIGHT);

        tag("keep") left(housing_wall) up(1) zrot(180) position(RIGHT + DOWN)
          text3d(str(n - $idx), h = 0.2, size = 4, font = "Arial", orient = RIGHT, spin = 90, anchor = DOWN);
      }
    }
  }
}

module jst_male(n = 5)
{
  housing_y = n * jst_spacing + 3 / 2;
  wall_to_remove = (housing_x - jst_male_dim[1]) / 2;
  diff() cuboid([ housing_x, housing_y, housing_height_male ], anchor = BOT)
  {
    tag("remove") ycopies(spacing = jst_spacing, n = n)
    {
      position(BOT) cuboid([ jst_male_dim[1], jst_male_dim[0], housing_height_male - housing_wall_top ], anchor = BOT);
      // Extra room for start of wire
      position(BOT) cuboid([ jst_male_dim[1], jst_male_dim[0] + 0.8, 4 ], anchor = BOT);
      position(TOP) left((jst_male_dim[1] - jst_male_small_opening) / 2)
        cuboid([ jst_male_small_opening, jst_male_dim[0], housing_wall_top ], anchor = TOP);

      up(1) position(BOT + RIGHT) cuboid([ wall_to_remove, 2, 6.4 ], anchor = BOT + RIGHT);
      tag("keep") up(0.69) yrot(-15) left(1.67) position(BOT + RIGHT)
        cuboid([ wall_to_remove, 2 - 0.14, 6.2 ], anchor = BOT + RIGHT);

      tag("keep") up(1) zrot(180) position(RIGHT + DOWN)
        text3d(str($idx + 1), h = 0.2, size = 4, font = "Arial", orient = RIGHT, spin = 90, anchor = DOWN);
    }

    down(friction_offset_male)
    {
      position(LEFT + TOP) ycyl(h = friction_h, d = friction_d, anchor = TOP);
      position(RIGHT + TOP) ycyl(h = friction_h, d = friction_d, anchor = TOP);
    }
  }
}
