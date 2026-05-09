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
            t(0,25,0) b(16,50,8);
        }
        t(0,0,-0.51) c(7,22);
//        c(30,9);
    }
}

module centerBlock(){
    difference(){
        union(){
            c(16, 25);
            t(0,-25,0) b(16,50,16);
        }
        c(18, 22);
        t(0,-30, 5) b(8,30,8);
        t(0,-30,-5) b(8,30,8);
    }
}

module arm(){
    difference(){
        union(){
            t(0,-25,0) b(16,50,8);
            c(8,16);
        }
        c(12,12);
    }
}

module spindle(){
    difference(){
        union(){
            c(8, 25);
            t(0,0,4) cylinder(7,12.5,5);
        }
        b(shaft_square,shaft_square,30);
        t(0,0,-0.6) c(7.1,22);
    }
}

module bblock2(){
    difference(){
        union(){
            c(10,25);
            t(0,25,0) b(16,50,10);
        }
        c(7,7);
        t(0,0,-1.51) c(7,22);
        c(20,3); // screw hole
    }
}

module bblock3(){
    difference(){
        union(){
            c(24,25);
            t(0,25,0) b(16,50,8);
        }
        c(22,22); // bearing hole
        t(0,0,10) c(10,9);  // shaft hole
        t(12,0,0) b(10,20,30); // slice
    }
}


module bblock4(){
    difference(){
        union(){
            t(0,0,-4) c(16,10); 
            c(9,25);
            t(0,15,0) b(16,70,10);
        }
        c(7,22); // bearing hole
        t(0,0,2) c(10,9);  // shaft hole
        t(0,-15,0) r(0,90,0) c(50,3);
        t(0,15,0)  r(0,90,0) c(50,3);
    }
}

module bblock4_h1(){
    difference(){
        bblock4();
        t(15,0,0) b(30, 110,30);
    }
}

module bblock4_h2(){
    difference(){
        bblock4();
        t(-15,0,0) b(30, 110,30);
    }
}


module arm3(){
    color("green")
    difference(){
        union(){
            c(8,28);
            t(0,-25,0) b(16,50,8);
        }
        c(10,25);
    }
}

module gearSizer(){
    difference(){
        d=53.6;
        h=5;
        c(h,d);
        c(h+1,d-0.001);
    }
}

color("white") t(0,0,20) gearSizer();

// testing:
t(0,0,70) spindle();
t(0,0,-70) bblock2(); 
t(0,0,-110) bblock3(); 
t(0,0,-101.99) arm3();
t(-10,0,-150) bblock4_h1(); 
t(10,0,-150) bblock4_h2(); 


color("red") t(0,0,43.1)  arm();
color("red") t(0,0,-43.1) arm();

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
t(0,0,-35) r(180,0,180) bblock();
centerBlock();
