/* [Basics] */
//how many boards do you want to connect? (everything above 4 is very experimental!)
connectors_amount = 3;
//connectors_angle..very experimental feature
connectors_angle = 90;
//enter the thickness of your boards
board_thickness = 9;
//how long should the cutout for the board be?
notch_lenght = 35;
//depth of the cutout
notch_depth = 30;
//thickness of the walls
shell_thickness = 2;
/* [Bottom Part] */
//false, if no foot is required
its_a_bottom_part = "false"; //[true, false]
//false, if the 1-connector-bottom-parts slot should face to the side
straight_1_connector_bottom = "false"; //[true, false]
//how thick should the foot be?
ground_offset = 16;
//what width should the foot have?
ground_surface = notch_lenght * 0.75;
/* [Holes] */
//true, if there should be holes in the middle of the slotpartkindofthing
insert_hole_for_board = "true"; //[true, false]
//diameter of the hole
board_hole_size = 3;
//true, if there is shold be a hole for screws for some diagonal braces
insert_hole_for_brace = "true"; //[true, false]
//size of said holes
brace_hole_size = 3;
//depth of said holes
brace_hole_depth = 20; 
/* [Edge] */

module centerpiece(){
        if((connectors_amount < 5) && (connectors_angle == 90)){
                cube([board_thickness + shell_thickness * 2, board_thickness + (shell_thickness*2), notch_depth], center = true);}    
        else{
            cylinder(h = notch_depth, r = board_thickness + shell_thickness/2, center = true);
        }
}

module brace_hole(){
    if (insert_hole_for_brace == "true"){
        difference(){
            centerpiece();
            translate([0, 0, - notch_depth / 2 - 1]) cylinder (h = brace_hole_depth + 1, r = brace_hole_size / 2, center = false, $fn=brace_hole_size + 2);
        }
    } else{
        centerpiece();
    }
}

module ground_piece(){
    if (its_a_bottom_part == "true" && connectors_amount < 4){
        translate([0, (ground_offset + board_thickness)/2 + shell_thickness, 0])
        cube([ground_surface, ground_offset, notch_depth], center = true);
    }
}
                    
module notch(){
    difference(){
        //centerpiece();
        translate([0, (notch_lenght + board_thickness) / 2 + shell_thickness * 1.5, 0])
            cube([board_thickness + shell_thickness * 2, notch_lenght + shell_thickness, notch_depth], center = true);
        translate([0, notch_lenght / 2 + board_thickness, shell_thickness / 2 + 1])
            cube([board_thickness, notch_lenght * 2, notch_depth + 2 - shell_thickness], center = true);
    }
}

module board_hole(){
    if (insert_hole_for_board == "true"){
        difference(){
            notch();
    translate([0, notch_lenght / 2 + board_thickness, shell_thickness / 2 + 1]) rotate([0,90,0]) #cylinder(h=board_thickness + 2*shell_thickness+0.1,r=board_hole_size/2, center=true);}
}
else{
    notch();}
}

module rounded_corner(){
    difference(){
    translate([-(board_thickness + 2 * shell_thickness + notch_lenght / 7) / 2,-(board_thickness + 2 * shell_thickness + notch_lenght / 7) / 2, 0]) 
        cube([notch_lenght / 7, notch_lenght / 7, notch_depth], center = true);
    translate([-(board_thickness + 2 * shell_thickness + 2* notch_lenght / 7)/2,-(board_thickness + 2 * shell_thickness + 2*notch_lenght / 7) / 2, 0])  
        cylinder(h = notch_depth+2, r = notch_lenght/7, center = true);;}
    
}

module main(){
    union(){
    brace_hole(); 
    for (i = [1 : connectors_amount]){
        rotate([0, 0, connectors_angle * i]) board_hole();}
    if (connectors_amount > 1 && connectors_amount < 8 && connectors_angle == 90){
        
        for (i = [1 : pow(2, connectors_amount - 2)]){
            rotate([0, 0, (i - 1) * connectors_angle]) rounded_corner();
        }
    }
    if (its_a_bottom_part && (connectors_amount == 1)){
        if (straight_1_connector_bottom == "false" && its_a_bottom_part == "true"){
        translate([(board_thickness + 2 * shell_thickness - ground_surface) / 2, 0, 0]) ground_piece();}    
        else{
            translate([(ground_offset + board_thickness) / 2 + shell_thickness, 0, 0]) cube([ground_offset, board_thickness + 2 * shell_thickness, notch_depth], center = true);}
    }
    if (its_a_bottom_part && (connectors_amount == 2)){
    translate([(board_thickness + 2 * shell_thickness - ground_surface) / 2, 0, 0]) ground_piece();}
    if (its_a_bottom_part && (connectors_amount == 3)){
        ground_piece();}
    }
}

//minkowski(){
main();
//rounded_corner();
//rotate([0,0,90]) rounded_corner();
//cylinder(h = 10, r = 2, center = true);}-