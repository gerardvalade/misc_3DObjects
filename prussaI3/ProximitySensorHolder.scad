// ProximitySensorHolder - a OpenSCAD 
// Copyright (C) 2015  Gerard Valade

// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.

// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.

// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.


$fn= 60;
module hexaprismx(

	ri =  1.0,  // radius of inscribed circle
	h  =  1.0)  // height of hexaprism
{ // -----------------------------------------------

	ra = ri*2/sqrt(3);
	cylinder(r = ra, h=h, $fn=6, center=false);
}

module arc( height, depth, radius, degrees ) {
    // This dies a horible death if it's not rendered here 
    // -- sucks up all memory and spins out of control 
    render() {
        difference() {
            // Outer ring
            rotate_extrude($fn = 100)
                translate([radius - height, 0, 0])
                    square([height,depth]);
         
            // Cut half off
            translate([0,-(radius+1),-.5]) 
                cube ([radius+1,(radius+1)*2,depth+1]);
         
            // Cover the other half as necessary
            rotate([0,0,180-degrees])
            translate([0,-(radius+1),-.5]) 
                cube ([radius+1,(radius+1)*2,depth+1]);
         
        }
    }
}

module cable_holder()
{
	module holder() {
		#difference() 
		{
//			translate([0, 0, 0]) cylinder(d=35, h=10, center=false);
//			translate([0, 0, 6.02]) rotate([0,0,90])  hexaprismx(ri=12,h=4);
//			translate([0, 0, -0.02]) cylinder(d=18.2, h=20, center=false);
		}
	}
	translate([-2.5, 0, 0]) holder();
	translate([0, 0, 0]) {  
		translate([0,-50,0]) cube([4.5,50,10], center=false);
		translate([0,-45.5,0]) { rotate([0,0,-90]) difference() {
			cube([4.5,45,10], center=false);
			translate([-5, 38, 5]) rotate([0,90,0]) {
				cylinder(d=3.5, h=20, center=true);
					hull () {
						translate([0,2]) 
						cylinder(d=3.5, h=20,  center=true);
						translate([0,-2]) 
						cylinder(d=3.5, h=20,  center=true);
					}
				}
			}
			
			
			}
		translate([1, 10, 10]) difference() 
		{
			cube([8, 20, 20], center=true);
			translate([-3.02, 0, 0]) cube([5,10.4,26], center=true);
			for (i = [-1,1]) translate([-10, 0, i*5.5]) rotate([0,90,0]) cylinder(d=3.5, h=20, center=false);
		}
	}
}



module proximity_holder()
{
	module holder() {
		difference() 
		{
			translate([0, 0, 0]) cylinder(d=35, h=10, center=false);
			translate([0, 0, 6.02]) rotate([0,0,90])  hexaprismx(ri=12,h=4);
			translate([0, 0, -0.02]) cylinder(d=18.2, h=20, center=false);
		}
	}
	translate([-2.5, 0, 0]) holder();
	translate([-16, -20, 10]) {  
		translate([-1.7, 15, -5]) cube([4.6,10,10], center=true);
		translate([0, 0, 0]) difference() 
		{
			cube([8, 20, 20], center=true);
			translate([-3.02, 0, 0]) cube([5,10.4,26], center=true);
			for (i = [-1,1]) translate([-10, 0, i*5.5]) rotate([0,90,0]) cylinder(d=3.5, h=20, center=false);
		}
	}
}




module nema17Flange()
{
	assign(h=10, l1=12, l=42.2, ep=4.4, ep2=5, holed=4.5)
	{
		render() difference() 
		{
			translate([0, 0, 0])  linear_extrude(height=h, center=false, convexity=0, twist=0)
				polygon([[0,0], [l1,0], [l1, l], [l1+l, l], [l1+l, 0], [l1+l+l1, 0], [l1+l+l1, ep2],
					[l1+l+ep, ep2], [l1+l+ep, ep+l], [l1-ep, ep+l], [l1-ep, ep2],  [0, ep2]]
					);
			translate([holed, ep/2, h/2]) rotate([90,0,0]) {
				cylinder(d=3.5, h=8, center=true);
				translate([0, 0, -ep2+2]) rotate([0,0,90])  hexaprismx(ri=2.8,h=2.54);
			}		
			translate([l1+l+l1-holed, ep/2, h/2]) rotate([90,0,0]) {
				cylinder(d=3.5, h=8, center=true);
				translate([0, 0, -ep2+2]) rotate([0,0,90])  hexaprismx(ri=2.8,h=2.54);
			}		
		}
		translate([0, -10, 0])  rotate([90,0,0]) difference() 
		{
			cube([l1+l+l1, ep2, h], center=false);
			translate([holed, ep/2, h/2]) rotate([90,0,0]) cylinder(d=3.5, h=8, center=true);		
			translate([l1+l+l1-holed, ep/2, h/2]) rotate([90,0,0]) cylinder(d=3.5, h=8, center=true);		
		}
	}
}

nema17Flange();
translate([-30, 30, 0]) proximity_holder();
translate([90, 30, 0]) cable_holder();
