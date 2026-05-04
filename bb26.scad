use <bcstr.scad>
include <BOSL2/std.scad>
include <BOSL2/gears.scad>
$fn=128;          // make cylinders a bit rounder
skipdraw = false; // disable rendering the main view for debugging
shaft_round = 8;  // 608 bearings fit an 8mm round shaft
// if you grind the end of an 8mm round shaft into a square, it will be this size
shaft_square = sqrt(shaft_round*shaft_round/2) + 0.3; // + tolerance
echo("Shaft end square size", shaft_square);


module brakeDisk(){
    % difference(){
        c(1.5,95);
        c(2, 10);
    }
}

module bearing(){
    color("yellow") difference(){
        c(7,22);
        c(8,8);
    }
}

// differential gear
// 12 is best number for large teeth and lowering tooth undercut
module dgear(){
    gteeth = 12; 
    difference(){
        union(){
            bevel_gear(teeth=gteeth, mate_teeth=gteeth, mod=4, cutter_radius=0, spiral=0, shaft_diam=8);
            t(0,0,5) cylinder(6,10,5);
        }
        t(0,0,6) c(20,8); // shaft hole
        for(i = [0:360/gteeth:360] ){
            r(0,0,i) t(15,0,0) c(20,2); // mounting holes
        }
    }
}

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

module centerBlock(){
    difference(){
        union(){
            t(0,-16,0) b(16,32,16);
            c(16, 25);
        }
        c(18, 22);
    }
}


t(0,0,3.6)   bearing();
t(0,0,-3.6)  bearing();
t(0,0,34.5)  bearing();
t(0,0,-34.5) bearing();
t(0,32,0) r(90,0,0) bearing();

t(0,0,-24) dgear();
t(0,24,0) r(90,15,0) dgear();
t(0,0,24) r(180,0,0) dgear();

t(0,0, 29) brakeDisk();
t(0,0,-29) brakeDisk();

t(0,0,35 ) bblock();
t(0,0,-35) r(180,0,0) bblock();
centerBlock();