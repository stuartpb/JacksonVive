//!OpenSCAD
// title      : JacksonVive Headphone Arm
// author     : Stuart P. Bentley (@stuartpb)
// version    : 0.1.0
// file       : JacksonVive-headphone-arm.scad

/* [Configuration] */

part = "left"; // [left:Left Arm,right:Right Arm,both:Both Arms]

/* [Parameters] */

// The angle of the arm from the headgear, in degrees.
arm_angle = 30;

clip_thickness = 2;

/* [Measurements] */
// The length of the slot
headstrap_width = 29;

headstrap_thickness = 2;

// The width of the headphone arm.
arm_width = 7.5;

arm_thickness = 3;

arm_length = 60;

endstop_length = 8;

// The width of the base of the endstop wedge.
endstop_jut = 1;

// The width of the gap behind the endstop wedge.
endstop_carveout = 1;

endstop_carveout_length = 5;

detente_width = 1.5;

detente_spacing = 2;

detente_depth = 0.5;

/* [Tweaks] */

$fn = 90;

/* [Hidden] */

clip_width = clip_thickness*2 + headstrap_thickness;
top_width = clip_width + arm_thickness;

module headphone_arm(flip) {
  mirror([flip, 0, 0]) difference() {
    union () {
      translate([-clip_width/2,-headstrap_width,0])
        cube([clip_width, headstrap_width + clip_thickness, arm_width]);
      translate([arm_thickness/2,clip_thickness,0]) cylinder(d=top_width, h=arm_width);
      translate([arm_thickness,0,arm_width/2]) rotate([90-arm_angle,90,0]) intersection () {
        scale([1, 2*arm_thickness/arm_width, 1]) cylinder(d=arm_width, h=arm_length);
        translate([-arm_width/2,0,0]) cube([arm_width, arm_thickness, arm_length]);
      }
    }
    // clip cutout
    translate([-headstrap_thickness/2,-headstrap_width, 0])
      cube([headstrap_thickness, headstrap_width, arm_width]);
  }
}

if (part == "both") {
  translate([ 30, 0]) headphone_arm(0);
  translate([-30, 0]) headphone_arm(1);
}
else if (part == "left") headphone_arm(0);
else if (part == "right") headphone_arm(1);