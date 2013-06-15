screwshape();

/* The basic shape for our part.
 - height is how tall it is
 - radius is the radius to the center of the thread
 - twist is the angle of the thread in degrees per milimeter
 - threads is the number of screw threads
 - thread_detail is the faces to hacve on a thread
 - thread_overlap is the ammount that one thread's profile
   overlap's the rest */
module screwshape(height         = 30,
                 radius         = 10,
                 twist          = 5,
                 threads        = 5,
                 thread_detail  = 9,
                 thread_overlap = 0.5) {
  pi = 3.141592654;
  thread_radius = radius * pi / threads * ( 1 + thread_overlap);

  linear_extrude(height = height, twist = 0 - twist * height, $fn = thread_detail * 4) {
    union() {
      //make the threads
      for(angle = [0 : 360 / threads : 360 - (360 / threads)]) {
        rotate([0,0,angle]) translate([radius,0,0]) circle(r = thread_radius, $fn = thread_detail);
      }

      //a hull will not work, so park a circle in the middle
      circle(r = radius);
    }
  }
}