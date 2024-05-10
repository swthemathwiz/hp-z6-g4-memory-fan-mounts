//
// Copyright (c) Stewart H. Whitman, 2022-2024.
//
// File:    hp-z6-catch-top.scad
// Project: HP Z6 G4 Memory Fan Mounts
// License: CC BY-NC-SA 4.0 (Attribution-NonCommercial-ShareAlike)
// Desc:    HP Z6 G4 Top Front Fan Cage Catch Definitions
//

include <smidge.scad>;
include <rounded.scad>;
include <slanted.scad>;
include <gusset.scad>;

// Catch:
//
// Catch refers to the top area of the "mound". Radius
// is nominal.
//
// top_catch_size: length, width
top_catch_size = [ 54, 11 ];
top_catch_radius = 1;

// Slot:
//
// Two slots, centered atop the long axis and positioned
// symmetrically about the vertical center. Depth is the
// amount of "safe" space behind metal.
//
// top_slot_size: length, width, depth
top_slot_size = [ 8.25, 5.5, 4 ];
top_slot_separation = 34;
top_slot_centers = (top_slot_separation + top_slot_size.x)/2 * [ [ 1, 0 ], [ -1, 0 ] ];
top_slot_spacer = 1.2;
top_slot_gusset = 0.8;

// Box:
//
// Not really part of the catch, this is the depression
// between the slots in the center of the slots.
//
top_box_size = [ 23, top_slot_size.y-1.5, 2.6 ];
top_box_center = [ 0, 0 ];

// Fitting (tolerance) properties:
//
// These have been adapted to approximate the OEM tabs which measure:
//   [ width, height (excess), depth ] = [ 7.6, 1.4, 3.65 ]
//
top_tang_multiplier = [ 0.92, 0.9, 0.9 ];
top_box_multiplier = 0.8;
top_hollow_thickness = 0.8;

// For layout testing: (match main mount file)
top_layout_offsets = [6.3, 85.6, 9.055];

// top_catch_rounded_hollow: rounded hollow cube
module top_catch_rounded_hollow( size, radius, thickness ) {
  difference() {
    rounded_side_cube_upper( size, top_catch_radius/3);
    translate( [0,0,-SMIDGE] )
      rounded_side_cube_upper( size - 2 * [top_hollow_thickness, top_hollow_thickness, -SMIDGE ], top_catch_radius/3 );
  }
} // end top_catch_rounded_hollow

// top_tang_simple: angled tang
module top_tang_simple( tip_profile, tang_profile, notch_profile ) {
  assert( is_list(tip_profile) && len(tip_profile) == 3 );
  assert( is_list(tang_profile) && len(tang_profile) == 3 );
  assert( is_list(notch_profile) && len(notch_profile) == 2 );

  function round_to_tenths(v) = round(10*v)/10;

  tip_width     = tip_profile[0];
  tip_thickness = tip_profile[1];
  tip_depth     = tip_profile[2];

  tang_height_percentage = tang_profile[0];
  tang_angle             = tang_profile[1];
  tang_pivot_percentage  = tang_profile[2];

  tang_height            = tang_height_percentage / 100 * tip_thickness;
  tang_pivot             = tang_pivot_percentage / 100 * tip_thickness;

  notch_depth  = notch_profile[0];
  notch_height = notch_profile[1];

  tang_length = tang_height > 0 ? tang_pivot+(tip_thickness+tang_height/2)/tan(tang_angle) : 0;

  // y => thickness of the top
  // p => pivot point on the top
  // h => indent size
  // l => length of the tang
  // w => width of the tang
  let( y = tip_thickness, p = tang_pivot, h = round_to_tenths(tang_height), l = round_to_tenths(tang_length), w=round_to_tenths(tip_width), ni = notch_depth, nh = notch_height ) {
    //echo( "top tang [ width, height, depth ] =",  [w, h, l] );
    linear_extrude( height=w, center=true, convexity=20 ) {
      polygon([ [0,0], [0,nh], [ni,nh], [ni,y+h], [p,y+h], [l,+h/2], [l,0] ]);
    }
  }
} // end top_tang_simple

// top_tang_elliptical: ellipsoid tang
module top_tang_elliptical( tip_profile, tang_profile, notch_profile ) {
  assert( is_list(tip_profile) && len(tip_profile) == 3 );
  assert( is_list(tang_profile) && len(tang_profile) == 3 );
  assert( is_list(notch_profile) && len(notch_profile) == 2 );

  function round_to_tenths(v) = round(10*v)/10;

  tip_width     = tip_profile[0];
  tip_thickness = tip_profile[1];
  tip_depth     = tip_profile[2];

  tang_height_percentage = tang_profile[0];
  tang_angle             = tang_profile[1];
  tang_pivot_percentage  = tang_profile[2];

  tang_height = tang_height_percentage / 100 * tip_thickness + tip_thickness;
  tang_pivot  = tang_pivot_percentage  / 100 * tang_height;

  notch_depth  = notch_profile[0];
  notch_height = notch_profile[1];

  width_multiplier = 1.15;

  module ellipsoid(w, h, d) { scale([1, h/w, d/w]) sphere(r=w/2); }

  // h => height
  // w => width
  // d => depth
  // p => pivot height
  // o => pivot indent location (based on angle)
  let( h = round_to_tenths(tang_height), w = round_to_tenths(tip_width), d = round_to_tenths(tip_depth), p = tang_pivot, o = notch_depth + (h-p)*sin(tang_angle), ni = notch_depth, nh = notch_height ) {
    //echo( "top tang [ width, height, depth ] =",  [w, round_to_tenths(h-tip_thickness), d] );
    intersection() {
      // A little oversize across width (which will be clipped)
      ellipsoid( 2*d, 2*h, width_multiplier*w );

      // Bounding box
      linear_extrude( height=w, center=true, convexity=20 )
	polygon([ [0,0], [0,nh], [ni,nh], [ni,p], [o,h], [d,h], [d,0] ]);
    }
  } // end ellipsoid
} // end top_tang_elliptical

// top_catch_tang: the two top tangs
module top_catch_tang(style, thickness) {
  size = [ top_tang_multiplier.x * top_slot_size.x,
           top_tang_multiplier.y * top_slot_size.y,
           top_tang_multiplier.z * top_slot_size.z ];

  // none: nothing
  if( style == "none" ) {
    ;
  }
  // debug: just cubes (for fitting)
  else if( style == "debug" ) {
    rounded_side_cube_upper( top_slot_size, radius=0 );
  }
  // full: straight just scaled by percentage (for fitting)
  else if( style == "full" ) {
    top_catch_rounded_hollow( size, top_catch_radius/3, top_hollow_thickness );
  }
  // hook: insertion hooks
  else if( style == "hook" ) {
    // Width and height of hook
    tip_profile  = [ size.x, size.y/2, size.z ];

    // Profile of hook
    tang_profile = [ 70, 64, 80 ];

    // Profile of notch
    notch_profile = [ top_slot_spacer, thickness ];

    // Tang
    rotate( [0,-90,0] )
      top_tang_simple( tip_profile, tang_profile, notch_profile );

    // Gussets
    translate( [ +size.x/2-SMIDGE, 0, 0 ] ) rotate( [-90, -90, 0 ] ) round_gusset_3d( top_slot_gusset, thickness, quadrant=1 );
    translate( [ -size.x/2+SMIDGE, 0, 0 ] ) rotate( [-90, -90, 0 ] ) round_gusset_3d( top_slot_gusset, thickness, quadrant=4 );
  }
  // hook-elliptical:
  else if( style == "hook-elliptical" ) {
    // Width and height of hook
    tip_profile  = [ size.x, size.y/2, size.z ];

    // Profile of hook
    tang_profile = [ 70, 30, 70 ];

    // Profile of notch
    notch_profile = [ top_slot_spacer, thickness ];

    // Tang
    rotate( [0,-90,0] )
      top_tang_elliptical( tip_profile, tang_profile, notch_profile );

    // Gussets
    translate( [ +size.x/2-SMIDGE, 0, 0 ] ) rotate( [-90, -90, 0 ] ) round_gusset_3d( top_slot_gusset, thickness, quadrant=1 );
    translate( [ -size.x/2+SMIDGE, 0, 0 ] ) rotate( [-90, -90, 0 ] ) round_gusset_3d( top_slot_gusset, thickness, quadrant=4 );
  }
  else {
    assert( false, "top_catch_tang: style unknown!" );
  }
} // end top_catch_tang

// sparsifyX: remove a number of cells
module sparsifyX( cells, size, remainder ) {
  height = size.z - 2*remainder;
  if( height > 0 ) {
    count  = 2*cells+1;
    width  = size.x/count;

    cell_size = [ width, size.y+2*SMIDGE, height ];
    for( i = [1:count] ) {
      if( i%2==0 ) {
	translate( [width*i-size.x/2-width/2,0,remainder+height/2] )
	  cube( cell_size, center=true );
      }
    }
  }
} // end sparsifyX

module top_catch_base( style, height ) {
  size = concat( top_catch_size, height );

  if( style == "none" || height <= 0 ) {
    ;
  }
  // full: straight just scaled by percentage
  else if( style == "full" ) {
    rounded_side_cube_upper( size, top_catch_radius );
  }
  // layout: test out the distance to cage
  else if( style == "layout" ) {
    echo( "top tab layout offset =", top_layout_offsets );

    difference() {
      rounded_side_cube_upper( size, top_catch_radius );
      sparsifyX( 4, size, 2 );
    }

    // Down prong to bottom catch center
    {
      catch_center_to_bottom = size.z > 7 ? top_layout_offsets.y : 12;
      catch_center_to_mid    = -top_layout_offsets.x;
      translate( [-catch_center_to_mid,+catch_center_to_bottom/2,0] )
        rounded_side_cube_upper( [3, catch_center_to_bottom, min(size.z,3)], 0 );
    }
  }
  else {
    assert( false, "top_catch_base: style unknown!" );
  }
} // end top_catch_base

module top_catch_box(style,thickness) {
  size = [ top_box_size.x,
           top_box_size.y,
           (style == "full") ? top_box_size.z : top_box_multiplier*top_box_size.z ];

  // none: nothing
  if( style == "none" ) {
    ;
  }
  // debug: just flat panel
  else if( style == "debug" ) {
    // N.B.: show blocker position
    translate( [0,0,top_box_size.z] )
      rounded_side_cube_upper( [ size.x, size.y, 1 ], radius=0 );
  }
  // full: just a box
  else if( style == "full" ) {
    top_catch_rounded_hollow( size, top_catch_radius/3, top_hollow_thickness );
  }
  // hook: matching box for hooks
  else if( style == "hook" ) {
    translate( [0,thickness/2,0] )
      slanted_cube( [ size.x, thickness, size.z ], x_angle=-30 );
  }
  else {
    assert( false, "top_catch_box: style unknown!" );
  }
} // end top_catch_box

module top_catch_fitting(height=3,base_style="full",tang_style="full",box_style="full",thickness=2) {
  assert( is_num(height) && height >= 0 );

  difference() {
    union() {
      // Base
      top_catch_base( base_style, height );

      // Box
      translate( concat( top_box_center, height-SMIDGE ) )
	top_catch_box( box_style, thickness );

      // Slot projection
      for( p = top_slot_centers )
        translate( concat( p, height-SMIDGE ) )
          top_catch_tang( tang_style, thickness );
    }
  }
} // end top_catch_fitting

// top_catch_get_size, top_catch_get_below_size:
//
// Returns [ length, width, height above/below case ]
//
function top_catch_get_size()         = concat( top_catch_size, top_slot_size.z );
function top_catch_get_slot_size()    = top_slot_size;
function top_catch_get_slot_centers() = top_slot_centers;
function top_catch_get_box_size()     = top_box_size;
function top_catch_get_box_center()   = top_box_center;

$fn = 64;
//top_catch_fitting( height=3, base_style="full", tang_style="full");
//top_catch_fitting( height=top_layout_offsets.z, base_style="layout", tang_style="full", box_style="full");
//top_catch_fitting( height=2.4, base_style="layout", tang_style="full", box_style="full");
top_catch_fitting( height=3, base_style="full", tang_style="hook", box_style="hook");
//top_catch_fitting( height=3, base_style="full", tang_style="hook-elliptical", box_style="hook");
//translate( [0,0,3] ) color( "black", 0.10 ) top_catch_fitting( height=0, tang_style="debug", box_style="debug" );
