// FanHolder - a OpenSCAD 
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


$fn= 100;
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


module fan_holder(innerd=17, innerh=6, degrees=0, bottom=0)
{
	module cable_holder(radius = 6, rot=0) {
		width = 5;
        translate([-width/2, -radius, 0]) cube ([width,radius,2]);
		translate([-width/2, 0, radius]) {
			rotate([0,90,0]) { 
				for (i = [-1, 1]) 
					rotate([0,0,i*90-rot])  
						arc( 2, width, radius, i*155) ;
			}
		}
	}
	module holder() {
		difference() 
		{
			rotate([0,0,degrees]) union() {
				for (i = [-1,1]) 
					rotate([0,0,i*90])  {
						arc( 10, 2.5, 14, i*135) ;
						arc( 10, innerh, 11, i*135) ;
					}
			}
			translate([0, 0, -0.02]) cylinder(d=innerd, h=20, center=false);
		}
	}
	module fan40()
	{
		difference() 
		{
		cube([42,40,5], center=true);
		cylinder(d=37, h=50, center=true);
		for (i = [-1,1]) { 
			translate([16, i*16, 0]) { 
				cylinder(d=3, h=50, center=true);
			}
			
		}
		translate([-12, 0, 0]) cube([46,46,10], center=true);
		}
	}
	if (bottom) translate([12, 23, 21]) rotate([0,90,0])  fan40();
	else translate([12, -23, 21]) rotate([0,90,0])  fan40();
	translate([0, 0, 0]) holder();
}


// Upper fan holder with 34 mm hole diameter
translate([-20, 0, 0]) fan_holder(innerd=17.2, innerh=9, degrees=1);

// bottom fan holder with 36 mm hole diameter
translate([20, 0, 0]) fan_holder(innerd=18, degrees=10, bottom=1);
 