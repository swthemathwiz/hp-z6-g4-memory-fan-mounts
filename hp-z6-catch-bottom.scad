//
// Copyright (c) Stewart H. Whitman, 2022-2024.
//
// File:    hp-z6-catch-bottom.scad
// Project: HP Z6 G4 Memory Fan Mounts
// License: CC BY-NC-SA 4.0 (Attribution-NonCommercial-ShareAlike)
// Desc:    HP Z6 G4 Bottom Front Fan Cage Catch Definitions
//

include <smidge.scad>;
include <rounded.scad>;
include <mitered.scad>;

// Catch:
//
// Catch refers to the top area of the "mound". Radius is nominal.
//
// bottom_catch_size: length, width
bottom_catch_size = [ 68, 5 ];
bottom_catch_radius = 1;

// Slot:
//
// Two slots, centered atop the long axis and positioned
// symmetrically about the vertical center. Depth is space
// below mount.
//
// bottom_slot_size: length, width, depth
bottom_slot_size = [ 12.8, 3, 5 ];
bottom_slot_separation = 28.5;
bottom_slot_centers = (bottom_slot_separation + bottom_slot_size.x)/2 * [ [ 1, 0 ], [ -1, 0 ] ];

// Fitting (tolerance) properties:
//
bottom_tang_multiplier = [ 0.925, 0.97, 0.9 ];
bottom_tang_slant_scale = [ 0.9, 0.8 ];

// bottom_catch_tang:
//
// The tangs are inserted it the slots of catch on the machine.
//
module bottom_catch_tang( style ) {
  // Overall size of the tang
  size = [ bottom_tang_multiplier.x * bottom_slot_size.x,
           bottom_tang_multiplier.y * bottom_slot_size.y,
           (style == "full") ? 0.97 * bottom_slot_size.z : bottom_tang_multiplier.z*bottom_slot_size.z ];

  if( style == "none" ) {
    ;
  }
  // debug: just cubes (for debugging)
  else if( style == "debug" ) {
    rounded_side_cube_upper( bottom_slot_size, radius=0 );
  }
  // full: straight just scaled by percentage (for fitting)
  else if( style == "full" ) {
    rounded_side_cube_upper( size, bottom_catch_radius/3);
  }
  // slant: slanted on 4-sides
  // complex: straight for a little, then slanted on 4-sides
  else if( style == "slant" || style == "complex" ) {
    complex_straight_height = (style == "complex") ? 2.0 : 0;
    assert( size.z > complex_straight_height );

    if( complex_straight_height > 0 )
      rounded_side_cube_upper( [size.x,size.y,complex_straight_height], bottom_catch_radius/3);

    translate( [ 0, 0, complex_straight_height] )
      linear_extrude( height = size.z-complex_straight_height, scale=bottom_tang_slant_scale )
	rounded_side_square( [size.x,size.y], bottom_catch_radius/3, center=true );
  }
  // tilt: tilted toward one side, with taper
  else if( style == "tilt" ) {
    //echo( "bottom tang [ width, depth ] = ", [ size.x, size.z ] );
    translate( [0,-size.y/2,0] )
      intersection() {
	linear_extrude( height = size.z )
	  translate( [0,+size.y/2] )
	    square( [size.x,size.y], center=true );
	linear_extrude( height = size.z, scale=[bottom_tang_slant_scale.x,0.5*bottom_tang_slant_scale.y] )
	  rounded_side_square( [size.x,2*size.y], bottom_catch_radius/3, center=true );
      }
  }
  else {
    assert( false, "bottom_catch_tang: style unknown!" );
  }
} // end bottom_catch_tang

// bottom_catch_base:
//
// The catch structure matches the machine's catch surface
//
module bottom_catch_base( style, height, width ) {
  size = [ bottom_catch_size.x, width, height ];

  if( style == "none" || height <= 0 || width <= 0 ) {
    ;
  }
  // full: straight just scaled by percentage
  else if( style == "full" ) {
    rounded_side_cube_upper( size, bottom_catch_radius );
  }
  // layout: test layout the distance to front wall
  else if( style == "layout" ) {
    difference() {
      intersection() {
	rounded_side_cube_upper( size, bottom_catch_radius );
	translate( [0,(width-bottom_slot_size.y)/2,0] )
	  rounded_side_cube_upper( size, bottom_catch_radius );
      }

      // Receiver for top catch layout
      receiver_width = 4;
      translate( [-receiver_width/2,-receiver_width+1/2,-SMIDGE] )
	cube( [receiver_width,receiver_width,size.z+2*SMIDGE] );
    }
  }
  // sloped: sides are sloped at 45 degrees
  else if( style == "sloped" ) {
    mitered_rounded_cube( size, bottom_catch_radius, x_angle=45, y_angle=45, inside=false );
  }
  // sloped-half: sides are sloped with rear clipped beyond tangs
  else if( style == "sloped-half" ) {
    front_angle = 40;
    side_angle  = 80;

    expanded_size = mitered_adjusted_square( size, x_angle=side_angle, y_angle=front_angle );
    delta         = expanded_size.y/2-(bottom_slot_size.y*bottom_tang_multiplier.y)/2;

    intersection() {
      mitered_rounded_cube( size, bottom_catch_radius, x_angle=side_angle, y_angle=front_angle, inside=false );

      translate( [0,delta,0] )
        linear_extrude( height=size.z )
          square( expanded_size, center=true );
    }
  }
  // trap-both:
  else if( style == "trap-both" ) {
    assert( size.y >= bottom_catch_size.y );

    expanded_size = [ size.x, size.y ];
    linear_extrude( height=size.z, scale = [ bottom_catch_size.x/expanded_size.x, bottom_catch_size.y/expanded_size.y ]  )
      rounded_side_square( expanded_size, bottom_catch_radius, center=true );
  }
  // trap-front:
  else if( style == "trap-front" ) {
    assert( size.y >= bottom_catch_size.y );

    delta         = (size.y-bottom_catch_size.y)/2;
    expanded_size = [size.x, size.y];

    intersection() {
      translate( [0,+delta/2,0] )
	rounded_side_cube_upper( size - [ 0, delta, 0 ], bottom_catch_radius );

      linear_extrude( height=size.z, scale = [ bottom_catch_size.x/expanded_size.x, bottom_catch_size.y/expanded_size.y ]  )
	rounded_side_square( expanded_size, bottom_catch_radius, center=true );
     }
  }
  // trap-front-half:
  else if( style == "trap-front-half" ) {
    assert( size.y >= bottom_catch_size.y );

    expanded_size = [size.x, size.y];
    delta         = (expanded_size.y-bottom_catch_size.y)/2;

    intersection() {
      translate( [0,+delta/2+bottom_catch_size.y/2-(bottom_slot_size.y*bottom_tang_multiplier.y)/2,0] )
        rounded_side_cube_upper( size - [ 0, delta, 0 ], bottom_catch_radius );

      linear_extrude( height=size.z, scale = [ bottom_catch_size.x/expanded_size.x, bottom_catch_size.y/expanded_size.y ]  )
        rounded_side_square( expanded_size, bottom_catch_radius, center=true );
    }
  }
  else {
    assert( false, "bottom_catch_base: style unknown!" );
  }
} // end bottom_catch_base

// bottom_catch_fitting:
//
// Generate a mate to the machine's catch.
//
module bottom_catch_fitting( height=0, width=bottom_catch_size.y, base_style="full", tang_style="slant" ) {
  assert( is_num(height) && height >= 0 );
  assert( is_num(width) );

  translate( [0,0,-height] ) {
    // Base
    bottom_catch_base( base_style, height, width );

    // Slot projections
    for( p = bottom_slot_centers )
      translate( concat( p, height-SMIDGE ) )
	bottom_catch_tang( tang_style );
  }
} // end bottom_catch_fitting

// bottom_catch_get_size, bottom_catch_get_above_size, bottom_catch_get_below_size:
//
// Returns [ length, width, height above/below case level ]
//
function bottom_catch_get_size()       = concat( bottom_catch_size, 0+bottom_slot_size.z );
function bottom_catch_get_above_size() = concat( bottom_catch_size, 0 );
function bottom_catch_get_below_size() = concat( bottom_catch_size, bottom_slot_size.z );
function bottom_catch_get_tang_width() = bottom_tang_multiplier.y * bottom_slot_size.y;

$fn = 32;
//bottom_catch_fitting(height=3,base_style="full",tang_style="full");
//bottom_catch_fitting(height=2.4,base_style="full",tang_style="complex");
//bottom_catch_fitting(height=3, width=30, base_style="trap-front", tang_style="complex");
//bottom_catch_fitting(height=3, base_style="full", tang_style="debug");
//bottom_catch_fitting(height=3, width=30, base_style="trap-front", tang_style="complex");
//bottom_catch_fitting(height=3, width=30, base_style="trap-front-half", tang_style="tilt");
bottom_catch_fitting(height=3, width=30, base_style="sloped-half", tang_style="tilt");
//bottom_catch_fitting(height=3, width=30, base_style="sloped", tang_style="tilt");
//bottom_catch_fitting(height=2.4,base_style="layout",tang_style="full");
//echo( (bottom_slot_separation + bottom_slot_size.x)/2, ( 30.2 + 11.7 )/2 );
