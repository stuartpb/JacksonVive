//!OpenSCAD
// title      : Vive headset hinge cover facsimle
// author     : Stuart P. Bentley (@stuartpb)

// # Configuration constants

// These values are redefined for different configurations
// (ie. rendering the right bracket).

// Whether the 
right = false;

// # Defined constants

// These values are arbitrary

$fn = 180;
// How wide to make the support tabs.
support_tab_width = 1;
// How much the support tabs should touch the edges.
support_interface_contact = 0.5;
// How much space should be between support tabs and the part (outside of contact).
support_interface_space = 0.2;

// # Measured constants

// These values are based on measurements of the hardware
// that they interface with or replace.

Vive_dish_depth = 4;
Vive_dish_outerRingThickness = 0.5;
Vive_dish_innerRingThickness = 1;
Vive_dish_innerRingDiameter = 22; // inner diameter
Vive_dish_outerRingDiameter = 29; // outer diameter
Vive_dish_innerGraspLength = 5;
Vive_dish_tabWidth = 6;
Vive_dish_tabOverhang = 2;
Vive_dish_tabHeight = 7;

// # Code

// # Derived values
Vive_dish_innerRingRadius = Vive_dish_innerRingDiameter / 2;
Vive_dish_outerRingRadius = Vive_dish_outerRingDiameter / 2;

module reflected () {
  mirror([0, right ? 1 : 0, 0]) children();
}

module Vive_dish() {
  union() {
    linear_extrude (Vive_dish_depth) {
      difference () {
        circle(d = Vive_dish_outerRingDiameter);
        circle(r = Vive_dish_outerRingRadius - Vive_dish_outerRingThickness);
      }
      difference () {
        circle(r = Vive_dish_innerRingRadius + Vive_dish_innerRingThickness);
        circle(d = Vive_dish_innerRingDiameter);
      }
      translate([
        -Vive_dish_innerRingThickness/2,
        -Vive_dish_innerRingRadius])
        square([Vive_dish_innerRingThickness, Vive_dish_innerGraspLength]);
      translate([
        -Vive_dish_innerRingThickness/2,
        Vive_dish_innerRingRadius - Vive_dish_innerGraspLength])
        square([Vive_dish_innerRingThickness, Vive_dish_innerGraspLength]);
    }
    intersection () {
      union () { 
        linear_extrude (Vive_dish_tabHeight) {
          difference () {
            circle(d = Vive_dish_innerRingDiameter);
            circle(r = Vive_dish_innerRingRadius - Vive_dish_innerRingThickness);
          }
        }
        translate([0, 0, Vive_dish_tabHeight - Vive_dish_innerRingThickness])
          linear_extrude (Vive_dish_innerRingThickness) {
            difference () {
              circle(d = Vive_dish_innerRingDiameter);
              circle(r = Vive_dish_innerRingRadius - Vive_dish_tabOverhang);
            }
          }
      }
      linear_extrude (Vive_dish_tabHeight)
        square(center = true, [Vive_dish_outerRingDiameter, Vive_dish_tabWidth]);
    }
  }
}

translate([0, 0, 2]) Vive_dish();
linear_extrude(2) union() {
  circle(d = Vive_dish_outerRingDiameter);
  translate([0, -Vive_dish_outerRingRadius])
    square(center = true,
      [Vive_dish_outerRingDiameter, Vive_dish_outerRingDiameter]);
}
