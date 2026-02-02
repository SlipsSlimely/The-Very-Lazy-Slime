draw_self();

draw_set_font(global.font_main);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_color(c_white);


//dynamically get width and height of menu
//var _new_w = 0;
//for(var i = 0; i < op_length; i++)
//	{
//	var _op_w = string_width(button_text);
//	_new_w = max(_new_w, _op_w);
//	}
//width = string_width(button_text) + op_border*2;
//height = op_border*2 + string_height(button_text) + (op_length-1)*op_space;

// draw the menu background
//draw_sprite_ext(sprite_index, image_index, x, y, width/sprite_width, height/sprite_height, 0, c_white, 1);

// draw the text
for(var i = 0; i < op_length; i++)
	{
	var _c = c_white;
	//if pos == i {_c = c_yellow};
	draw_text_color(x+op_border, y+op_border + op_space*i, button_text, _c, _c, _c, _c, 1);
	}