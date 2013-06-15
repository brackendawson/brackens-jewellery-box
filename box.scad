//a medium box with 5 thick, rough threads.
height         = 40;  //total height of the box.
radius         = 10;  //sort of usable inner radius of the box.
twist          = 4;   //angle of the twise in degrees/mm.
threads        = 5;   //number of screw threads.
thread_detail  = 9;   //quality of the part.
thread_overlap = 0.5; //how deep to make the threads.
wall_thickness = 1; //mm
base_thickness = 3;   //in mm, can give you more of the base to hold onto
slack          = 0.5; //increase this if the fit is too tight

////a medium box with 3 smooth, proud threads.
//height         = 40;  //total height of the box.
//radius         = 8;  //sort of usable inner radius of the box.
//twist          = 4;   //angle of the twise in degrees/mm.
//threads        = 3;   //number of screw threads.
//thread_detail  = 25;   //quality of the part.
//thread_overlap = 0.3; //how deep to make the threads.
//wall_thickness = 1; //mm
//base_thickness = 3;   //in mm, can give you more of the base to hold onto
//slack          = 0.5; //increase this if the fit is too tight

////a medium box with lots of smooth, steep threads.
//height         = 30;  //total height of the box.
//radius         = 12;  //sort of usable inner radius of the box.
//twist          = 8;   //angle of the twise in degrees/mm.
//threads        = 20;   //number of screw threads.
//thread_detail  = 21;   //quality of the part.
//thread_overlap = 0.3; //how deep to make the threads.
//wall_thickness = 1; //mm
//base_thickness = 3;   //in mm, can give you more of the base to hold onto
//slack          = 0.5; //increase this if the fit is too tight

////a small box with a thick base.
//height         = 30;  //total height of the box.
//radius         = 5;  //sort of usable inner radius of the box.
//twist          = 6;   //angle of the twise in degrees/mm.
//threads        = 5;   //number of screw threads.
//thread_detail  = 20;   //quality of the part.
//thread_overlap = 0.5; //how deep to make the threads.
//wall_thickness = 1; //mm
//base_thickness = 15;   //in mm, can give you more of the base to hold onto
//slack          = 0.5; //increase this if the fit is too tight

// Don't change these, especially pi, don't change pi.
pi = 3.141592654;
thread_radius_max = radius * pi / threads * ( 1 + thread_overlap);

/* make the lid the right way up and flip it
 to keep the threads aligned */
translate([2 * radius + slack + wall_thickness + thread_radius_max,0,height - base_thickness]) {
  rotate([180,0,0]) {
    difference() {
      // lid outer wall
      screwshape(height         = height - base_thickness,
                 radius         = radius + slack + 2 * wall_thickness,
                 twist          = twist,
                 threads        = threads,
                 thread_detail  = thread_detail,
                 thread_overlap = thread_overlap);
      //cut out the cetner to make the inner walls
      screwshape(height         = height - base_thickness - wall_thickness,
                 radius         = radius + slack + wall_thickness,
                 twist          = twist,
                 threads        = threads,
                 thread_detail  = thread_detail,
                 thread_overlap = thread_overlap);
    }
  }
}

/* make the walls and hallow them, then add the base,
 again to keep all the threads aligned */
translate([0 - (2 * radius + slack + wall_thickness + thread_radius_max),0,0]) {
  difference() {
    //base outer wall
    screwshape(height         = height - wall_thickness - slack,
               radius         = radius + wall_thickness,
               twist          = twist,
               threads        = threads,
               thread_detail  = thread_detail,
               thread_overlap = thread_overlap);
    //base inner wall
    screwshape(height         = height - wall_thickness - slack,
               radius         = radius,
               twist          = twist,
               threads        = threads,
               thread_detail  = thread_detail,
               thread_overlap = thread_overlap);
  }
  //add the base
  screwshape(height         = base_thickness,
             radius         = radius + slack + 2 * wall_thickness,
             twist          = twist,
             threads        = threads,
             thread_detail  = thread_detail,
             thread_overlap = thread_overlap);
}

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