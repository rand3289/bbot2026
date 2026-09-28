// this is a stencil for drawing circles and
// making disk brakes out of 0.5mm sheet metal
use <bcstr.scad>
$fn=256;
layer = 0.3; // mm

module layers(){ // rings with slots
    d = 0.5;
    for(i=[1:1:5]){
        t(0,0,(i-1)*layer) difference(){
            pipe(layer, 100,  90); // layer
            pipe(1, 95+i*d, 95-i*d);
        }
    }
}

module brakeDiskStensil(){
    h = 5*layer;
    c(h,8);                 // center
    for(i=[0:360/6:360]){   // spokes
        r(0,0,i) b(99.9, h, h);
    }
    t(0,0,-2*layer) layers();
}

difference(){
    brakeDiskStensil();
    c(3,2.1); // center hole
}
