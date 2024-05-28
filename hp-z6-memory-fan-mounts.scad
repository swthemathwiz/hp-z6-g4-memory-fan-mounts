//
// Copyright (c) Stewart H. Whitman, 2022-2024.
//
// File:    hp-z6-memory-fan-mounts.scad
// Project: HP Z6 G4 Memory Fan Mounts
// License: CC BY-NC-SA 4.0 (Attribution-NonCommercial-ShareAlike)
// Desc:    Printable HP Z6 G4 Front Fan Mount (Single and Dual)
//

include <smidge.scad>;
include <rounded.scad>;
include <fan.scad>;
include <screw-hole.scad>;
include <slanted.scad>;
include <bridge.scad>;
include <gusset.scad>;
include <line.scad>;

use <hp-z6-catch-bottom.scad>;
use <hp-z6-catch-top.scad>;

/* [General] */

// Single or dual model
model = "single"; // [ "single", "dual" ]

// Show mount (others for debugging)
show_selection = "mount"; // [ "mount", "mount/fan", "mount/machine", "mount/machine/axis", "fan", "washer", "washers" ]

/* [Primary Fan] */

// Primary Fan model
pri_fan_model = "80x80x25"; // [ "80x80x25", "92x92x25", "120x120x25" ]

// Primary Fan specifications
pri_fan_spec = fan_get_spec( pri_fan_model );

// Primary thumbnail offsets (mm)
pri_thumbnail_width = 14;

// Primary thumbnail width (mm)
pri_thumbnail_height = 3.6;

// Primary thumbnail offset (mm)
pri_thumbnail_offset = 6;

/* [Secondary Fan] */

// Secondary Fan model
sec_fan_model = "80x80x25"; // [ "80x80x25", "92x92x25", "120x120x25" ]

// Secondary Fan specifications
sec_fan_spec = fan_get_spec( sec_fan_model );

// Position of secondary fan relative to middle DIMM slot (mm)
sec_fan_offset = -10; // [-40:1:40]

// Height of secondary fan above primary fan (mm)
sec_fan_height = +10; // [0:1:60]

// Primary to secondary bridge spanner width (mm)
sec_bridge_width  = 6; // [3:1:12]

// Primary to secondary bridge count and offsets (mm)
sec_bridge_pos = [-0,+15,+30];

// Trim secondary fan cage depth to fit fan
sec_baffle_trim_to_fit = true;

/* [Baffle] */

// Thickness for the baffle face (mm)
baffle_thickness = 2.0; // [1:0.1:5]

// Thickness for the baffle sides around fan (mm per side)
baffle_extra_side = 2.8; // [2:0.1:5]

// Height of baffle sides around fan (mm)
baffle_extra_height = 28; // [5:1:35]

// Decorative radius around baffle (mm)
baffle_radius = 2; // [0:0.5:5]

// Air hole at fan outlet matching slant (degrees)
baffle_air_hole_slant = 80; // [70:5:90]

// Extra space between fan and baffle (mm per side)
baffle_fan_spacing_side = 0.4; // [0.0:0.1:1]

// Decorative radius in space between fan and baffle (mm)
baffle_fan_spacing_radius = 0.2; // [0:0.1:2]

// Side cutout height (mm)
baffle_side_cutout_height = 14; // [0:0.5:20]

// Side cutout angle (degrees)
baffle_side_cutout_slant = 75; // [10:5:90]

// Side cutout width (percentage of side)
baffle_side_cutout_percentage = 65; // [0:1:75]

// Side cutout offset from center (mm)
baffle_side_cutout_offset = -4; // [-20:1:20]

// Oversize screw holes assumes fan guard (alternative is tight and countersunk)
baffle_screw_hole_oversize = true;

// Extra space cut out baffle for fan (mm per side)
baffle_overfit_min = max( 0, min( baffle_fan_spacing_side, baffle_extra_side) );

// Effective thickness of baffle side after extra side space cut out (mm per side)
baffle_effective_side_thickness = baffle_extra_side-baffle_overfit_min;

// Width of top corner retainers or zero for none (mm)
baffle_security_retainer_width = 5; // [0:.2:8]

// Offset of top corner retainers (mm)
baffle_security_retainer_offset = 3; // [2:.2:6]

// Interior angle of sides (degrees)
baffle_interior_angle = 1.6; // [0:0.1:3]

/* [Grill] */

// Create a grill
grill_add = true;

// Layout grills of different fan sizes geometrically similar
grill_normalize = true;

// Width of the lines of the grill (mm)
grill_line_width = 2.2; // [1:0.1:5];

// Distance between concentric circles (mm)
grill_step_distance = 10; // [5:1:20]

// Number of supporting ribs
grill_ribs = 6; // [4:1:8]

// Starting angle of rib pattern - polar standard (degrees)
grill_rib_start_angle = 105; // [0:5:360]

/* [Washer] */

// Thickness of the washer (mm)
washer_height = 1.6; // [1:0.1:3]

// Diameter of washer (mm)
washer_diameter = 10; // [8:1:14]

/* [Machine Locations and Sizes] */

// Fan -> Baffle utility functions
function baffle_get_area( fan_spec ) = fan_get_attribute( fan_spec, "area" ) + 2 * [ baffle_extra_side, baffle_extra_side ];
function baffle_get_area_with_height( fan_spec, height ) = concat( baffle_get_area( fan_spec ), height );
function baffle_get_total_size( fan_spec ) = baffle_get_area_with_height( fan_spec, baffle_thickness+baffle_extra_height );

// Total size of baffle including walls
pri_baffle_total_size = baffle_get_total_size( pri_fan_spec );

// Inside wall to opposite outside wall (mm)
pri_baffle_inside_to_outside = pri_baffle_total_size.y-baffle_effective_side_thickness;

// N.B.: These distances relative to the bottom catch are generally
//       measured from the "center" of the bottom catch which
//       is the intersection of the mid-points of the slots with
//       the center of the tab.

// Position of bottom catch (constant - our machine origin)
machine_bottom_catch_center = [ 0, 0, 0+0 ];

// Distance to center of top tabs above top of catch (mm)
machine_case_to_catch_top = 85.6; // As measured, width inside (81.8) + base height (3.8)

// Is the primary fan oversize? If so, the top catch won't fit
pri_fan_is_oversize = machine_case_to_catch_top-pri_baffle_inside_to_outside < 0;

// Distance from baffle bottom to machine (mm)
machine_catch_to_baffle_bottom = 1.2;

// Distance from baffle front to bottom catch center (mm)
machine_catch_to_baffle_rear = -bottom_catch_get_tang_width()/2;

// Distance from middle of baffle to catch (mm)
machine_catch_to_baffle_middle = -4.7;

// Distance up to center of top tabs above top of catch (mm)
machine_tabs_to_catch_top = machine_case_to_catch_top;

// Distance forward to center of top tabs rear of baffle (mm)
machine_tabs_to_baffle_rear = 7.6;

// Distance right-left to center of top tabs from mid-catch slots (mm)
machine_tabs_to_catch_middle = 6.3;

// Position of mid-point of the two top insertion tabs from machine origin
machine_top_tabs_center = [ machine_tabs_to_catch_middle, machine_tabs_to_catch_top, machine_tabs_to_baffle_rear - machine_catch_to_baffle_rear ];

// Distance of middle top DIMM slot to mid-catch slots (mm)
machine_middle_dimm_to_catch_middle = 127;

/* [Hidden] */

// Used to reposition primary fans larger than stock 80x80
machine_baffle_total_size = baffle_get_total_size( fan_get_spec("80x80x25") );

// Mapping of machine position to build position
//
// N.B.: For primary fans > 80mm, automatically slide the fan toward
// the bottom of the case (to avoid blocker and wiring)
//
function machine_to_model( p ) = [ p.x + machine_catch_to_baffle_middle + (pri_baffle_total_size.x-machine_baffle_total_size.x)/2,
                                   p.y - pri_baffle_total_size.y/2 - machine_catch_to_baffle_bottom,
                                   p.z + pri_baffle_total_size.z + machine_catch_to_baffle_rear ];

// Model middle point (0,0,0) coordinates in our machine axis
machine_model_middle = -machine_to_model( [0,0,0] );

// Position of secondary fan - center x/y
machine_second_fan_bottom_front = [ machine_middle_dimm_to_catch_middle + sec_fan_offset,
                                    machine_catch_to_baffle_bottom + sec_fan_height + baffle_get_area( sec_fan_spec ).y/2,
                                    machine_model_middle.z ];
// Primary fan expansion
pri_fan_baffle_expansion = [ 0, pri_fan_is_oversize ? 0 : machine_tabs_to_baffle_rear ];

// Primary fan total height
pri_fan_baffle_total_height = pri_baffle_total_size.z + pri_fan_baffle_expansion.y;

// Primary fan center model position (always centered at axis)
function pri_fan_get_model_pos() = [ 0, 0 ];

// Secondary fan expansion
sec_fan_baffle_expansion = [ sec_baffle_trim_to_fit ? fan_get_attribute( sec_fan_spec, "width" ) + 0.4 - baffle_extra_height : 0,
                             sec_baffle_trim_to_fit ? fan_get_attribute( sec_fan_spec, "width" ) + 0.4 - baffle_extra_height : 0 ];

// Secondary fan center model position
function sec_fan_get_model_pos() = [ machine_to_model( machine_second_fan_bottom_front ).x, machine_to_model( machine_second_fan_bottom_front ).y ];

// baffle_to_top_inside_slant_angle, baffle_to_top_outside_slant_angle:
//
// Slant the top of the fan baffle back to match the top catch position
//

// Distance we need to make up to make top catch meet the machine
pri_fan_slant_makeup_distance = pri_fan_is_oversize ? 0 : machine_case_to_catch_top - pri_baffle_inside_to_outside - machine_catch_to_baffle_bottom;

function baffle_to_top_inside_slant_angle()  = atan2( pri_fan_slant_makeup_distance, pri_fan_baffle_total_height - baffle_thickness + baffle_fan_spacing_radius );
function baffle_to_top_outside_slant_angle() = atan2( pri_fan_slant_makeup_distance, pri_fan_baffle_total_height );
function baffle_is_slanted() = baffle_to_top_inside_slant_angle() != 0;

// Minimum height of baffle side (mm)
function baffle_min_height( expansion=[0,0] ) =
  max( 0, min( baffle_extra_height + min( expansion ), baffle_extra_height - baffle_side_cutout_height ) ) + baffle_thickness;

// show_fan_model: show fan model(s) in position on mount or alone
module show_fan_model(transparency=0.25) {
  color( "black", transparency ) {
    // Primary fan
    translate( concat( pri_fan_get_model_pos(), show_selection != "fan" ? +baffle_thickness+.1 : 0 ) )
      fan_model( pri_fan_spec );

    // Secondary fan
    if( model != "single" )
      translate( concat( sec_fan_get_model_pos(), show_selection != "fan" ? +baffle_thickness+.1 : 0 ) )
	fan_model( sec_fan_spec );
  }
} // end show_fan_model

// show_machine: show machine origin, planes, and attachment element positions
module show_machine(axis=false,transparency=0.25) {
  // Show the machine origin planes
  if( axis )
    color( "yellow", transparency/3 )
      translate( machine_to_model( machine_bottom_catch_center ) ) {
	nominal_plane_thickness = 0.1;
        nominal_fan_side        = 80;
        nominal_fan_width       = 25;

        // Tiny X/Y/Z plane lines
	cube( [ nominal_plane_thickness, 3*nominal_fan_side,       2*nominal_fan_width ],     center=true );
	cube( [ 2*nominal_fan_side,      3*nominal_fan_side,       nominal_plane_thickness ], center=true );
	cube( [ 2*nominal_fan_side,      nominal_plane_thickness,  2*nominal_fan_width ],     center=true );
      }

  // Show top catch slot positions
  color( "black", transparency )
    translate( machine_to_model( machine_top_tabs_center ) )
      top_catch_fitting( height=0, tang_style="debug", box_style="debug" );

  // Show bottom catch tab/slots position
  color( "black", transparency )
    translate( machine_to_model( machine_bottom_catch_center ) )
      rotate( [ 90, 180, 0 ] )
        bottom_catch_fitting( height=0, tang_style="debug" );

  // Show little metal blocker (approximate)
  color( "black", transparency )
    translate( machine_to_model( [ +48, +2, -2 ] ) )
      cube( [ 1, 6, 12 ] );
} // end show_machine

// foreach_side_rotated: rotate around Z axis by 90 degree multiple: 0, 1, 2, 3 in <mask>
module foreach_side_rotated( mask ) {
  for( i = mask )
    rotate( [ 0, 0, 90*i ] )
      children();
} // end foreach_side_rotated

// foreach_side_mirrored: mirror in X and Y axis combinations: 0, 1, 2, 3 in <mask>
module foreach_side_mirrored( mask ) {
  for( i = mask )
    mirror( [ i == 2 || i == 3 ? 1 : 0, 0, 0 ] )
      mirror( [ 0, i == 1 || i == 3 ? 1 : 0, 0 ] )
	children();
} // end foreach_side_mirrored

// replicate_n: Replicate elements at a <distance> from the origin, rotated <theta> degrees
module replicate_n( n, distance = 0 ) {
  theta = 360/n;
  for( i = [0:n-1] )
    translate( concat( polar_to_cartesian( theta*i, distance ), 0 ) )
      rotate( [ 0, 0, theta*i ] )
        children();
} // end replicate_n

// fan_grill:
//
// Create a grill for a fan
//
module fan_grill( fan_spec, thickness, convexity=10 ) {
  fan_area = fan_get_attribute( fan_spec, "area" );

  // Normalize resemblance to 80-mm fan
  step_distance = grill_normalize ? (grill_step_distance * max( fan_area ) / 80 ) : grill_step_distance;

  // Concentric circle parameters
  circle_count        = ceil( min( fan_area ) / 2 / step_distance );
  circle_start_radius = step_distance/2;

  // Ribs parameters
  rib_max_length = norm( fan_area ) / 2;

  linear_extrude( height=thickness, convexity=convexity ) {
    intersection() {
      // Delete any overflow
      square( fan_area, center=true );

      union() {
        // Concentric circles
        for( i = [1:circle_count] )
          line_circular( circle_start_radius + (i-1) * step_distance, grill_line_width );

        // Ribs
        replicate_n( grill_ribs )
          line_ray( grill_rib_start_angle, circle_start_radius, rib_max_length, grill_line_width );
      }
    }
  }
} // end fan_grill

// baffle:
//
// Creates the squarish baffle with all its attachments. Expansion
// is an array of side height to add (or subtract) from [ <bottom>, <top> ]
// halves. <is_top_loader> indicates that the fan is loaded from the top
// instead of being inserted from the rear.
//
module baffle( fan_spec, expansion=[0,0], is_top_loader=false ) {

  assert( is_list(expansion) && len(expansion) == 2 && is_num(expansion[0]) && is_num(expansion[1]) );

  // Decoration-related boolean tests
  has_top_attachments  = ($children != 0);
  has_side_attachments = is_top_loader;

  // Maximal volume of baffle (with expansion and not including children)
  baffle_maximal_size = baffle_get_area_with_height( fan_spec, baffle_thickness+baffle_extra_height+max(expansion) );

  // air_hole_deletion:
  //
  // Air-hole in the baffle - a rounded square (squircle-like) shape.
  //
  module air_hole_deletion( fan_spec ) {
    // Air-hole sizes
    air_hole_side_to_side = fan_get_attribute( fan_spec, "air_hole_side" );
    air_hole_diameter     = fan_get_attribute( fan_spec, "air_hole_diameter" );

    function fan_air_hole_scaling() = 1/sin(baffle_air_hole_slant);

    $fn = 4*$fn;
    translate( [0,0,-2*SMIDGE] )
      linear_extrude( height=baffle_thickness+4*SMIDGE, scale=1/fan_air_hole_scaling() )
	scale( [ fan_air_hole_scaling(), fan_air_hole_scaling() ] )
	  intersection() {
	    circle( d=air_hole_diameter );
	    square( air_hole_side_to_side, center=true );
	  }
  } // end air_hole_deletion

  // mounting_hole_deletion:
  //
  // Mounting holes in the baffle
  //
  module mounting_hole_deletion( fan_spec ) {
    // Mounting screw diameter (mm)
    fan_screw_hole_diameter = fan_get_attribute( fan_spec, "screw_hole_diameter" );

    // Side of mounting holes center square (mm)
    fan_screw_hole_positions = fan_get_screw_positions( fan_spec );

    // Screw hole size and countersinking
    screw_hole_diameter = baffle_screw_hole_oversize ? fan_screw_hole_diameter+0.35 : fan_screw_hole_diameter;
    screw_hole_countersink = !baffle_screw_hole_oversize;

    // Fan mounting holes (possibly countersunk)
    for( p = fan_screw_hole_positions )
      screw_hole( p, baffle_thickness, screw_hole_diameter, screw_hole_countersink, 1.5, false );
  } // end mounting_hole_deletion

  // fan_body_deletion:
  //
  // Slightly-oversized hole for fan.
  //
  module fan_body_deletion( fan_spec ) {
    // Add a little if slanted base - this effectively slopes the bottom all the top tabs
    extra_height = !has_side_attachments ? +10 : 0;

    // Add a little space around the fan
    overfit_area = fan_get_attribute( fan_spec, "area" ) + 2 * [ baffle_overfit_min, baffle_overfit_min ];
    overfit_size = concat( overfit_area, baffle_maximal_size.z - baffle_thickness + baffle_fan_spacing_radius + extra_height );

    // Interior angle of sides
    interior_y_angle = [ has_top_attachments ? baffle_to_top_inside_slant_angle() : baffle_interior_angle, baffle_interior_angle/2 ];
    interior_x_angle = has_side_attachments ? [0, 0] : [ baffle_interior_angle, baffle_interior_angle ];

    // Carve out volume
    translate( [ 0, 0, +baffle_thickness - SMIDGE ] )
      slanted_rounded_all_cube( overfit_size + [0,0,2*SMIDGE], baffle_fan_spacing_radius, y_angle=interior_y_angle, x_angle=interior_x_angle );
  } // end fan_body_deletion

  // side_cutout_deletion:
  //
  // Mostly decorative beveled cutback on selected sides of baffle frame
  //
  module side_cutout_deletion( fan_spec, mask, side_cutout_offset=0 ) {
    // Cutout
    baffle_side_cutout_area = [ baffle_side_cutout_percentage/100*baffle_maximal_size.y, baffle_maximal_size.x ];
    baffle_side_cutout_size = concat( baffle_side_cutout_area, ( min( baffle_extra_height, baffle_side_cutout_height ) + max(expansion) ) );

    if( baffle_side_cutout_percentage > 0 && baffle_side_cutout_size.z > 0 ) {
      h = max( fan_get_attribute( fan_spec, "area" ) );
      translate( [0,side_cutout_offset,0] )
	foreach_side_rotated( mask )
	  translate( [0,baffle_side_cutout_size.y/2,baffle_maximal_size.z+h] + [ SMIDGE, SMIDGE, SMIDGE ] )
	    rotate( [180,0,0] )
	      slanted_cube( baffle_side_cutout_size + [2*SMIDGE,2*SMIDGE,h+SMIDGE], x_angle=90-baffle_side_cutout_slant, invert=true );
    }
  } // end side_cutout_deletion

  // security_retainer_deletion:
  //
  // Small triangular cutouts at the top of the sides of baffle frame
  //
  module security_retainer_deletion( fan_spec, width, delta=4 ) {
    if( width > 0 ) {
      baffle_top_size  = baffle_get_area_with_height( fan_spec, baffle_thickness+baffle_extra_height+expansion[1] );
      top_corner_pos   = [ baffle_top_size.x/2, baffle_top_size.y/2, baffle_top_size.z ];
      security_retainer_pos = top_corner_pos - [ 0, max( delta + baffle_radius/2, baffle_effective_side_thickness ), delta ];

      foreach_side_mirrored( [0,2] )
	translate( security_retainer_pos + [ SMIDGE, 0, 0 ]  )
	  rotate( [0, -90, 0 ] )
	    linear_extrude( height=baffle_effective_side_thickness+2*SMIDGE )
	      polygon( [[ -width, -width ], [ -width, 0 ], [ 0, -width ]] );
    }
  } // end security_retainer_deletion

  difference() {
    union() {
      difference() {
	union() {
	  difference() {
	    // Baffle frame
	    slanted_rounded_side_cube( baffle_maximal_size, baffle_radius, y_angle=[ has_top_attachments ? baffle_to_top_outside_slant_angle() : 0, 0] );

	    // Delete non-expanded top and/or bottom (assumes half volume is sufficient)
	    for( i = [0:1] ) {
	      h       = baffle_thickness+baffle_extra_height+expansion[i];
	      delta_h = baffle_maximal_size.z - h;
	      if( delta_h > 0 ) {
		rotate( [0,0,180*i] )
		  translate( [0,-baffle_maximal_size.y/4,h] )
		    rounded_side_cube_upper( [ baffle_maximal_size.x, baffle_maximal_size.y/2, delta_h ] + [ 2*SMIDGE, 2*SMIDGE, SMIDGE ], 0 );
	      }
	    }

	    // Mostly decorative beveled cutback on sides of baffle frame
	    side_cutout_deletion( fan_spec, [1,3], baffle_side_cutout_offset );

            // Mostly decorative beveled cutback on top and bottom of baffle frame if no attachments
	    if( !has_top_attachments )
	      side_cutout_deletion( fan_spec, [2,4], 0 );

	    // Entirely delete the top baffle wall for a top loader
	    if( is_top_loader ) {
	      translate( [ -baffle_maximal_size.x/2, baffle_maximal_size.y/2 - baffle_extra_side, 0 ] - [SMIDGE, SMIDGE, SMIDGE] )
		cube( [ baffle_maximal_size.x, baffle_extra_side, baffle_maximal_size.z ] + [ 2*SMIDGE, 2*SMIDGE, 2*SMIDGE ] );
	    }

	    // Security retainer cut outs in corners (if there is space)
            if( baffle_maximal_size.z - baffle_security_retainer_width - baffle_security_retainer_offset > fan_get_attribute( fan_spec, "width" ) + baffle_thickness ) 
	      translate( [ 0, is_top_loader ? -baffle_effective_side_thickness/2 : 0, 0 ] )
		security_retainer_deletion( fan_spec, baffle_security_retainer_width, baffle_security_retainer_offset );
	  }

	  // Attach any children, prior to deletions of space for the fan components
	  children();
	}

	// Air-hole cutout
	air_hole_deletion( fan_spec );
      }

      // Add the grill after air-hole deletion and before body/hole deletion
      if( grill_add )
	fan_grill( fan_spec, baffle_thickness );
    }

    // Slightly-oversized hole for fan
    fan_body_deletion( fan_spec );

    // Fan/Guard mounting holes (possibly countersunk)
    mounting_hole_deletion( fan_spec );
  }
} // end baffle

// bottom_catch_attach:
//
// Attach the bottom catch to square part of the baffle.
//
module bottom_catch_attach() {
  // Create the catch at the bottom
  translate( machine_to_model( machine_bottom_catch_center ) + [0,SMIDGE,0] )
    rotate( [ 90, 180, 0 ] )
      bottom_catch_fitting( height=machine_catch_to_baffle_bottom, base_style="sloped-half", tang_style="tilt" );
} // end bottom_catch_attach

// top_catch_attach:
//
// Attach the top catch to square part of the baffle.
//
module top_catch_attach() {
  // Force flush due to a small slope difference
  delta_w = baffle_is_slanted() ? +0.02 : 0;

  // Create the catch at top
  translate( machine_to_model( machine_top_tabs_center ) - [0,delta_w,SMIDGE] )
    top_catch_fitting( height=0, thickness=baffle_effective_side_thickness+delta_w, base_style="none", tang_style="hook", box_style="hook" );
} // end top_catch_attach

// single_mount:
//
// A single mount - baffle with all its attachments
//
module single_mount() {

  // top_catch_platform: build a simple platform for the top catch (for oversize fans)
  module top_catch_platform() {
    platform_h = machine_tabs_to_baffle_rear;
    platform_w = baffle_get_area( pri_fan_spec ).x;
    platform_t = baffle_effective_side_thickness;

    translate( machine_to_model( [machine_model_middle.x, machine_top_tabs_center.y + platform_t/2, machine_top_tabs_center.z] ) ) {
      // Platform itself
      {
	platform_h_full = baffle_thickness + baffle_extra_height + platform_h;
	translate( [ 0, 0, -platform_h_full/2 ] )
	  rotate( [ 90, 0, 0 ] )
	    difference() {
	      rounded_side_cube( [ platform_w, platform_h_full, platform_t ], center=true, radius=baffle_radius );
	      translate( [ 0, -platform_h/2 - SMIDGE, 0 ] )
		cube( [ platform_w, platform_h_full - platform_h, platform_t ] + [ 2*SMIDGE, 0, 2*SMIDGE ], center=true );
	    }
      }

      // Platform side gussets
      foreach_side_mirrored( [1,3] )
        foreach_side_mirrored( [2,3] )
          translate( [ +platform_w/2, platform_t/2-SMIDGE, -platform_h-SMIDGE ] )
	    rotate( [ 0, -90, 0 ] )
	      round_gusset_3d( platform_h/2, baffle_effective_side_thickness, quadrant=1 );
    }
  } // end top_catch_platform

  module top_thumbnails() {
    // thumbnail: a half-moon type shape
    module thumbnail( w, h ) {
      r = w*w / (8*h) + h/2;
      o = r-h + h/2;
      intersection() {
	translate( [0,-o] ) circle( r=r );
	square( [ w, h ], center=true );
      }
    } // end thumbnail

    // Put a thumbnail behind each top catch slot
    for( pos = top_catch_get_slot_centers() )
      translate( machine_to_model( machine_top_tabs_center ) + [ pos.x, baffle_effective_side_thickness+SMIDGE, -pri_thumbnail_offset ] )
	rotate( [ 90, 0, 0 ] )
	  linear_extrude( height=2*baffle_effective_side_thickness+2*SMIDGE )
	    thumbnail( pri_thumbnail_width, pri_thumbnail_height );
  } // end top_thumbnails

  // Fan
  difference() {
    // Baffle with catches attached
    baffle( pri_fan_spec, pri_fan_baffle_expansion, pri_fan_is_oversize ) {

      // Attach the bottom catch interface
      bottom_catch_attach();

      // If oversize, build a platform to attach top catch
      if( pri_fan_is_oversize )
	top_catch_platform();

      // Attach the top catch interface
      top_catch_attach();
    }

    // Small thumbnail deletions for flex and also to allow security leash
    if( !pri_fan_is_oversize )
      top_thumbnails();
  }
} // end single_mount

// dual_mount:
//
// A dual mount - two connected baffles
//
module dual_mount() {
  function model_width( pos1, size1, pos2, size2 ) = (pos2.x + size2.x/2) - (pos1.x - size1.x/2);

  // Primary fan
  single_mount();

  // Secondary fan
  {
    // Primary fan size and center position
    pri_fan_size = baffle_get_area_with_height( pri_fan_spec, baffle_min_height( pri_fan_baffle_expansion ) );
    pri_fan_pos  = pri_fan_get_model_pos();

    // Secondary fan size and center position
    sec_fan_size = baffle_get_area_with_height( sec_fan_spec, baffle_min_height( sec_fan_baffle_expansion ) );
    sec_fan_pos  = sec_fan_get_model_pos();

    // State width
    echo( "Total Width = ", model_width( pri_fan_pos, pri_fan_size, sec_fan_pos, sec_fan_size ) );

    // Fan
    translate( sec_fan_pos - [ 2*SMIDGE, 0, 0 ] ) baffle( sec_fan_spec, sec_fan_baffle_expansion );

    // Bridge links
    sec_bridge_span   = ( sec_fan_pos.x - pri_fan_pos.x ) - ( sec_fan_size.x + pri_fan_size.x ) / 2;
    sec_bridge_radius = max( 0, min( sec_bridge_width / 2, sec_bridge_span / 3 ) );
    for( y = sec_bridge_pos ) {
      translate( [ -SMIDGE, 0, 0 ] )
	bridge_cubes( pri_fan_size, pri_fan_pos + [0,y],
		      sec_fan_size, sec_fan_pos + [0,y],
		      width  = sec_bridge_width,
		      radius = sec_bridge_radius );
    }
  }
} // end dual_mount

// washer:
//
// A countersunk washer shaped for a fan screw's head
//
module washer( fan_spec ) {
  // Mounting screw diameter (mm)
  fan_screw_hole_diameter = fan_get_attribute( fan_spec, "screw_hole_diameter" );

  // Minimal screw center to side (mm)
  fan_screw_to_side = fan_get_min_screw_to_side_distance( fan_spec );

  // Washer itself
  washer_effective_diameter = min( washer_diameter, 2*(fan_screw_to_side + baffle_extra_side) );
  washer_volume             = [ washer_effective_diameter, washer_effective_diameter, washer_height ];
  //echo( "Washer Diameter = ", washer_effective_diameter );

  // Screw hole size and countersinking
  screw_hole_diameter = fan_screw_hole_diameter+0.35;

  difference() {
    // Washer itself
    rounded_top_volume( washer_volume, radius=0.4, c=[ 0, 0, washer_height/2 ] )
      cylinder( h=washer_height, d=washer_effective_diameter );

    // Countersunk hole
    screw_hole( [0,0], washer_height, screw_hole_diameter, countersink=true, countersink_multiplier=1.5, countersink_top=true );
  }
} // end washer

// washers:
//
// Fan screw countersunk washers for each hole
//
module washers( fan_spec ) {
  // Replicate a washer for each screw hole
  replicate_n( fan_get_screw_count( fan_spec ), (washer_diameter+2)/sqrt(2) )
    washer( fan_spec );
} // end washers

$fn = 64;
if( show_selection == "fan" )
  show_fan_model();
else if( show_selection == "washers" )
  washers( pri_fan_spec );
else if( show_selection == "washer" )
  washer( pri_fan_spec );
else { // shows mount
//intersection() {
  if( model != "single" )
    dual_mount();
  else
    single_mount();
//translate( [ 0, 0, 23 ] ) rounded_top_cube_upper( [ 400, 400, 40 ], radius=0 ); // Rear slice
//translate( [ +59, -50, 0 ] ) rounded_top_cube_upper( [ 118, 141, 40 ], radius=0 ); // Bridge slice
//cube( [ 500, 500, 2*6 ], center=true ); // Center slice
//}

  if( show_selection == "mount/fan" )
    show_fan_model();
  if( show_selection == "mount/machine" )
    show_machine(axis=false);
  if( show_selection == "mount/machine/axis" )
    show_machine(axis=true);
}
//echo( "top tab layout offset =",  machine_top_tabs_center );
//echo( "bottom baffle height offset =",  machine_catch_to_baffle_bottom );
