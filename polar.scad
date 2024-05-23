//
// Copyright (c) Stewart H. Whitman, 2024.
//
// File:    polar.scad
// Project: General
// License: CC BY-NC-SA 4.0 (Attribution-NonCommercial-ShareAlike)
// Desc:    Polar <-> Cartesian utilities
//

// polar_to_cartesian:
//
// Convert polar coordinates (<theta>, <radius>) to cartesian [ <x>, <y> ]
//
function polar_to_cartesian( theta, radius ) = assert( is_num(theta) && is_num(radius) )
  [ cos(theta) * radius, sin(theta) * radius ];
