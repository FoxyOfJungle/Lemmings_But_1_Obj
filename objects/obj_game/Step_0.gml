
var ilen = array_length(inst);
var i = ilen-1;
repeat(ilen) {
	var ob = inst[i];
	
	// step event
	if (ob.step_ev != -1) {
		ob.step_ev();
	}
	
	i--;
}

if keyboard_check_pressed(ord("R")) {
	room_restart();
}
