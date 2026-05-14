// BrakerBot2026 toandrey(at)yahoo.com
// Brakes actuated by servo motors (not shown) transfer torque from disks to limbs
// Print everything with 0.3mm layers without support
// Uses 1/2" pvc pipe, 608 bearings, 95mm disks from Hard Drives, MG996R servos
// Every joint uses four or five bearings (not shown), 2 disks and 3 gears
//
// Outer diameter of the 608 bearing is 22mm.  ID 8mm
// Outer diameter of the 1/2" pvc pipe is 21.5mm
// TODO: put a screw in the shaft through the sleeve within the bearing block?
// TODO: build a version with bushings instead of bearings?

use <bcstr.scad> // b(),c(),s(),t(),r()
include <BOSL2/std.scad>
include <BOSL2/gears.scad>
$fn=128;          // make cylinders a bit rounder
skipdraw = false; // disable rendering the main view for debugging
shaft_round = 8;  // 608 bearings fit an 8mm round shaft
// if you grind the end of shaft_round into a square, it will be this size
shaft_square = sqrt(shaft_round*shaft_round/2);
echo("Shaft end square size", shaft_square);
WIDTH=92;
W=WIDTH/2;
W4=W-4;

module flatten(top=8){ // remove everything below top
    intersection(){
        children();
        t(0,0,100-top) b(200,200,200); // introduces a visual glitch
    }
}

// create holes on a side of a bearing block so it can be cut out for attaching a pipe
module cutout(){
    difference(){
        c(5,22);
        union(){
            c(6,16);
            r(0,0,45) b(4,30,6);
            r(0,0,-45) b(4,30,6);
            t(10,0,0) r(0,0,45) b(12,12,6);
        }
    }
}

module frame(){
    difference(){
        union(){
            difference(){ // c-frame
                t(0,28.5,0) b(WIDTH,57,16);
                b(76,98,17);
            }
            flatten() t(W,0,0)  r(0,90,0) c(32,25); // bearing block
            flatten() t(-W,0,0) r(0,90,0) c(32,25); // bearing block
            t(W4,30,0) r(0,0,20) b(8,45,8);        // ribs to make frame more rigid
            t(-W4,30,0) r(0,0,-20) b(8,45,8);
        }
        t(W,0,0)      r(0,90,0) c(29,22);  // pipe and bearing hole
        t(-W,0,0) r(0,90,0) c(29,22);  // bearing hole
                      r(0,90,0) c(100,11); // shaft hole
        t(0,50,0)     r(90,0,0) c(20,3);   // bracket screw hole center
        t(W4,45,0)    r(90,0,0) c(30,3);  // bracket screw hole side
        t(-W4,45,0) r(90,0,0) c(30,3);  // bracket screw hole side
                     t(W-4,0,13.3)c(4,3);  // vertical screw hole in bearing block
        r(-70,0,0)   t(W+3,0,-10) c(20,3); // screw hole in bearing block
        r(90,0,0)    t(W+10,0,-10)c(20,3); // screw hole in bearing block
        t(46,52,0)   r(0,90,0)    c(25,3); // screw holes for bolting
        t(-46,52,0)  r(0,90,0)    c(25,3); // two frames together
        t(W+16,0,0)  r(0,90,0)   cutout(); // on side of a bearing block
    }
}

module hingeBridge(){
    difference(){
        union(){
            b(WIDTH,8,16); // beam
            flatten()   t(0,9,0) r(90,0,0) c(30,25); // bearing block
            t(0,9,-4)  b(25,30,8); // makes bearing block bottom square
            t(0,0,10)   b(WIDTH,4,5);  // top bar for rigidity

            t(W4,4,0)   b(8,16,16); // wing 1
            t(W4,12,0)  r(45,0,0) b(8,11.3,11.3);

            t(-W4,4,0)  b(8,16,16); // wing 2
            t(-W4,12,0) r(45,0,0) b(8,11.3,11.3);
        }
        t(0,7.5,0)       r(90,0,0) c(30,22); // pipe and bearing hole
        r(90,0,0)        c(100,11);          // shaft hole
        t(0,12,13.3)     c(4,3);             // screw hole in bearing block. 13.3 for "print support"
        t(W-12,0,0)    b(8.1,8.1,8.1);     // cube hole for hinges
        t(-(W-12),0,0) b(8.1,8.1,8.1);     // cube hole for hinges
        r(0,90,0)     c(120,3);            // 2 screw holes
        t(40,13,0)    r(0,90,0) c(50,3.6); // screw hole in wing
        t(-40,13,0)   r(0,90,0) c(50,3.6); // screw hole in wing
    }
}

module hingeSide(){
    difference(){
        union(){
            r(0,90,0) c(8,34);    // pipe
            t(0,30,0) b(8,38,16); // side
            t(0,52,0) b(8,10,8);  // bridge connector
        }
        r(0,90,0) c(10,26);          // hinge hole
        t(0,53,0) r(0,90,0) c(10,3); // screw hole
        t(0,40,0) r(0,90,0) c(10,3); // screw hole
    }
}

module hingeAssembly(){ // for visualization only
    color("yellow") t(34,0,0)  r(180,180,0) hingeSide();
    color("yellow") t(-34,0,0) r(180,0,0)   hingeSide();
    color("green")  t(0,-53,0)              hingeBridge();
}

module legCap(){ // attaches pipe to lower joint
    flatten(21.5/2) // shave top off this cap level with pipe
    difference(){
        union(){
            b(32,8,16);
            b(WIDTH,8,8);
            t(0,6,0) r(90,0,0) c(20,25);
        }
        t(0,9,0)   r(90,0,0)   c(20,22); // pvc pipe hole
        t(0,5,0)               c(30,3);  // pipe screw hole
        r(0,120,0) t(0,10,10)  c(20,3);  // pipe screw hole
        r(0,60,0)  t(0,10,-10) c(20,3);  // pipe screw hole
                   r(90,0,0)   c(20,3);  // center screw hole
        t(W4,0,0)  r(90,0,0) c(20,3);    // side screw hole
        t(-W4,0,0) r(90,0,0) c(20,3);    // side screw hole
    }
}

// enforces the hip frame instead of a legCap()
module stiffBar(){
    difference(){
        b(WIDTH,8,8);
        t(W4,0,0)  r(90,0,0) c(20,3); // side screw hole
        t(-W4,0,0) r(90,0,0) c(20,3); // side screw hole
                   r(90,0,0) c(20,3); // center screw hole
    }
}
  
// differential gear
// 12 is best number for large teeth and lowering tooth undercut
module dgear(){
    gteeth = 12; 
    difference(){
        union(){
            bevel_gear(teeth=gteeth, mate_teeth=gteeth, mod=4, cutter_radius=0, spiral=0, shaft_diam=3);
            t(0,0,5) cylinder(6,10,5);
        }
        t(0,0,0.33) c(9,8.3); // round shaft hole
        t(0,0,8.8) b(shaft_square,shaft_square,8); // square on top
        for(i = [0:360/gteeth:360] ){
            r(0,0,i) t(15,0,0) c(20,2); // mounting holes
        }
    }
}

module gearDrillTemplate(){
    gteeth = 12;
    id=24.9;
    h=1.5; // height for HDD shaft
    difference(){
        union(){
            c(10,35); // main cylinder for mounting holes
            t(0,0,h/2) c(10+h,id); // shaft for an HDD platter
        }
        c(20,8); // center hole (5/16"=7.825mm)
        for(i = [0:360/gteeth:360] ){
            r(0,0,i) t(15,0,0) c(20,2); // mounting holes
        }
    }    
}

// Foot that fits into a 1/2" PVC pipe
module foot(){ // implicit union
    intersection(){ // bottom of the foot (mushroom cap)
        t(0,0,12) c(10,21.5);
        t(0,0,-4) sphere(18);
    }
    difference(){
        c(15,15.5);        // stem
        r(90,0,0) c(20,3); // screwhole
    }
    difference(){   // print support
        union(){
            t(0,0,0.1)  c(15,21.5); // brake it off after printing
            t(0,0,-0.5) c(14,22.3);
        }
        c(16,20.9); // 0.3mm wall
    }
}

module axle1(len=47){
    b(shaft_square,shaft_square,len); // top 5mm of gear hole is square
    t(0,0,-3) c(len-6,shaft_round);   // bearings mount here
}

module axle2(len){
    b(shaft_square,shaft_square,len); // 2 gear mounts
    c(len-12,shaft_round);            // bearings mount here
}

// spacer between two bearings around axle1() to lock bearings in place
module sleve(len=14.1){
    pipe(len, 8.4+1.8, 8.4); // len, od, id // 0.9mm wall
}


if(!skipdraw){ // set skipdraw=true for quick debugging of individual parts
if($preview){
    color("red")  t(0,-97,0)    r(90,0,0) axle2(170.1);
    color("red")  t(-36.9,-195,0) r(0,90,0) axle1(); // 2 per joint
    color("teal") t(-50,-195,0) r(0,90,0) sleve();   // spacer between bearings

    t(270,0,0) r(-90,90,0) frame(); // the other leg
    t(150,0,0) r(90,90,0) frame();
    t(150,0,0) r(90,90,0) hingeAssembly();
    frame();
    hingeAssembly();
    t(0,-195,0) r(0,0,180) frame();
    t(0,-195,0) r(0,0,180) hingeAssembly();

    t(0,-260,0)   r(180,180,0) legCap();
    t(0,70,0)     stiffBar();

    t(24,-195,0)  r(0,-90,0)     dgear();
    t(0,-171,0)   r(90,360/24,0) dgear(); // N teeth. rotate 1/2 tooth
    t(-24,-195,0) r(0,90,0)      dgear();

%   t(0,-360,0)   r(90,0,0) c(200,21.5); // pvc pipe
%   t(0,-98,0)    r(90,0,0) c(120,21.5); // pvc pipe
%   t(80,0,0)     r(0,90,0) c(50,21.5);  // pvc pipe
%   t(28.3,-195,0)  r(0,90,0) c(1.5,95); // brake disk
%   t(-28.3,-195,0) r(0,90,0) c(1.5,95); // brake disk

    t(0,-480,0) r(90,0,0) foot();
} else { // rendering for 3D printing
    t(275,60,0) gearDrillTemplate();
    t(205,0,0) foot();
    t(290,-30,0) r(90,0,90)  stiffBar();
    t(260,-30,0) r(90,0,-90) legCap();
    t(310,0,0) r(90,0,0) axle2(170);  // len depends on PVC pipe length
    t(230,40,0)  r(90,45,180) axle1(); // fixed length for each joint
    t(230,-40,0) r(90,45,0)   axle1(); // need 2 per joint
    t(200,40,0)  sleve();              // need 2 per joint
    t(200,-40,0) sleve();


    frame();
    t(-90,-30,0) r(0,-90,0) hingeSide();
    t(90,-30,0)  r(0,-90,0) hingeSide(); // need two per joint
    t(0,-50,0)  hingeBridge();
    t(80,70,0)  dgear();
    t(0,90,0)   dgear();
    t(-80,70,0) dgear();

} // if($preview)
} // skipdraw
