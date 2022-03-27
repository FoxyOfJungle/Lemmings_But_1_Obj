
show_debug_overlay(true);

var gmw = 240, gmh = 135;
window_set_size(gmw*4, gmh*4);
camera_set_view_size(view_camera[0], gmw, gmh);
display_set_gui_size(gmw, gmh);
audio_play_sound(snd_sound, 0, true);
alarm[0] = 1;

function object() constructor {
	fms = [];
	fmi = 0;
	fmsp = 0.2;
	xx = 0;
	yy = 0;
	xs = 1;
	ys = 1;
	step_ev = -1;
	
	static collision = function(xx, yy) {
		var pos = (xx + (yy * room_width)) * 4;
		if (buffer_peek(obj_game.level_buff, pos, buffer_u32) >= 255) return true;
		return false;
	}
}

function obj_player() : object() constructor {
	fms = [0, 1, 2, 3, 4, 5, 6, 7];
	state = 0;
	dir = 1;
	dist = 0;
	
	step_ev = function() {
		if (state == 0) {
			var yp = 0;
			for(var c = 0; c < 3; c++) {
				if (collision(xx, yy+c)) break;
				yp += 1;
			}
			yy += yp;
			dist += yp;
			
			if (yp == 0) {
				state = 1;
			}
		} else if (state == 1) {
			var yp = -4;
			xx += fmsp * dir;
			xs = dir;
			
			for(var c =-4; c <= 3; c++) {
				if (collision(xx, yy+c)) break;
				yp++;
			}
                    
			if (yp == -4) {
				yp = 0;
				dir *= -1;
			}
			if (yp == 4) state = 0;
			if (yp == 0) dist = 0;
			
			yy += yp;
		}
		if (yy > room_height) obj_game.inst_dr(self);
	}
}

function obj_enemy() : object() constructor {
	fms = [10, 11];
	fmsp = 0.1;
	dir = 1;
	
	step_ev = function() {
		var yp = -4;
		xx += fmsp * dir;
		xs = dir;
			
		for(var c =-4; c <= 3; c++) {
			if (collision(xx, yy+c)) break;
			yp++;
		}
                    
		if (yp == -4) {
			yp = 0;
			dir *= -1;
		}
		if (yp == 4) state = 0;
		if (yp == 0) dist = 0;
			
		yy += yp;
		if (yy > room_height) obj_game.inst_dr(self);
	}
}

function obj_flag() : object() constructor {
	fms = [9];
}

function obj_rock() : object() constructor {
	fms = [13];
}

function obj_lava() : object() constructor {
	fms = [14];
}


inst = [];
inst_cr = function(x, y, obj) {
	var ii = new obj();
	ii.xx = x;
	ii.yy = y;
	array_push(inst, ii); return ii;
}

inst_dr = function(obj) {
	for (var i = 0; i < array_length(inst); ++i) {
		if (obj == inst[i]) {
			array_delete(inst, i, 1);
			break;
		}
	}
}

level_surf = -1;
level_buff = -1;
level_can_generate = true;

alarm[1] = 10;
alarm[2] = 10;
