/// @description This triggers at the end of the animation and reverses it
	room_goto(target_rm);
	oPlayer.x = target_x;
	oPlayer.y = target_y;
	oPlayer.jLimit = 0;
	
	image_speed = -1;
