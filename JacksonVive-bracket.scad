//!OpenSCAD
// title      : JacksonVive Bracket
// author     : Stuart P. Bentley (@stuartpb)
// version    : 0.1.0
// file       : JacksonVive-bracket.scad

/* [Configuration] */

part = "both"; // [left:Left Bracket,right:Right Bracket,both:Both Brackets]

/* [Parameters] */

// The length of the bracket, from the center of the hinge
// to the notch for the headset buckle.
bracket_length = 60;

// The width of the bracket, from edge to edge.
bracket_width = 30;

// The thickness of the bracket.
bracket_depth = 5;

/* [Measurements] */

// The diameter of the channel for the headset buckle (measured as 2mm + .5 tolerance)
buckle_gauge = 2.5;

// The angle of the pivot stop peg to the headset
pivot_stop_peg_angle = 25;

// the width of the arm that attaches to the pivot stop peg
pivot_stop_arm_width = 10;

// the distance between the center of the hinge and the hole in the arm
pivot_stop_peg_distance = 22;

// The diameter of the hole for the pivot stop peg
pivot_stop_peg_diameter = 4;

// The diameter of the larger hole for the hinge
knob_hinge_diameter=19;

// The diameter of the smaller inner hole for the hinge
pivot_stop_hinge_diameter=15;

// The height of the wall that surrounds the smaller inner hole
knob_inset_thickness=1;

/* [Tweaks] */

$fn = 90;

/* [Hidden] */

module bracket(flip) {
  mirror([flip, 0, 0]) {
    difference() {
      linear_extrude(height = bracket_depth) union () {
        square(size=[bracket_width, bracket_length], center=true);

        // The hinge end
        translate([0, bracket_length/2]) {
          circle(d=bracket_width, center=true);
          rotate(pivot_stop_peg_angle)
            difference() {
              // the arm beam
              union() {
                translate([-pivot_stop_arm_width/2, 0])
                  square([pivot_stop_arm_width, pivot_stop_peg_distance]);

                translate([0, pivot_stop_peg_distance])
                  circle(d=pivot_stop_arm_width, center=true);
              }

              // subtract the small hole
              translate([0, pivot_stop_peg_distance, 0])
                circle(d=pivot_stop_peg_diameter, center=true);
            }
        }
      }
      translate([0, bracket_length/2]) union() {
        linear_extrude(height = bracket_depth)
          circle(d=pivot_stop_hinge_diameter, center=true);

        translate([0, 0, knob_inset_thickness])
          linear_extrude(height = bracket_depth - knob_inset_thickness)
            circle(d=knob_hinge_diameter, center=true);
      }
    }

    // The buckle clasp
    translate([0, -bracket_length/2]) {
      difference() {
        union () {
          translate([-bracket_width/2, -bracket_depth/2, 0])
            cube([bracket_width, bracket_depth/2, bracket_depth]);
          translate([-bracket_width/2,-bracket_depth/2,bracket_depth/2]) rotate([0,90,0])
            cylinder(d=bracket_depth, h=bracket_width);
        }
        translate([-bracket_width/2, -buckle_gauge, buckle_gauge])
          cube([bracket_width, buckle_gauge, buckle_gauge]);
        translate([-bracket_width/2,-bracket_depth/2,bracket_depth/2]) rotate([0,90,0])
          cylinder(d=buckle_gauge, h=bracket_width);
      }
    }
  }
}

if (part == "both") {
  translate([ bracket_width/1.5, 0]) bracket(0);
  translate([-bracket_width/1.5, 0]) bracket(1);
}
else if (part == "left") bracket(0);
else if (part == "right") bracket(1);
