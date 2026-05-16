draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_color(selecionada ? c_yellow : c_white);
draw_rectangle(x - 20, y - 20, x + 20, y + 20, false);
draw_set_color(c_black);
draw_text(x, y, operacao);