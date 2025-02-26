// clang-format off
include<BOSL2\std.scad>;


function get_bat_shape_length(width) = let(scale_factor = width / 600) 433.96 * scale_factor;

function bat_shape(width) = let(
  scale_factor = width / 600,

  main_ellipse = ellipse(r = [ 300 * scale_factor, 220 * scale_factor ], $fn = 200),

  ear_union = union(xflip_copy(offset = -49 * scale_factor,
                               p = move([ 0, 228 * scale_factor, 0 ],
                                        p = zrot(34, p = rect([ 50 * scale_factor, 100 * scale_factor ])))),
                    move([ 0, 222.6 * scale_factor, 0 ], p = rect([ 83.5 * scale_factor, 100 * scale_factor ]))),

  head_half_circle_part = difference(circle(r = 90 * scale_factor, $fn = 200),
                                     move([ 170 * scale_factor, 0, 0 ], p = rect(300 * scale_factor))),

  head_half_circle_union = move([ 0, 210 * scale_factor, 0 ],
                                p = union(xflip_copy(offset = -90 * scale_factor, p = head_half_circle_part))),

  bottom_rect = rect([ 70 * scale_factor, 300 * scale_factor ], rounding = (70 * scale_factor) / 2, $fn = 100),

  bottom_rects = zrot(30, p = union(bottom_rect, move([ 40 * scale_factor, 20 * scale_factor, 0 ], p = bottom_rect))),

  bottom_union = move([ 0, -230 * scale_factor, 0 ],
                      p = union(xflip_copy(offset = -81 * scale_factor, p = bottom_rects))),

  all_union = union(ear_union, head_half_circle_union, bottom_union)) difference(main_ellipse, all_union);

// Size is when the heart is at a 45 degree angle.
function heart_shape_width(size) = size * (4 + 2 * sqrt(2)) / 6;
function heart_shape_length(size) = size * (4 + 6 * sqrt(2)) / 12;

function heart_shape(size) = let(         
  d = 2*size/3,
  w_tot = heart_shape_width(size),
  l_tot = heart_shape_length(size),  
  circle1 = move([-d/2, 0, 0,], p=circle(d = d, $fn = 200)),
  circle2 = move([0, d/2, 0,], p=circle(d = d, $fn = 200)),
  rect1 = rect([d, d])
  ) 
 move([0,-l_tot/2,0], p = zrot(-45, p= move([w_tot/2+-w_tot/2,-l_tot/2+l_tot/2,0], p = move([-d/2, d/2, 0], p = union(circle1, circle2, rect1)))));

// clang-format on

stroke(heart_shape(200), width = 1);