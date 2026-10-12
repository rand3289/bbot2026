// This is drawing tool for drawing circles
// for making disk brakes out of 0.5mm sheet metal
//
// 3D print the drawing tool
// insert thumb tacs/push pins into the tool ends
// punch a sheet of metal with a center punch
// center one pin over the center punch mark and draw a circle with the other
// cut the disk out with metal scissors
// drill a 10mm diameter hole in the center with a step drill
//
use <bcstr.scad>
$fn=256;
layer = 0.3; // mm

module disk_tool(){
    h=1.5;
    d = 95/2; // disk brakes are 95mm in diameter (matches an HD platelet size)
    difference(){
        c(h,8);
        c(2*h,2.1); // hole for a pin
    }
    t(d,0,0) difference(){
        c(h,8);
        c(2*h,2.1); // hole for a pin
    }
    t(d/2,0,0) b(d-4,h,h);
}

disk_tool();
