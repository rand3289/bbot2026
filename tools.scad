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

t(-50,-35,0) disk_holder();
t(-50, 35, 1.5) press();
t(-50, 10,0) r(0,90,0) bolt_protector();
t(-50,-10,0) r(0,90,0) bolt_protector();


// up-down pole slider for testing a leg
module slider(){
tolerance = 0.4;
d1=25.5+tolerance; // pole slider ID
d2=d1+4;           // pole slider OD
d3=21.5+tolerance; // PVC holder ID
d4=d3+4;           // PVC holder OD
l = d2/2+d4/2;     // magic
    difference(){
        union(){
            t(0,0,25-d4/2) c(50,d2);
            t(l,0,0)       r(90,0,0) c(d2,d4);
            t(l/2,0,0)     b(l,d2,d4);
            intersection(){ // fin
                t(20,0,22) b(30,2,25);
                r(90,0,0)  c(2,73);
            }
        }
        c(80,d1);                           // pole hole
        t(l,0,0)      r(90,0,0) c(d2+1,d3); // pvc hole
        t(l,0,-10)    c(10,3);              // screw hole
        t(l+d3/2,0,0) r(0,90,0) c(10,3);    // screw hole
    }
}

// this part is specific to the gear motor I am using
// it connects the motor shaft to a square shaft
module motorCoupler(){
    shaft_round = 8; // 608 bearings fit an 8mm round shaft
    // if you grind an end of a round shaft into a square, it will be this size
    sq = 0.3+sqrt(shaft_round*shaft_round/2);
    
    difference(){
        c(22, 12);
        t(0,0,8) b(sq,sq,8); // 8mm shaft
        intersection(){      // 6mm motor shaft
            d=6.3;
            c(24,d);
            t(0.5,0,0) b(d,d,24);
            // shaft's flat side is 0.5mm in
        }        
    }    
}

// this part is specific to the gear motor I am using
// it connects a motor to a 1/2" PVC pipe
module motorMount(){
    difference(){
        union(){
            c(2,37);                        // flange
            cylinder(h=28,r1=9,r2=12.5);    // lower
            t(0,0,42) c(28,25);             // upper (bearing+pipe)
            r(0,0,30)  t(10,0,2) b(11,2,5); // 6 ribs
            r(0,0,90)  t(10,0,2) b(11,2,5);
            r(0,0,150) t(10,0,2) b(11,2,5);
            r(0,0,210) t(10,0,2) b(11,2,5);
            r(0,0,270) t(10,0,2) b(11,2,5);
            r(0,0,330) t(10,0,2) b(11,2,5);
        }
        t(0,0,-1.1) cylinder(h=30,r1=7,r2=10); // lower hole
        t(0,0,42) c(28.1,22.2);          // upper hole
        t(0,0,44) r(90,0,0) c(40,3);     // holes for attaching the pvc pipe
        t(0,0,48) r(0,90,0) c(40,3);     // holes for attaching the pvc pipe
        r(0,0,0)   t(15.6,0,0) c(5,3.6); // 6 motor flange holes
        r(0,0,60)  t(15.6,0,0) c(5,3.6);
        r(0,0,120) t(15.6,0,0) c(5,3.6);
        r(0,0,180) t(15.6,0,0) c(5,3.6);
        r(0,0,240) t(15.6,0,0) c(5,3.6);
        r(0,0,300) t(15.6,0,0) c(5,3.6);
    }
}

t(0,140,0) slider();
t(0,100,0) motorCoupler();
t(0,60,0)  motorMount();
