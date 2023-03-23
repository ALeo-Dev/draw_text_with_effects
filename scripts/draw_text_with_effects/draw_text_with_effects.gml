#region MACRO DRAW_TEXT_WITH_EFFECTS
enum _TEXTS_EFFECTS {
	COL,
	FNT,
	ANG,
	TOTAL
}

#macro __COL "col_" // cor
#macro __FNT "fnt_" // fonte
#macro __ANG "ang_" // angulo
#endregion

///@func get_string_effects()
///@arg string
function get_string_effects(){
	var _string = argument0;
	var _array = [];
	
	var _string_len = string_length(_string);
	for (var i = 1; i < _string_len; i++){
		var _char_at = string_char_at(_string,i);
		if (_char_at == "{"){ // Iniciando um comando
			var _array_push = [];
			var _continue = true;
			var _add_char_pos = 0;
			while (_continue){
				var _command = string_copy(_string, i+1, i+3);
				
				switch(_command){
					#region COR
					case __COL : 
						for (var j = 0; j < _string_len; j++){
							var _char_command_at = string_char_at(_string,i+j);
							show_message(_char_command_at)
							if (_char_command_at == "}") or (_char_command_at == ","){
								show_message(j)
								var _color = string_copy(_string,i+5,j-2);
								show_message(_color);
							}
						}
					break;
					#endregion
				}
			}
		}
	}
	
}