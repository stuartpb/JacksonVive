//!OpenSCAD
// title      : JacksonVive Bracket
// author     : Stuart P. Bentley (@stuartpb)
// version    : 0.1.0
// file       : JacksonVive-bracket.scad

/* [Configuration] */

// Note that this will only have an effect if you specify an arm angle:
// otherwise, the brackets are identical.
part = "left"; // [left:Left Bracket,right:Right Bracket,both:Both Brackets]

// How to interface with the headset.
// "hinge" uses an assembly that emulates the interface to the Vive headstrap
// built into the headset: it requires printing small, load-bearing parts,
// and is only really suitable with a strong material like PETG.
// "clasp" uses a rough channel with overhangs to grasp the buckle of the
// hinge piece that normally secures the strap. It's compatible with a wider
// variety of plastics and prints without supports, but attaches less robustly.
interface = "hinge";

// Whether to include supports for hinge tabs.
support = true;

// How thick to make support pieces.
support_thickness = 0.5;

// How far to separate support material from contact.
support_interface_distance = 0.2;

/* [Parameters] */

// The length of the bracket, from the center of the headgear hinge
// to the center of the headgear hinge.
bracket_length = 90;

// How much length to remove if using buckle interface.
clasp_start = 30;

// The width of the bracket, from edge to edge.
bracket_width = 30;

// The thickness of the bracket.
bracket_depth = 5;

// How deep to embed the hinge assembly into the bracket.
hinge_inset_depth = 3;

// How much space to inset around the hinge.
hinge_inset_diameter = 36;

// How much radius to taper to the hinge inset over.
hinge_inset_taper = 50;

/* [Measurements] */

// The diameter of the channel for the headset buckle (measured as 2mm + .5 tolerance)
buckle_gauge = 2.5;

// The angle of the pivot stop peg to the headset
pivot_stop_peg_angle = 0;

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

// The depth of the headset hinge interface rings.
headset_hinge_ring_depth = 4;

// The thickness of the outer headset hinge interface ring.
headset_hinge_outer_ring_thickness = 0.5;

// The thickness of the inner headset hinge interface ring.
headset_hinge_inner_ring_thickness = 0.8;

// The inner diameter of the inner headset hinge interface ring.
headset_hinge_inner_ring_diameter = 22;

// The outer diameter of the outer headset hinge interface ring.
headset_hinge_outer_ring_diameter = 29;

// The length of the stop tabs in the headset hinge interface.
headset_hinge_stop_length = 5;

// The width of the holding tabs in the headset hinge interface.
headset_hinge_tab_width = 6;

// The top radius of the holding tabs in the headset hinge interface.
headset_hinge_tab_overhang = 2;

// The top height of the holding tabs in the headset hinge interface.
headset_hinge_tab_height = 7;

/* [Tweaks] */

$fn = 90;

/* [Hidden] */

module hinge_interface() {
  headset_hinge_outer_ring_radius =  headset_hinge_outer_ring_diameter/2;
  headset_hinge_inner_ring_radius =  headset_hinge_inner_ring_diameter/2;
  union() {
    linear_extrude (headset_hinge_ring_depth) {
      difference () {
        circle(d = headset_hinge_outer_ring_diameter);
        circle(r = headset_hinge_outer_ring_radius -
          headset_hinge_outer_ring_thickness);
      }
      difference () {
        circle(r = headset_hinge_inner_ring_radius +
          headset_hinge_inner_ring_thickness);
        circle(d = headset_hinge_inner_ring_diameter);
      }
      translate([
        -headset_hinge_inner_ring_thickness/2,
        -headset_hinge_inner_ring_radius])
        square([headset_hinge_inner_ring_thickness, headset_hinge_stop_length]);
      translate([
        -headset_hinge_inner_ring_thickness/2,
        headset_hinge_inner_ring_radius - headset_hinge_stop_length])
        square([headset_hinge_inner_ring_thickness, headset_hinge_stop_length]);
    }
    intersection () {
      union () {
        linear_extrude (headset_hinge_tab_height) {
          difference () {
            circle(d = headset_hinge_inner_ring_diameter);
            circle(r = headset_hinge_inner_ring_radius -
              headset_hinge_inner_ring_thickness);
          }
        }
        translate([0, 0, headset_hinge_tab_height -
          headset_hinge_inner_ring_thickness])
          linear_extrude (headset_hinge_inner_ring_thickness) {
            difference () {
              circle(d = headset_hinge_inner_ring_diameter);
              circle(r = headset_hinge_inner_ring_radius - headset_hinge_tab_overhang);
            }
          }
      }
      linear_extrude (headset_hinge_tab_height)
        square(center = true,
          [headset_hinge_outer_ring_diameter, headset_hinge_tab_width]);
    }
    if (support) intersection () {
      linear_extrude (headset_hinge_tab_height) square(center = true,
          [headset_hinge_outer_ring_diameter,
            headset_hinge_tab_width]);
      translate([0, 0, support_interface_distance])
        linear_extrude(
          headset_hinge_tab_height -
          headset_hinge_inner_ring_thickness -
          2*support_interface_distance) difference () {
            circle(r = headset_hinge_inner_ring_radius -
              headset_hinge_inner_ring_thickness -
              (headset_hinge_tab_overhang -
                headset_hinge_inner_ring_thickness -
                support_thickness));
        circle(r=headset_hinge_inner_ring_radius - headset_hinge_tab_overhang);
      }
    }
  }
}

module clasp_interface() {
  difference() {
    union () {
      translate([-bracket_width/2, -bracket_depth/2, 0])
        cube([bracket_width, bracket_depth/2, bracket_depth]);
      translate([-bracket_width/2,-bracket_depth/2,bracket_depth/2]) rotate([0,90,0])
        cylinder(d=bracket_depth, h=bracket_width);
    }
    translate([-bracket_width/2, -buckle_gauge, buckle_gauge])
      cube([bracket_width, buckle_gauge, buckle_gauge]);
    translate([-bracket_width/4, -buckle_gauge*2, buckle_gauge])
      cube([bracket_width/2, buckle_gauge, buckle_gauge]);
    translate([-bracket_width/2,-bracket_depth/2,bracket_depth/2]) rotate([0,90,0])
      cylinder(d=buckle_gauge, h=bracket_width);
  }
}

module bracket(right) {
  inside_up = interface == "hinge" ;
  // since the hinge version prints inside-up, the flips are reversed
  flip = inside_up ? !right : right;

  bracket_length = bracket_length - (interface == "clasp" ? clasp_start : 0 );
  mirror([flip, 0, 0]) {
    difference() {
      linear_extrude(bracket_depth) union () {
        square(center = true, [bracket_width, bracket_length]);

        // The headgear end
        translate([0, bracket_length/2]) {
          circle(d=bracket_width);
          rotate(pivot_stop_peg_angle)
            difference() {
              // the arm beam
              union() {
                translate([-pivot_stop_arm_width/2, 0])
                  square([pivot_stop_arm_width, pivot_stop_peg_distance]);

                translate([0, pivot_stop_peg_distance])
                  circle(d=pivot_stop_arm_width);
              }

              // subtract the small hole
              translate([0, pivot_stop_peg_distance, 0])
                circle(d=pivot_stop_peg_diameter);
            }
        }
        if (interface == "hinge") {
          translate([0, -bracket_length/2])
            circle(d=bracket_width);
        }
      }
      translate([0, bracket_length/2]) union() {
        linear_extrude(bracket_depth)
          circle(d=pivot_stop_hinge_diameter);

        translate([0, 0, inside_up ? 0 : knob_inset_thickness])
          linear_extrude(bracket_depth - knob_inset_thickness)
            difference() {
              circle(d=knob_hinge_diameter);
              if (inside_up && support)  {
                difference () {
                  circle(d = pivot_stop_hinge_diameter + 2*support_thickness);
                  circle(d = pivot_stop_hinge_diameter);
                }
              }
            }

        if (inside_up && support) {
          translate([0, 0, bracket_depth -
            knob_inset_thickness - support_interface_distance])
            linear_extrude(support_interface_distance)
              circle(d=knob_hinge_diameter);
        }
      }
      if (interface == "hinge") {
        translate([0, -bracket_length/2, bracket_depth - hinge_inset_depth])
          cylinder(h = hinge_inset_depth,
            d1 = hinge_inset_diameter,
            d2 = hinge_inset_diameter + 2 * hinge_inset_taper);
      }
    }

    // The headset end
    translate([0, -bracket_length/2]) {
      if (interface == "clasp")
        clasp_interface();
      else translate([0,0,bracket_depth - hinge_inset_depth])
        hinge_interface();
    }
  }
}

if (part == "both") {
  translate([ bracket_width/1.5, 0]) bracket(0);
  translate([-bracket_width/1.5, 0]) bracket(1);
}
else if (part == "left") bracket(0);
else if (part == "right") bracket(1);
