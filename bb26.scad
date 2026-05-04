use <bcstr.scad>
include <BOSL2/std.scad>
include <BOSL2/gears.scad>
$fn=128;          // make cylinders a bit rounder
skipdraw = false; // disable rendering the main view for debugging
shaft_round = 8;  // 608 bearings fit an 8mm round shaft
// if you grind the end of an 8mm round shaft into a square, it will be this size
shaft_square = sqrt(shaft_round*shaft_round/2);
echo("Shaft end square size", shaft_square);


module bblock(){
    difference(){
        union(){
            c(8,25);
            t(0,0,8) c(8,12);
        }
        t(0,0,-0.51) c(7,22);
        c(30,9);
    }
}

module center(){
    difference(){
        c(14,25);
        c(15,22);
    }
}

module bearing(){
    difference(){
        c(7,22);
        c(8,8);
    }
}


// differential gear with a square shaft hole
module dgear(){
    shaft_hole = shaft_square + 0.3; // + tolerance
    gteeth  = 12;
    difference(){
        union(){
            bevel_gear(teeth=gteeth, mate_teeth=gteeth, mod=4, cutter_radius=0, spiral=0, shaft_diam=1);
            t(0,0,6) c(10,16);
//            t(0,0,-2.2) c(0.9,27.3); // disk stop
        }
//        b(shaft_hole,shaft_hole,20);
        t(0,0,6) c(20,8);
    }
}


/*
bblock();
t(0,0,30) center();
t(0,0,60) r(180,0,0) bblock();
*/

/*
t(0,0,14.5)  bearing();
t(0,0,-14.5) bearing();
t(0,14.5,0) r(90,0,0) bearing();

t(0,0,34.5)  bearing();
t(0,0,-34.5) bearing();
t(0,34.5,0) r(90,0,0) bearing();
*/

t(0,0,3.6)  bearing();
t(0,0,-3.6) bearing();
//t(0,14.5,0) r(90,0,0) bearing();

t(0,0,34.5)  bearing();
t(0,0,-34.5) bearing();
t(0,32,0) r(90,0,0) bearing();

t(0,0,-24) dgear();
t(0,24,0) r(90,15,0) dgear();
t(0,0,24) r(180,0,0) dgear();

%t(0,0,29) c(1.5,95);  // brake disk 1
%t(0,0,-29) c(1.5,95); // brake disk 2

difference(){
    union(){
        t(0,-16,0) b(16,32,16);
        c(16, 25);
    }
    c(18, 22);
}
