//
// Copyright (c) Stewart H. Whitman, 2022-2024.
//
// File:    fan.scad
// Project: General
// License: CC BY-NC-SA 4.0 (Attribution-NonCommercial-ShareAlike)
// Desc:    Fan Specifications.
//

include <hash.scad>;

//
// Fan model information:
//

// Fan Measurements taken from:
//   80mm:  https://www.delta-fan.com/AFB0812HH.html
//   92mm:  https://www.delta-fan.com/AFB0912HH.html
//   120mm: https://www.delta-fan.com/AFB1212HH.html
// Air-hole Cutout dimensions:
//   92mm:  https://www.performance-pcs.com/media/amasty/webp/catalog/product/cache/e9a227eb9cad51da07d9433f80fbb516/t/m/tmpsilencefan1_t_01.webp
//

// Overview:
//
// Access a fan's specification:
//    spec = fan_get_spec( "120x120x25" );
//
// Get an attributes:
//    echo( "Fan Size is ", fan_get_attribute( spec, "side" ) ); // -> 120
//
// Produce a model:
//    fan_model( spec ); // Model of fan
//
// Models are centered with outlet face centered on X/Y origin and Z positive.
//

// Attributes:
//
//   Computer Standard:
//     side - Frame size square (mm)
//     width - Frame width (mm)
//     screw_hole_diameter - Diameter of mounting hole (mm)
//     screw_hole_side - Side of mounting holes center square (mm)
//
//   Convenience:
//     area - Vector [ side, side ] (mm)
//     volume - Vector [ side, side, width ] (mm)
//
//   Non-Standard:
//     frame-thickness - Thickness of frame structure (mm)
//     air_hole_side - Side of air-hole cutout (mm)
//     air_hole_diameter - Diameter of air-hole cutout (mm)
//
//   Model:
//     filename - importable file
//     translation - translation to adjust to model origin to center of fan outlet
//     rotation - rotation to adjust to model origin to center of fan outlet
//

// fan_get_spec:
//
// Get the specification associated with <name>.
//
function fan_get_spec( name ) = hash_get( fan_specifications, name );

// fan_get_attribute:
//
// Retrieves an <attribute> from a <spec>.
//
function fan_get_attribute( spec, attribute ) = hash_get( spec, attribute );

// fan_has_attribute:
//
// Returns true if a <spec> has an <attribute>.
//
function fan_has_attribute( spec, attribute ) = hash_exists( spec, attribute );

// fan_has_model:
//
// Returns true if a <spec> includes a model.
//
function fan_has_model( spec ) = fan_has_attribute( spec, "model" );

// fan_model:
//
// Show fan center in X/Y at zero and with a Z at zero. Outlet
// positioned down.
//
module fan_model( spec ) {
  if( !fan_has_model( spec ) )
    echo( "No model found for fan ", fan_get_attribute( spec, "name" ) );
  else {
    model = fan_get_attribute( spec, "model" );

    rotate( hash_exists( model, "rotation" ) ? hash_get( model, "rotation" ) : [0,0,0] )
      translate( hash_exists( model, "translation" ) ? hash_get( model, "translation" ) : [0,0,0] )
	import( file = hash_get( model, "filename" ) );
  }
} // end fan_model

// fan_get_screw_positions:
//
// Returns list of X/Y positions of screw hole centers
// relative to center of fan.
//
function fan_get_screw_positions(spec) = let ( screw_hole_side = fan_get_attribute( spec, "screw_hole_side" ) ) [
  for( x = [ -screw_hole_side/2, +screw_hole_side/2 ] )
    for( y = [ -screw_hole_side/2, +screw_hole_side/2 ] )
      [ x, y ]
]; // end fan_get_screw_positions

// fan_get_screw_count:
//
// Returns the number of screws on the fan front.
//
function fan_get_screw_count(spec) = len( fan_get_screw_positions(spec) );

// fan_get_min_screw_to_side_distances:
//
// Returns list of the minimal distances from each mounting hole centers
// to its nearest side as a vector.
//
function fan_get_min_screw_to_side_distances( spec ) = let( area = fan_get_attribute( spec, "area" )/2, pos = fan_get_screw_positions( spec ) )
     [ for( p = pos ) min( abs( p.x - -area.x ), abs( +area.x - p.x ), abs( p.x - -area.y ), abs( area.y - p.y ) ) ];

// fan_get_min_screw_to_side_distance:
//
// Returns minimum distance any side to any mounting hole center.
//
function fan_get_min_screw_to_side_distance( spec ) = min( fan_get_min_screw_to_side_distances( spec ) );

// fan_demo:
//
// Display fan models
//
module fan_demo( _i = 0, _pos = 0 ) {
  if( _i < len(fan_specifications) ) {
    spec  = fan_get_spec( fan_specifications[_i][0] );
    vol   = fan_get_attribute( spec, "volume" );

    demo_spacing = 30;

    translate( [ vol.x/2, _pos, vol.y/2 ] )
      rotate( [ 90, 0, 0 ] ) {
        //color( "yellow", 0.1 ) translate( [ -vol.x/2, -vol.y/2, 0 ] ) cube( vol );
	fan_model( spec );
      }

    fan_demo( _i + 1, _pos + vol.z + demo_spacing );
  }
} // end fan_demo

// fan_specifications:
//
// Database of specifications.
//
fan_specifications = [
  // Standard - 80x80x25mm fan
  [ "80x80x25", [
    [ "name", "80x80x25" ],
    [ "side", 80.0 ],
    [ "width", 25.4 ],
    [ "area", [ 80.0, 80.0 ] ],
    [ "volume", [ 80.0, 80.0, 25.4 ] ],
    [ "screw_hole_diameter", 4.5 ],
    [ "screw_hole_side", 71.5 ],
    [ "frame_thickness", 4 ],
    [ "air_hole_side", 77.5 ],
    [ "air_hole_diameter", 87 ],
    [ "model", [
      [ "filename", "Delta-AFB0812HH.STL" ],
      [ "rotation", [ -90, 0, 0 ] ]
    ] ]
  ] ],
  // Non-Standard - 80x80x20mm fan
  [ "80x80x20", [
    [ "name", "80x80x20" ],
    [ "side", 80.0 ],
    [ "width", 20.0 ],
    [ "area", [ 80.0, 80.0 ] ],
    [ "volume", [ 80.0, 80.0, 20.0 ] ],
    [ "screw_hole_diameter", 4.5 ],
    [ "screw_hole_side", 71.5 ],
    [ "frame_thickness", 4 ],
    [ "air_hole_side", 77.5 ],
    [ "air_hole_diameter", 87 ],
    [ "model", [
      [ "filename", "Delta-AFB0812HHD-A.STL" ],
      [ "rotation", [ +90, 0, 0 ] ]
    ] ]
  ] ],
  // Non-Standard - 80x80x15mm fan
  [ "80x80x15", [
    [ "name", "80x80x15" ],
    [ "side", 80.0 ],
    [ "width", 15.0 ],
    [ "area", [ 80.0, 80.0 ] ],
    [ "volume", [ 80.0, 80.0, 15.0 ] ],
    [ "screw_hole_diameter", 4.5 ],
    [ "screw_hole_side", 71.5 ],
    [ "frame_thickness", 3 ],
    [ "air_hole_side", 77.5 ],
    [ "air_hole_diameter", 87 ],
    [ "model", [
      [ "filename", "Delta-AFB0812HB.STL" ],
      [ "rotation", [ +90, 0, 0 ] ]
    ] ]
  ] ],
  // Standard - 92x92x25mm fan
  [ "92x92x25", [
    [ "name", "92x92x25" ],
    [ "side", 92.0 ],
    [ "width", 25.4 ],
    [ "area", [ 92.0, 92.0 ] ],
    [ "volume", [ 92.0, 92.0, 25.4 ] ],
    [ "screw_hole_diameter", 4.5 ],
    [ "screw_hole_side", 82.5 ],
    [ "frame_thickness", 4 ],
    [ "air_hole_side", 89.5 ],
    [ "air_hole_diameter", 101 ],
    [ "model", [
      [ "filename", "Delta-AFB0912HH.STL" ],
      [ "rotation", [ +90, 0, 0 ] ],
      [ "translation", [ -92/2-4.7752, 0, +92/2+4.7752 ] ]
    ] ]
  ] ],
  // Standard - 120x120x25mm fan
  [ "120x120x25", [
    [ "name", "120x120x25" ],
    [ "side", 120.0 ],
    [ "width", 25.4 ],
    [ "area", [ 120.0, 120.0 ] ],
    [ "volume", [ 120.0, 120.0, 25.4 ] ],
    [ "screw_hole_diameter", 4.5 ],
    [ "screw_hole_side", 105.0 ],
    [ "frame_thickness", 5 ],
    [ "air_hole_side", 116.5 ],
    [ "air_hole_diameter", 124 ],
    [ "model", [
      [ "filename", "Delta-AFB1212HH.STL" ],
      [ "rotation", [ -90, 0, 0 ] ],
      [ "translation", [ -120/2-1, -25.4, +120/2+1 ] ]
    ] ]
  ] ]
];

//fan_demo();
