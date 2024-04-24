//
// Copyright (c) Stewart H. Whitman, 2024.
//
// File:    mitered.scad
// Project: General
// License: CC BY-NC-SA 4.0 (Attribution-NonCommercial-ShareAlike)
// Desc:    Mitered cube utilities
//

include <rounded.scad>;

// mitered_adjusted_square:
//
// Get the square <size> adjusted for angular expansion.
//
function mitered_adjusted_square( size, x_angle, y_angle ) =
   [ size.x, size.y ] + 2*size.z*[ 1/tan(x_angle), 1/tan(y_angle) ];

// mitered_cube:
//
// Scale a cube of <size> with angles of <x_angle> and <y_angle>. If not <inside>
// then the cube base is expanded and the top will be <size>, otherwise the
// base is retained and the top will be shrunken.
//
module mitered_cube( size, x_angle=90, y_angle=90, inside=true ) {
  assert( is_list( size ) );
  assert( len( size ) == 3 );
  assert( is_num( x_angle ) );
  assert( is_num( y_angle ) );

  if( size.z > 0 ) {
    assert( size.x > 0 );
    assert( size.y > 0 );

    // Calculate squares
    smaller_size = [ size.x, size.y ];
    larger_size  = mitered_adjusted_square( size, x_angle, y_angle );

    // Sanity check sizes
    assert( larger_size.x > 0 );
    assert( larger_size.y > 0 );

    // Scale always larger to smaller
    scale_factor = [ smaller_size.x / larger_size.x, smaller_size.y / larger_size.y ];

    // Extrude a scaled square
    linear_extrude( height=size.z, scale=scale_factor )
      square( inside ? smaller_size : larger_size, center=true );
  }
} // end mitered_cube

// mitered_rounded_cube:
//
// Scale a rounded cube of <size> with angles of <x_angle> and <y_angle>. If not <inside>
// then the cube base is expanded and the top will be <size>, otherwise the
// base is retained and the top will be shrunken.
//
module mitered_rounded_cube( size, radius=0, x_angle=90, y_angle=90, inside=true ) {
  assert( is_list( size ) );
  assert( len( size ) == 3 );
  assert( is_num( x_angle ) );
  assert( is_num( y_angle ) );
  assert( is_num( radius ) );

  if( size.z > 0 ) {
    assert( size.x > 0 );
    assert( size.y > 0 );

    // Calculate squares
    smaller_size = [ size.x, size.y ];
    larger_size  = mitered_adjusted_square( size, x_angle, y_angle );

    // Sanity check sizes
    assert( larger_size.x > 0 );
    assert( larger_size.y > 0 );

    // Scale always larger to smaller
    scale_factor = [ smaller_size.x / larger_size.x, smaller_size.y / larger_size.y ];

    // Extrude a scaled square
    linear_extrude( height=size.z, scale=scale_factor )
      rounded_side_square( inside ? smaller_size : larger_size, radius, center=true );
  }
} // end mitered_rounded_cube

//mitered_cube( [10,4,3], x_angle=30 );
//translate( [0,6,0] ) mitered_cube( [10,4,3], x_angle=30, inside=false );
//translate( [0,12,0] ) mitered_cube( [10,4,3], x_angle=60, y_angle=20, inside=true );
//mitered_cube( [10,4,3], x_angle=30 );
//translate( [0,6,0] ) mitered_cube( [10,4,3], x_angle=30, inside=false );
//translate( [0,12,0] ) mitered_cube( [10,4,3], x_angle=60, y_angle=20, inside=true );
