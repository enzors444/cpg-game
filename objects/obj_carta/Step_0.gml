// hover
hover = point_in_rectangle(mouse_x, mouse_y,
    bbox_left, bbox_top, bbox_right, bbox_bottom);

// animação suave de subir
var _alvo = hover ? -12 : 0;
y_offset = lerp(y_offset, _alvo, 0.2);

