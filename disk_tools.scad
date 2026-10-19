// This is a drawing tool for drawing circles
// for making disk brakes out of 0.5mm sheet metal
//
// 3D print the drawing tool using 0.3mm layers
// insert thumb tacs/push pins into the raised tool center and end
// my thumb tacs have 1.1mm to 1.2mm shaft diameter
// punch a sheet of metal with a center punch
// center one pin over the center punch mark and draw a circle with the other
//
// move the end tack into the closer hole
// draw a 15mm circle for marking screw holes
// scratch 4 marks in the slots to mark screw hole positions
//
// cut the disk out with metal scissors
// drill a 10mm or a 3/8" diameter hole in the center
// center punch and drill 4 screw holes
//
use <bcstr.scad>
$fn = 256;
l = 0.3;  // layer
h = l*5;  // circle and bar height
p = l*5;  // pin hole size
w = l*12; // bar width
d = 95/2; // disk brakes are 95mm in diameter (matches an HD platelet size)
c = 10;   // fits into 10mm center hole in the disk (in case you drilled before marking)

module tachole(){
    difference(){
        c(h,c);
        c(2*h, p); // hole for a pin
    }
}

module arm(){
    t(9,0,0) difference(){
        b(16, w, h);
        t(4,0,0) b(4, p-0.3, h+1); // slots are thinner than pin holes
    }
}

module disk_tool(){
    tachole();            // center
    t(0,0,0.9) tachole(); // raised so it can be put inside a disk center hole
    t(15,0,0)  tachole(); // for marking mounting holes
    t(d,0,0)   tachole(); // for marking outer circumference
    color("red")   t(8,0,0)  b(8,w,h);  // connector
    color("green") t(32,0,0) b(26,w,h); // connector
    for(a=[45:90:315]){
        color("yellow") r(0,0,a) t(2,0,0) arm();
    }
}

disk_tool();


// this part of the tool squeezes the disk between two cones
// so it can be spun for cleaning up the edge with a file
hole=4;    // cener hole in cones
diff=8;    // cone diameter difference

module disk_holder(){
    difference(){
        cylinder(diff*2*l, 3+diff/2, 3);
        t(0,0,-1) c(25, hole);
    }
}

// break out the center print support after printing
module press(){
    t(0,0,1.49) disk_holder();
    pipe(3, 14, c);
    pipe(3, hole+2*l, hole); // print support
}

// after you squeeze the disk between press and disk_holder()
// use this to protect the bolt before putting it into the drill chuck
// print it horizontally
module bolt_protector(){
    difference(){
        c(25,8); // 1" long
        c(27,hole);
        t(10,0,0) b(20,20,30);
    }
}

t(0,-25,0) disk_holder();
t(0, 25, 1.5) press();
t(-35, 10,0) r(0,90,0) bolt_protector();
t(-35,-10,0) r(0,90,0) bolt_protector();
