
// world level
if !surface_exists(level_surf) {
	level_surf = surface_create(room_width, room_height);
	if (level_can_generate) {
		surface_set_target(level_surf);
		draw_sprite_stretched(spr_game, 1, 0, 0, room_width, room_height);
		surface_reset_target();
		
		if buffer_exists(level_buff) buffer_delete(level_buff);
		level_buff = buffer_create(room_width*room_height*4, buffer_fixed, 1);
		buffer_get_surface(level_buff, level_surf, 0);
		
		level_can_generate = false;
	}
} else {
	draw_surface(level_surf, 0, 0);
	
	if mouse_check_button(mb_left) {
		surface_set_target(level_surf);
		draw_circle(mouse_x, mouse_y, 4, false);
		surface_reset_target();
		buffer_get_surface(level_buff, level_surf, 0);
	}
	
	if mouse_check_button(mb_right) {
		surface_set_target(level_surf);
		gpu_set_blendmode(bm_subtract);
		draw_circle(mouse_x, mouse_y, 4, false);
		gpu_set_blendmode(bm_normal);
		surface_reset_target();
		buffer_get_surface(level_buff, level_surf, 0);
	}
	
	//var pos = (mouse_x + (mouse_y * room_width)) * 4;
	//var col = buffer_peek(obj_game.level_buff, pos, buffer_u8);
	//show_debug_message(col);
}

// render instances
var i = 0, ilen = array_length(inst);
repeat(ilen) {
	var ob = inst[i];
	
	var atw = 32, ath = 32;
	var sx = 0, sy = 0, ww = 8, hh = 8;
	var k = 0, klen = array_length(ob.fms);
	var mrws = ceil((atw-0 - ww) / ww);
	
	ob.fmi += ob.fmsp; // frame speed
	if (ob.fmi >= klen) ob.fmi = 0;
	var cur_frame = ob.fms[ob.fmi]; // 10, 11 | 0, 1, 2, 3, 4, 5, 6, 7 | ...
	
	var j = 0, jlen = 15;
	repeat(jlen) { // atlas position loop
		repeat(klen) { // sprite frame position loop
			if (k == cur_frame) {
				draw_sprite_part_ext(spr_game, 0, sx, sy, ww, hh, round(ob.xx-ww/2*ob.xs), round(ob.yy-hh*ob.ys), ob.xs, ob.ys, c_white, 1);
				//draw_circle(ob.xx+sx, ob.yy+sy, 3, true);
			}
			sx += ww;
			if (sx > ww * mrws) {
				sx = 0;
				sy += hh;
			}
			k++;
		}
		j++;
	}
	i++;
}
