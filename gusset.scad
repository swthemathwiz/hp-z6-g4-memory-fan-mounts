//
// Copyright (c) Stewart H. Whitman, 2024.
//
// File:    gusset.scad
// Project: General
// License: CC BY-NC-SA 4.0 (Attribution-NonCommercial-ShareAlike)
// Desc:    Gusset shapes to fill in |_ corners
//

include <smidge.scad>;

// Quadrant Setting:
//        y
//       2|1
//      --+-- x
//       3|4

module round_gusset_2d( w, quadrant=1 ) {
  assert( is_num(quadrant) && (quadrant == 1 || quadrant==2 || quadrant==3 || quadrant==4) );

  quadrant_to_mirror = [ [0,0], [1,0], [1,1], [0,1] ];

  mirror( quadrant_to_mirror[quadrant-1] )
    difference() {
      square( [ w, w ] );
      translate( [w-SMIDGE,w-SMIDGE] ) circle( r=w );
    }
} // end round_gusset_2d

module oblate_gusset_2d( w, h, quadrant=1 ) {
  scale( [1,h/w] ) round_gusset_2d( w, quadrant );
} // end oblate_gusset_2d

module round_gusset_3d( w, d, quadrant=1 ) {
  linear_extrude( height=d ) round_gusset_2d( w, quadrant );
} // end round_gusset_3d

module oblate_gusset_3d( w, h, d, quadrant=1 ) {
  linear_extrude( height=d ) oblate_gusset_2d( w, h, quadrant );
} // end oblate_gusset_3d

//round_gusset_2d( 10, quadrant=1 );
//oblate_gusset_2d( 10, 20, quadrant=2 );
//round_gusset_3d( 10, 1, quadrant=3 );
//oblate_gusset_3d( 10, 20, 1, quadrant=4 );
