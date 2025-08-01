/// @description This is what creates and maintains the look of the main menu
display_set_gui_size(surface_get_width(application_surface), surface_get_height(application_surface));
// draw the options
draw_set_font(global.font_main);
draw_set_valign(fa_top);
draw_set_halign(fa_left);

//dynamically get width and height of menu
var _new_w = 0;
for(var i = 0; i < op_length; i++)
	{
	var _op_w = string_width(levelText);
	_new_w = max(_new_w, _op_w);
	}
width = string_width(levelText) + op_border*2;
height = op_border*2 + string_height(levelText) + (op_length-1)*op_space;

//center menu
x = view_get_wport(0)/2 - width/2;
y = view_get_hport(0)/2 - height/2;

// draw the menu background
//var _c= c_white;
draw_sprite_ext(sprite_index, image_index, x, y, width/sprite_width, height/sprite_height, 0, c_white, 1);
//draw_text_color(x+op_border, y+op_border + op_space*1, levelText, _c, _c, _c, _c, 1);


for(var i = 0; i < op_length; i++)
	{
	var _c = c_white;
	//if pos == i {_c = c_yellow};
	draw_text_color(x+op_border, y+op_border + op_space*i, levelText, _c, _c, _c, _c, 1);
	}
