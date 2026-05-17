if ((variable_global_exists("pause_ativo") && global.pause_ativo)
|| (variable_global_exists("admin_menu_ativo") && global.admin_menu_ativo)) {
    exit;
}

// Faz o efeito subir levemente
y += y_speed;

// Lógica de transparência (Fade)
if (estado_fade == 1) {
    // Vai ficando visível
    image_alpha += velocidade_fade; 
    
    // Quando chegar na opacidade máxima, inverte para começar a sumir
    if (image_alpha >= 1) {
        image_alpha = 1;
        estado_fade = -1; 
    }
} else {
    // Vai ficando transparente de novo
    image_alpha -= velocidade_fade; 
    
    // Quando sumir totalmente, destrói a instância
    if (image_alpha <= 0) {
        instance_destroy(); 
    }
}
