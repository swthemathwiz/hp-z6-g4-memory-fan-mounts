//
// Copyright (c) Stewart H. Whitman, 2020-2024.
//
// File:    rounded.scad
// Project: General
// License: CC BY-NC-SA 4.0 (Attribution-NonCommercial-ShareAlike)
// Desc:    Rounded square/cube/cylinder utilities
//

// rounded_side_square:
//
// Generate a square of <size> with a round-over <radius> in
// the X and Y directions. Centered optionally like a square.
//
module rounded_side_square( size, radius, center=false ) {
  assert( is_num(size) || is_list(size) );
  assert( is_num(radius) && radius >= 0 );

  c = is_list(size) ? size : [size,size];

  assert( len(c) == 2 );
  assert( is_num(c.x) );
  assert( is_num(c.y) );
  assert( c.x > 2*radius );
  assert( c.y > 2*radius );

  offset( r=radius )
    offset( delta=-radius )
      square( c, center=center );
} // end rounded_side_square

// rounded_side_cube:
//
// Generate a cube of <size> with a round-over <radius> in
// the X and Y directions. Centered optionally like a cube.
//
module rounded_side_cube( size, radius, center=false ) {
  assert( is_num(size) || is_list(size) );

  c = is_list(size) ? size : [size,size,size];

  assert( len(c) == 3 );
  assert( is_num(c.z) );

  linear_extrude( height=c.z, center=center )
    rounded_side_square( [c.x,c.y], radius, center );
} // end rounded_side_cube

// rounded_side_cube_upper:
//
// Generate a cube of <size> with a round-over <radius> in
// the X and Y directions. The object is centered on X and Y but
// with Z positive.
//
module rounded_side_cube_upper( size, radius ) {
  assert( is_num(size) || is_list(size) );

  c = is_list(size) ? size : [size,size,size];

  assert( len(c) == 3 );
  assert( is_num(c.z) );

  linear_extrude( height=c.z )
    rounded_side_square( [c.x,c.y], radius, true );
} // end rounded_side_cube_upper

// rounded_top_cylinder:
//
// Generate a cylinder with a rounded top, with <d,r,h> parameters
// like cylinder, but <radius> defines the round-over radius.
//
module rounded_top_cylinder( h, d, r, radius, center=false ) {
  assert( is_num(h) && h > 0 );
  assert( (is_undef(r) || is_undef(d)) && (is_num(r) || is_num(d)) ); // Not both
  assert( is_num(radius) );
  assert( h > radius );

  cylinder_radius = is_undef(d) ? r : d/2;
  assert( cylinder_radius > radius );

  translate( [0,0,(center?-h/2:0)] )
    rotate_extrude()
      intersection() {
        offset( r=+radius ) offset( delta=-radius ) square( [ 2*cylinder_radius, 2*h ], center=true );
        square( [cylinder_radius,h] );
      }
} // end rounded_top_cylinder

// rounded_top_and_bottom_cylinder:
//
// Generate a cylinder with a rounded top and bottom, with <d,r,h> parameters
// like cylinder, but <radius> defines the round-over radius.
//
module rounded_top_and_bottom_cylinder( h, d, r, radius, center=false ) {
  assert( is_num(h) && h > 0 );
  assert( (is_undef(r) || is_undef(d)) && (is_num(r) || is_num(d)) ); // Not both
  assert( is_num(radius) );
  assert( h > radius );

  cylinder_radius = is_undef(d) ? r : d/2;
  assert( cylinder_radius > radius );

  translate( [0,0,(center?-h/2:0)] )
    rotate_extrude()
      intersection() {
        translate( [-cylinder_radius, 0 ] ) offset( r=+radius ) offset( delta=-radius ) square( [ 2*cylinder_radius, h ], center=false );
	square( [cylinder_radius,h] );
      }
} // end rounded_top_and_bottom_cylinder

// rounded_top_cube:
//
// Generate a cube of <size> with a round-over <radius> in
// the X, Y, and top Z directions. Centered optionally like a cube.
//
module rounded_top_cube( size, radius, center=false ) {
  assert( is_num(size) || is_list(size) );
  assert( is_num(radius) && radius >= 0 );

  size_v = is_list(size) ? size : [size,size,size];

  rounded_top_volume( size_v, radius, center ? [0,0,0] : size_v/2 ) cube(size_v,center=center);
} // end rounded_top_cube

// rounded_top_cube_upper:
//
// Generate a cube of <size> with a round-over <radius> in
// the X, Y, and top Z directions. The object is centered on X and Y but
// with Z positive.
//
module rounded_top_cube_upper( size, radius ) {
  assert( is_num(size) || is_list(size) );

  size_v = is_list(size) ? size : [size,size,size];

  translate( [ 0, 0, size_v.z/2 ] ) rounded_top_cube( size_v, radius, center=true );
} // end rounded_top_cube_upper

// rounded_all_cube:
//
// Generate a cube of <size> with a round-over <radius> in
// all X, Y, and Z directions. Centered optionally like a cube.
//
module rounded_all_cube( size, radius, center=false ) {
  assert( is_num(size) || is_list(size) );
  assert( is_num(radius) && radius >= 0 );

  size_v = is_list(size) ? size : [size,size,size];

  rounded_all_volume( size_v, radius, center ? [0,0,0] : size_v/2 ) cube(size_v,center=center);
} // end rounded_all_cube

// rounded_all_cube_upper:
//
// Generate a cube of <size> with a round-over <radius> in
// all X, Y, and Z directions. The object is centered on X and Y but
// with Z positive.
//
module rounded_all_cube_upper( size, radius ) {
  assert( is_num(size) || is_list(size) );

  size_v = is_list(size) ? size : [size,size,size];

  translate( [ 0, 0, size_v.z/2 ] ) rounded_all_cube( size_v, radius, center=true );
} // end rounded_all_cube_upper

// rounded_top_volume:
//
// Operates on its children creating a round-over effect based
// on <radius>. Operations are:
//    1. Translate volume from <c> to origin
//    2. Scale X/Y volume down based-on the radius to be added in step 3
//    3. Minkowski with sphere adding 2*radius in all dimensions
//    4. Remove rounded over bottom radius:
//     a. Translate down a radius
//     b. Intersect with full volume
//    5. Restore volume to <c>
//
module rounded_top_volume( volume, radius, c=[0,0,0] ) {
  assert( is_num(radius) && radius >= 0 );
  assert( is_list(volume) && len(volume) == 3 );
  assert( is_num(volume.x) && volume.x > 2*radius );
  assert( is_num(volume.y) && volume.y > 2*radius );
  assert( is_list(c) && len(c) == 3 );

  if( radius > 0 ) {
    delta        = volume - 2*[radius, radius, 0];
    scale_factor = [delta.x/volume.x, delta.y/volume.y, 1 ];

    translate(c) intersection() {
      cube( volume, center=true );
      translate([0, 0, -radius ] ) minkowski() {
	scale( scale_factor ) translate(-c) children();
	sphere( r=radius );
      }
    }
  }
  else
    children();
} // end rounded_top_volume

// rounded_all_volume:
//
// Operates on its children creating a round-over effect based
// on <radius>. Operations are:
//    1. Translate volume from <c> to origin
//    2. Scale X/Y/Z volume down based-on the radius to be added in step 3
//    3. Minkowski with sphere adding 2*radius in all dimensions
//    4. Intersect with full volume
//    5. Restore volume to <c>
//
module rounded_all_volume( volume, radius, c=[0,0,0] ) {
  assert( is_num(radius) && radius >= 0 );
  assert( is_list(volume) && len(volume) == 3 );
  assert( is_num(volume.x) && volume.x > 2*radius );
  assert( is_num(volume.y) && volume.y > 2*radius );
  assert( is_num(volume.z) && volume.z > 2*radius );
  assert( is_list(c) && len(c) == 3 );

  if( radius > 0 ) {
    delta        = volume - 2*[radius, radius, radius];
    scale_factor = [delta.x/volume.x, delta.y/volume.y, delta.z/volume.z ];

    translate(c) intersection() {
      cube( volume, center=true );
      minkowski() {
	scale( scale_factor ) translate(-c) children();
	sphere( r=radius );
      }
    }
  }
  else
    children();
} // end rounded_all_volume
