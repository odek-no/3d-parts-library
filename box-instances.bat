@REM openscad -D "width=50;length=50;height=10;part=\"box_rabbet_lid\"" -o stl/box_rabbet_50x50x10_lid.stl src/box-instances.scad
@REM openscad -D "width=50;length=50;height=2;part=\"box_rabbet_lid\"" -o stl/box_rabbet_50x50x2_lid.stl src/box-instances.scad
@REM openscad -D "width=50;length=50;height=20;part=\"box_rabbet\"" -o stl/box_rabbet_50x50x20.stl src/box-instances.scad
@REM openscad -D "width=50;length=50;height=20;part=\"box_sliding\"" -o stl/box_sliding_50x50x20.stl src/box-instances.scad
@REM openscad -D "width=50;length=50;part=\"box_sliding_lid\"" -o stl/box_sliding_50x50_lid.stl src/box-instances.scad


@REM openscad -D "width=100;length=100;height=10;part=\"box_rabbet_lid\"" -o stl/box_rabbet_100x100x10_lid.stl src/box-instances.scad
@REM openscad -D "width=100;length=100;height=90;part=\"box_rabbet\"" -o stl/box_rabbet_100x100x90.stl src/box-instances.scad





@REM openscad -D "width=150;length=150;height=150;part=\"box_sliding\"" -o stl/box_sliding_150x150x150.stl src/box-instances.scad
@REM openscad -D "width=150;length=150;height=150;part=\"box_sliding_lid\"" -o stl/box_sliding_150x150x150_lid.stl src/box-instances.scad

@REM openscad -D "width=100;length=100;height=100;part=\"box_sliding\"" -o stl/box_sliding_100x100x100.stl src/box-instances.scad
@REM openscad -D "width=100;length=100;height=100;part=\"box_sliding_lid\"" -o stl/box_sliding_100x100x100_lid.stl src/box-instances.scad



@REM openscad -D "width=220;length=220;height=60;part=\"box_rabbet\"" -o stl/box_rabbet_220x220x60.stl src/box-instances.scad 
@REM openscad -D "width=215;length=215;height=50;part=\"box_rabbet\"" -o stl/box_rabbet_215x215x50.stl src/box-instances.scad 
@REM openscad -D "width=210;length=210;height=40;part=\"box_rabbet\"" -o stl/box_rabbet_210x210x40.stl src/box-instances.scad 
@REM openscad -D "width=205;length=205;height=30;part=\"box_rabbet\"" -o stl/box_rabbet_205x205x30.stl src/box-instances.scad 
@REM openscad -D "width=200;length=200;height=20;part=\"box_rabbet\"" -o stl/box_rabbet_200x200x20.stl src/box-instances.scad 

@REM openscad -D "d=50;height=20;wall=1.2;part=\"box_cylinder\"" -o stl/tests/box_cylinder_d50xh20xw1_2.stl src/box-instances.scad
@REM openscad -D "d=50;wall=1.2;part=\"box_cylinder_lid\"" -o stl/tests/box_cylinder_lid_d50xw1_2.stl src/box-instances.scad

@REM openscad -D "d=50;height=20;wall=1.2;use_small_d_for_lid=true;part=\"box_cylinder\"" -o stl/tests/box_cylinder_d50xh20w1_2_small_lid.stl src/box-instances.scad
@REM openscad -D "d=50;wall=1.2;use_small_d_for_lid=true;part=\"box_cylinder_lid\"" -o stl/tests/box_cylinder_lid_d50w1_2_small_lid.stl src/box-instances.scad


@REM openscad -D "d=50;height=20;wall=1.2;holes=[16,3];part=\"box_cylinder\"" -o stl/tests/box_cylinder_d50xh20xw1_2.stl src/box-instances.scad
@REM openscad -D "d=50;wall=1.2;part=\"box_cylinder_lid\"" -o stl/tests/box_cylinder_lid_d50xw1_2.stl src/box-instances.scad

@REM openscad -D "d=60;height=90;wall=1.2;use_small_d_for_lid=true;holes=[16,4];part=\"box_cylinder\"" -o stl/tests/box_cylinder_d60xh90w1_2_small_lid.stl src/box-instances.scad
@REM openscad -D "d=60;wall=1.2;use_small_d_for_lid=true;part=\"box_cylinder_lid\"" -o stl/tests/box_cylinder_lid_d60w1_2_small_lid.stl src/box-instances.scad

@REM openscad -D "d=50;height=90;wall=1.2;use_small_d_for_lid=true;holes=[16,4];part=\"box_cylinder\"" -o stl/tests/box_cylinder_d50xh90w1_2_small_lid.stl src/box-instances.scad
@REM openscad -D "d=50;wall=1.2;use_small_d_for_lid=true;part=\"box_cylinder_lid\"" -o stl/tests/box_cylinder_lid_d50w1_2_small_lid.stl src/box-instances.scad


@REM openscad -D "width=175;length=175;height=2;lid_rabbet_z=8;part=\"box_rabbet_lid\"" -o "../../prosjekter/2025 Hnefatafl/box_lid.stl" src/box-instances.scad
openscad -D "width=175;length=175;height=30;friction_locks=true;part=\"box_rabbet\"" -o "../../prosjekter/2025 Hnefatafl/box.stl" src/box-instances.scad
