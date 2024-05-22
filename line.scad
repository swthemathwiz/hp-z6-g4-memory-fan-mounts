//
// Copyright (c) Stewart H. Whitman, 2024.
//
// File:    line.scad
// Project: General
// License: CC BY-NC-SA 4.0 (Attribution-NonCommercial-ShareAlike)
// Desc:    Line utilities
//

include <polar.scad>;

// line:
//
// Create a two or three dimensional line of <width> between <pos1> and <pos2>
//
// Ref: https://stackoverflow.com/questions/49533350/is-that-possible-to-draw-a-line-using-openscad-by-joining-different-points
//
module line( pos1, pos2, width ) {
  assert( is_list(pos1) && len(pos1) >= 2 && len(pos1) <= 3 );
  assert( is_list(pos2) && len(pos2) >= 2 && len(pos2) <= 3 );
  assert( len( pos1 ) == len( pos2 ) );
  assert( is_num(width) );

  if( len( pos1 ) == 2 ) {
    assert( is_num(pos1.x) && is_num(pos1.y) );
    assert( is_num(pos2.x) && is_num(pos2.y) );

    hull() {
      translate( pos1 ) circle( d=width );
      translate( pos2 ) circle( d=width );
    }
  }
  else {
    assert( is_num(pos1.x) && is_num(pos1.y) && is_num(pos1.z) );
    assert( is_num(pos2.x) && is_num(pos2.y) && is_num(pos2.z) );

    hull() {
      translate( pos1 ) sphere( d=width );
      translate( pos2 ) sphere( d=width );
    }
  }
} // end line

// line_ray:
//
// Create a 2 dimensional ray based on an <angle> and two
// radial distances with a line of <width>.
//
module line_ray( angle, radius_start, radius_finish, width ) {
  assert( is_num( angle ) );
  assert( is_num( radius_start ) );
  assert( is_num( radius_finish ) );

  // Convert to polar coordinates
  line( polar_to_cartesian( angle, radius_start ), polar_to_cartesian( angle, radius_finish ), width );
} // end line_ray

// line_circular:
//
// Create a 2-dimensional circular perimeter based on radius
// with a line of <width>.
//
module line_circular( radius, width ) {
  assert( is_num( radius ) );
  assert( is_num( width ) );

  difference() {
    circle( r=radius+width/2 );
    circle( r=radius-width/2 );
  }
} // end line_circular

//$fn = 36;
//line( [0,0], [10,10], 2 );
//line( [0,0,0], [10,10,10], 2 );
//line_ray( 45, 0, 10, 2 );
//line_circular( 10, 2 );
