//
// Copyright (c) Stewart H. Whitman, 2024.
//
// File:    bridge.scad
// Project: General
// License: CC BY-NC-SA 4.0 (Attribution-NonCommercial-ShareAlike)
// Desc:    Bridge two areas, with optional fillet
//

include <smidge.scad>;

// _bridge_v2d: convert vector to 2d
function _bridge_v2d(v) = assert( is_list(v) && len(v) >= 2 ) [ v.x, v.y ];

// bridge_children:
//
// A bridge between two areas centered at positions
// <pos#>. Bridge with line between centers of <width>
// filleted with <radius>
//
module bridge_children( pos1, pos2, width, radius=0 ) {
  // fillet: add rounded fillet at joints (per manual)
  module fillet(r) { offset(r = -r) { offset(delta = r) { children(); } } }

  // line: line of <width> between <pos1> and <pos2>
  module line( pos1, pos2, width ) {
    r = width/2;
    hull() {
      translate( pos1 ) circle( r=r );
      translate( pos2 ) circle( r=r );
    }
  } // end line

  // connect: connect the unconnected children
  module connect( pos1, pos2, width, radius ) {
    difference() {
      fillet( radius ) {
        line( pos1, pos2, width );
	children();
      }
      children();
    }
  } // end connect

  connect( _bridge_v2d( pos1 ), _bridge_v2d( pos2 ), width, radius )
    children();
} // end bridge_children

// bridge_squares: bridge two 2D squares
module bridge_squares( size1, pos1, size2, pos2, width, radius=0 ) {
  bridge_children( pos1, pos2, width, radius ) {
    translate( _bridge_v2d(pos1) ) square( _bridge_v2d(size1), center = true );
    translate( _bridge_v2d(pos2) ) square( _bridge_v2d(size2), center = true );
  }
} // end bridge_squares

// bridge_cubes: bridge two 3D cubes
module bridge_cubes( size1, pos1, size2, pos2, width, height, radius=0 ) {
  assert( is_list(size1) && len(size1) >= 3 );
  assert( is_list(size2) && len(size2) >= 3 );

  h = is_undef(height) ? min( size1.z, size2.z ) : height;
  linear_extrude( height=h )
    bridge_squares( size1, pos1, size2, pos2, width, radius );
} // end bridge_cubes

//$fn=64;
//test_size1 = [80,80,5];
//test_size2 = [80,80,12];
//test_pos1  = [0,0];
//test_pos2  = [-100,30];
//bridge_cubes( test_size1, test_pos1, test_size2, test_pos2, width=5, radius=2 );
