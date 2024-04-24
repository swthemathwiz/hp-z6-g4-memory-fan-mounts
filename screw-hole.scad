//
// Copyright (c) Stewart H. Whitman, 2022-2024.
//
// File:    screw-hole.scad
// Project: General
// License: CC BY-NC-SA 4.0 (Attribution-NonCommercial-ShareAlike)
// Desc:    Countersunk screw hole deletion
//

include <smidge.scad>;

// screw-hole:
//
// Hole drilled at <position> with <height> and <diameter> with optional countersink (on top or bottom)
//
module screw_hole( position, height, diameter, countersink=false, countersink_multiplier=2.25, countersink_top=true ) {
  assert( is_undef(position) || (is_list(position) && (len(position) == 2 || len(position) == 3)) );
  assert( is_num(height) );
  assert( is_num(diameter) && diameter >= 0 );

  if( diameter > 0 ) {
    p = is_undef(position) ? [0,0,0] : (len(position) == 2 ? concat( position, 0 ) : position);
    r = countersink_top ? [ 0, 180, 0 ]           : [ 0, 0, 0 ];
    t = countersink_top ? [ 0, 0, height+SMIDGE ] : [ 0, 0, -SMIDGE ];

    // orient and place
    translate( p + t ) rotate( r ) {
      // hole itself
      cylinder( h=height+2*SMIDGE, d=diameter );

      // countersink (45 degrees)
      if( countersink && countersink_multiplier > 1 ) {
	countersink_diameter = countersink_multiplier*diameter;

	// intersect with hole height to prevent overrun
	intersection() {
	  cylinder( h=countersink_diameter/2+2*SMIDGE, d1=countersink_diameter, d2=0 );
	  cylinder( h=height+2*SMIDGE, d=countersink_diameter );
	}
      }
    }
  }
} // end screw_hole

// Tests
if( false ) {
  $fn = 16;
  difference() {
    cube( [100,20,5] );
      for( i = [1:9] ) screw_hole( [i*10,10], height=5, diameter=i*.8 );
  }
  translate( [0,+30,0] )
  difference() {
    cube( [100,20,5] );
      for( i = [1:9] ) screw_hole( [i*10,10], height=5, diameter=i*.8, countersink=true, countersink_top=true );
  }
  translate( [0,+60,0] )
  difference() {
    cube( [100,20,5] );
      for( i = [1:9] ) screw_hole( [i*10,10], height=5, diameter=i*.8, countersink=true, countersink_top=false );
  }
  translate( [0,+90,0] )
  difference() {
    cube( [100,20,5] );
      screw_hole( height=5, diameter=5, countersink=true, countersink_top=true, countersink_multiplier=1.5 );
  }
}
