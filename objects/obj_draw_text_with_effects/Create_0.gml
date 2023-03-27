var _effects = [
	["fnt_fnt_stencil"], // Default
	["fnt_fnt_stencil","ani_","wav_5","cl4_cc0000cc00008fce008fce00"], /*Wave/ Degrade Vermelho e Verde*/
];
var _string = "{0}Testando se está funcionando {1}o novo metodo de passar efeitos";
text = get_string_effects(_string, _effects);

show_debug_overlay(true);