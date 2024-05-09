//
// Copyright (c) Stewart H. Whitman, 2024.
//
// File:    slanted.scad
// Project: General
// License: CC BY-NC-SA 4.0 (Attribution-NonCommercial-ShareAlike)
// Desc:    Slanted cube utilities
//

include <smidge.scad>;
include <rounded.scad>;

//
// Slanted cube means to start with a rectangle in the X/Y direction
// and scale is as appropriate quadrant by a provided angle in the
// Z direction.
//
// General Parameters:
//
// size    - distance        - either number or vector of X/Y/Z
// x_angle - angle (degrees) - either number or vector or [ right (x positive), left (x negative) ]
// y_angle - angle (degrees) - either number or vector or [ top (y positive), bottom (y negative) ]
//
// If a number is provided it is expanded to a replicated vector.
//

// __slanted_v3, __slanted_v2:
//
// Convert number to vector.
//
function __slanted_v3( c ) = is_num(c) ? [ c, c, c ] : c;
function __slanted_v2( c ) = is_num(c) ? [ c, c ] : c;

function __slanted_v2_add( l, r ) = [ l.x + r.x, l.y + r.y ];
function __slanted_v2_sub( l, r ) = [ l.x - r.x, l.y - r.y ];

// slanted_scaling:
//
// Return a X or Y scaling vector for <angle>.
//
function slanted_scaling_x( size, angle ) = (angle == 0) ? [ 1, 1 ] : [ 1 + tan( angle ) * 2 * size.z / size.x, 1 ];
function slanted_scaling_y( size, angle ) = (angle == 0) ? [ 1, 1 ] : [ 1, 1 + tan( angle ) * 2 * size.z / size.y ];
function slanted_scaling_xy( size, x_angle, y_angle ) = [ slanted_scaling_x( size, x_angle ).x, slanted_scaling_y( size, y_angle ).y ];

// slanted_scaled_box:
//
// Returns scaled box for one set of angles.
//
function __slanted_scaled_box_v3( size, x_angle, y_angle ) = [
  size.x * slanted_scaling_x( size, x_angle ).x,
  size.y * slanted_scaling_y( size, y_angle ).y,
  size.z ];
function slanted_scaled_box( size, x_angle, y_angle ) = __slanted_scaled_box_v3( __slanted_v3( size ), x_angle, y_angle );

// slanted_bounding_box:
//
// Returns maximal bounding box of size and scaled
//
function __slanted_bounding_max_v3( size, x_angle, y_angle ) = [
  max( size.x, slanted_scaled_box( size, x_angle, 0 ).x ),
  max( size.y, slanted_scaled_box( size, 0, y_angle ).y ),
  size.z ];
function slanted_bounding_max( size, x_angle, y_angle ) = __slanted_bounding_max_v3( __slanted_v3( size ), x_angle, y_angle );

// slanted_bounding_box, slanted_bounding_box_center:
//
// Returns bounding box of a slanted cube or its center
//
function __slanted_bounding_quadrants_v( size, x_angle, y_angle ) = [
    slanted_bounding_max( size, x_angle[0], y_angle[0] ),
    slanted_bounding_max( size, x_angle[1], y_angle[1] ),
    size.z
  ];
function __slanted_bounding_box_q( q )    = concat( __slanted_v2_add( q[0], q[1] ) / 2, q[2] );
function __slanted_bounding_box_center_q( q ) = concat( __slanted_v2_sub( q[0], q[1] ) / 4, q[2]/2 );

function slanted_bounding_box( size, x_angle, y_angle ) =
  __slanted_bounding_box_q( __slanted_bounding_quadrants_v( __slanted_v3( size ), __slanted_v2( x_angle ), __slanted_v2( y_angle ) ) );

function slanted_bounding_box_center( size, x_angle, y_angle ) =
  __slanted_bounding_box_center_q( __slanted_bounding_quadrants_v( __slanted_v3( size ), __slanted_v2( x_angle ), __slanted_v2( y_angle ) ) );

// slanted_extrude:
//
// Get the footprint <size> and extrude it.
//
module slanted_extrude( size, height, x_angle=0, y_angle=0, invert=false ) {
  assert( is_num( size ) || is_list( size ) );
  assert( !is_list( size ) || len( size ) >= 2 );
  assert( is_undef( height ) || is_num( height ) );
  assert( is_num( x_angle ) || (is_list( x_angle ) && len( x_angle ) == 2 && is_num(x_angle[0]) && is_num(x_angle[1])) );
  assert( is_num( y_angle ) || (is_list( y_angle ) && len( y_angle ) == 2 && is_num(y_angle[0]) && is_num(y_angle[1])) );

  // Convert to vector
  size_vector    = __slanted_v3( size );
  x_angle_vector = __slanted_v2( x_angle );
  y_angle_vector = __slanted_v2( y_angle );

  // Use height if specified, otherwise size.z
  effective_size = is_undef(height) ? size_vector : [ size_vector.x, size_vector.y, height ];

  // Check size
  assert( len( effective_size ) == 3 );
  assert( is_num( effective_size.x ) );
  assert( is_num( effective_size.y ) );
  assert( effective_size.x > 0 );
  assert( effective_size.y > 0 );

  module inversion_of( invert ) {
    if( invert ) {
      z_half = effective_size.z/2;
      translate( [ 0, 0, +z_half ] )
        mirror( [ 0, 0, 1 ] )
	  translate( [ 0, 0, -z_half ] )
            children();
    }
    else
      children();
  } // end inversion_of

  // Work thru each X/Y quadrant of the volume
  if( effective_size.z > 0 ) {
    quadrant = [ [ +1, +1 ], [ -1, +1 ], [ -1, -1 ], [ +1, -1 ] ];

    inversion_of( invert ) {
      union() {
	for( q = quadrant ) {
	  scaling = slanted_scaling_xy( effective_size, x_angle_vector[q.x > 0 ? 0 : 1], y_angle_vector[q.y > 0 ? 0 : 1] );

	  linear_extrude( height=effective_size.z, scale=scaling  )
	    intersection() {
	      translate( [ q.x*(effective_size.x-SMIDGE), q.y*(effective_size.y-SMIDGE) ]/4 )
		square( [ effective_size.x+SMIDGE/2, effective_size.y+SMIDGE/2 ]/2, center=true );
	      children();
	    }
	}
      }
    }
  }
} // end slanted_extrude

// slanted_cube:
//
// Scale a square of <size> slanted with <y_angle> in y-direction and
// <x_angle> in the x-direction. Resulting volume is centered on X/Y
// zero with Z in upper quadrants.
//
module slanted_cube( size, x_angle=0, y_angle=0, invert=false ) {
  assert( is_num( size ) || (is_list( size ) && len( size ) == 3 && is_num( size.x ) && is_num( size.y ) && is_num( size.z )) );
  assert( is_num( x_angle ) || (is_list( x_angle ) && len( x_angle ) == 2 && is_num(x_angle[0]) && is_num(x_angle[1])) );
  assert( is_num( y_angle ) || (is_list( y_angle ) && len( y_angle ) == 2 && is_num(y_angle[0]) && is_num(y_angle[1])) );

  // Convert to vector
  size_vector = __slanted_v3( size );

  // Extrude a slanted square
  slanted_extrude( size_vector, x_angle=x_angle, y_angle=y_angle, invert=invert )
    square( [ size_vector.x, size_vector.y ], center=true );
} // end slanted_cube

// slanted_rounded_side_cube:
//
// Scale a square of <size> rounded by <radius> slanted with <y_angle> in
// y-direction and <x_angle> in the x-direction. Resulting volume is
// centered on X/Y zero with Z in upper quadrants.
//
module slanted_rounded_side_cube( size, radius=0, x_angle=0, y_angle=0, invert=false ) {
  assert( is_num( size ) || (is_list( size ) && len( size ) == 3 && is_num( size.x ) && is_num( size.y ) && is_num( size.z )) );
  assert( is_num( radius ) );
  assert( is_num( x_angle ) || (is_list( x_angle ) && len( x_angle ) == 2 && is_num(x_angle[0]) && is_num(x_angle[1])) );
  assert( is_num( y_angle ) || (is_list( y_angle ) && len( y_angle ) == 2 && is_num(y_angle[0]) && is_num(y_angle[1])) );

  // Convert to vector
  size_vector = __slanted_v3( size );

  // Extrude a slanted rounded square
  slanted_extrude( size_vector, x_angle=x_angle, y_angle=y_angle, invert=invert )
    rounded_side_square( [ size_vector.x, size_vector.y ], radius, center=true );
} // end slanted_rounded_side_cube

// slanted_rounded_top_cube:
//
// Scale a square of <size> slanted with <y_angle> in y-direction with
// and <x_angle> in the x-direction rounded on non-bottom sides by <radius>.
// Resulting volume is centered on X / Y zero with Z in upper
// quadrants.
//
module slanted_rounded_top_cube( size, radius=0, x_angle=0, y_angle=0, invert=false ) {
  assert( is_num( size ) || (is_list( size ) && len( size ) == 3 && is_num( size.x ) && is_num( size.y ) && is_num( size.z )) );
  assert( is_num( radius ) );
  assert( is_num( x_angle ) || (is_list( x_angle ) && len( x_angle ) == 2 && is_num(x_angle[0]) && is_num(x_angle[1])) );
  assert( is_num( y_angle ) || (is_list( y_angle ) && len( y_angle ) == 2 && is_num(y_angle[0]) && is_num(y_angle[1])) );

  // Get bounding box
  bounding_box        = slanted_bounding_box( size, x_angle, y_angle );
  bounding_box_center = slanted_bounding_box_center( size, x_angle, y_angle );

  //#translate( +[ bounding_box_center.x, bounding_box_center.y, 0 ] ) slanted_cube( bounding_box );

  rounded_top_volume( bounding_box, radius, c=bounding_box_center )
    slanted_cube( size, x_angle=x_angle, y_angle=y_angle, invert=invert );
} // end slanted_rounded_top_cube

// slanted_rounded_all_cube:
//
// Scale a square of <size> slanted with <y_angle> in y-direction with
// and <x_angle> in the x-direction rounded on all sides by <radius>.
// Resulting volume is centered on X / Y zero with Z in upper
// quadrants.
//
module slanted_rounded_all_cube( size, radius=0, x_angle=0, y_angle=0, invert=false ) {
  assert( is_num( size ) || (is_list( size ) && len( size ) == 3 && is_num( size.x ) && is_num( size.y ) && is_num( size.z )) );
  assert( is_num( radius ) );
  assert( is_num( x_angle ) || (is_list( x_angle ) && len( x_angle ) == 2 && is_num(x_angle[0]) && is_num(x_angle[1])) );
  assert( is_num( y_angle ) || (is_list( y_angle ) && len( y_angle ) == 2 && is_num(y_angle[0]) && is_num(y_angle[1])) );

  // Get bounding box
  bounding_box        = slanted_bounding_box( size, x_angle, y_angle );
  bounding_box_center = slanted_bounding_box_center( size, x_angle, y_angle );

  //#translate( +[ bounding_box_center.x, bounding_box_center.y, 0 ] ) slanted_cube( bounding_box );

  rounded_all_volume( bounding_box, radius, c=bounding_box_center )
    slanted_cube( size, x_angle=x_angle, y_angle=y_angle, invert=invert );
} // end slanted_rounded_all_cube

//$fn=32;
//x = 4;
//if( x == 0 ) {
//  slanted_cube( [10,10,5], y_angle=45 );
//  translate( [8,0,0] ) slanted_cube( 1, y_angle=45 );
//  translate( [10,0,0] ) slanted_rounded_side_cube( 1, y_angle=45 );
//  translate( [12,0,0] ) slanted_rounded_side_cube( 1, radius=0.2, y_angle=45 );
//}
//else if( x == 1 ) {
//  slanted_cube( [10,4,3], y_angle=[-20,+10], x_angle=[15, 0] );
//  translate( [0,6,0] ) slanted_cube( [10,4,3], y_angle=5 );
//  translate( [0,12,0] ) slanted_cube( [10,4,3], y_angle=15, x_angle=25 );
//}
//else if( x == 2 ) {
//  slanted_rounded_side_cube( [10,4,3], radius=0.5, y_angle=[-20,+10], x_angle=[15, 0] );
//  translate( [0,6,0] ) slanted_rounded_side_cube( [10,4,6], radius=0.5, y_angle=5 );
//  translate( [0,12,0] ) slanted_rounded_side_cube( [10,4,3], radius=0.5, y_angle=15, x_angle=25 );
//}
//else if( x == 3 ) {
//  slanted_rounded_top_cube( [10,4,3], radius=0.5, y_angle=[-20,+10], x_angle=[15, 0], invert=true );
//  translate( [0,6,0] ) slanted_rounded_top_cube( [10,4,6], radius=0.5, y_angle=5, x_angle=45 );
//  translate( [0,12,0] ) slanted_rounded_top_cube( [10,4,3], radius=0.5, y_angle=15, x_angle=25 );
//}
//else {
//  slanted_rounded_all_cube( [10,4,3], radius=0.5, y_angle=[-20,+10], x_angle=[15, 0], invert=true );
//  translate( [0,6,0] ) slanted_rounded_all_cube( [10,4,6], radius=0.5, y_angle=5, x_angle=46 );
//  translate( [0,12,0] ) slanted_rounded_all_cube( [10,4,3], radius=0.5, y_angle=15, x_angle=25 );
//}
