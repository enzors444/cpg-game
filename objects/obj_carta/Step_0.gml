if (variable_global_exists("pause_ativo") && global.pause_ativo) {
    exit;
}

// hover
hover = point_in_rectangle(mouse_x, mouse_y,
    bbox_left, bbox_top, bbox_right, bbox_bottom);
if(selecionada){
	var _alvo = hover -12;
	y_offset = lerp(y_offset, _alvo, 0.2);
	draw_set_color(c_black);  // Borda preta padrão (ou c_white, você escolhe)
}
else{
	var _alvo = hover ? -12 : 0;
	y_offset = lerp(y_offset, _alvo, 0.2);
}
