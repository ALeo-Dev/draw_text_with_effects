#region MACRO DRAW_TEXT_WITH_EFFECTS
enum _TEXTS_EFFECTS {
	TXT,
	COL,
	FNT,
	ANG,
	HAL,
	ROT,
	VAL
}
#macro __COL "col_" // cor
#macro __FNT "fnt_" // fonte
#macro __ANG "ang_" // angulo
#macro __HAL "hal_" // halign
#macro __VAL "val_" // valign
#macro __ROT "rot_" // rotação
#endregion

///@func hex
///@arg string
function hex() {
	var _string = argument0;
    var result=0;
    
    var ZERO=ord("0");
    var NINE=ord("9");
    var A=ord("A");
    var F=ord("F");

    for (var i=1; i<=string_length(_string); i++){
        //pega o valor numerico da letra ou numero
        var c=ord(string_char_at(string_upper(_string), i));
        //move ele 4 bites pra esquerda (multiplica por 16)
        result=result<<4;

        //se o valor ta entre 0 e 9
        if (c>=ZERO&&c<=NINE){
            //o valor soma com (valor menos código de zero)
            result=result+(c-ZERO);
        //se o valor ta entre A e F
        } else if (c>=A&&c<=F){
            //o valor soma com (valor menos código de A e mais 10)
            result=result+(c-A+10);
        } 
    }
    //retorna em RGB pq >gamemaker
    return (result>>16 & 0xff) | (result<<16 & 0xff0000) | (result & 0xff00);;
}

///@func get_string_effects()
///@arg string
function get_string_effects(){
	var _string = argument0;
	var _string_len = string_length(_string);
	
	var _fill_array = function(){
		var __array;
		__array[_TEXTS_EFFECTS.TXT]="";
		__array[_TEXTS_EFFECTS.ANG]=0;
		__array[_TEXTS_EFFECTS.COL]=hex("FFFFFF");
		__array[_TEXTS_EFFECTS.FNT]=-1;
		__array[_TEXTS_EFFECTS.HAL]=fa_left;
		__array[_TEXTS_EFFECTS.VAL]=fa_top;
		__array[_TEXTS_EFFECTS.ROT]=false;
		return __array;
	}
	var _array_output = [];
	
	for (var i = 1; i < _string_len; i++){ // passando os efeitos para um array e os textos para uma ds_grid
		var _char_at = string_char_at(_string,i);		
		if (_char_at == "{"){ // Iniciando um comando
			var _initial_char = 1;
			var _array = _fill_array();
			var _array_effects = [];
			var _copy_from = i+1;
			var _qnt_chars = 0;
			
			for (var j = 1; j <= _string_len; j++){
				var _char_command_at = string_char_at(_string,i+j);
				_qnt_chars++;
				if (_char_command_at == ",") or (_char_command_at == "}"){
					array_push(_array_effects,string_copy(_string,_copy_from, _qnt_chars-1));
					_copy_from=i+j+1;
					_qnt_chars = 0;
					if (_char_command_at == "}"){
						_initial_char=i+j+1
						
						var _len_array = array_length(_array_effects);
						for (var k = 0; k < _len_array; k++){
							if (_len_array-1==k){
								_array[_TEXTS_EFFECTS.TXT] = _array_effects[_len_array-1];
							}else{
								var _string_effect = _array_effects[k];
								var _command = string_copy(_string_effect,1,4);
								var _effect = string_copy(_string_effect,5,string_length(_string_effect));
								switch(_command){
									case __COL: _array[_TEXTS_EFFECTS.COL] = hex(_effect) break;
									case __ANG: _array[_TEXTS_EFFECTS.ANG] = real(_effect) break;
									case __FNT: _array[_TEXTS_EFFECTS.FNT] = asset_get_index(_effect) break;
									case __HAL:
										if (_effect == "left") _array[_TEXTS_EFFECTS.HAL] = fa_left;
										if (_effect == "center") _array[_TEXTS_EFFECTS.HAL] = fa_center;
										if (_effect == "right") _array[_TEXTS_EFFECTS.HAL] = fa_right;
									break;
									case __VAL:
										if (_effect == "bottom") _array[_TEXTS_EFFECTS.VAL] = fa_bottom;
										if (_effect == "middle") _array[_TEXTS_EFFECTS.VAL] = fa_middle;
										if (_effect == "top") _array[_TEXTS_EFFECTS.VAL] = fa_top;
									break;
									case __ROT: _array[_TEXTS_EFFECTS.ROT] = true break;
								}
							}
						}
						array_push(_array_output,_array);
						break;
					}
				}
			}			
		}
	}
	
	return _array_output;
}

///@func draw_text_with_effects()
///@arg array_from_get_string_effects
///@arg x
///@arg y
function draw_text_with_effects(){
	var _array = argument0;
	var _x = argument1;
	var _y = argument2;
	for (var i = 0; i < array_length(_array); i++){
		var _rot = 0;
		var _ang = _array[i][_TEXTS_EFFECTS.ANG];
		if (_array[i][_TEXTS_EFFECTS.ROT]){
			_rot = (get_timer() / 1000000*.25 % 1) * 360;
		}
		
		draw_set_color(_array[i][_TEXTS_EFFECTS.COL]);
		draw_set_font(_array[i][_TEXTS_EFFECTS.FNT]);
		draw_set_halign(_array[i][_TEXTS_EFFECTS.HAL]);
		draw_set_valign(_array[i][_TEXTS_EFFECTS.VAL]);
		draw_text_transformed(_x,_y,_array[i][_TEXTS_EFFECTS.TXT],1,1,_ang+_rot);
		_x += string_width(_array[i][_TEXTS_EFFECTS.TXT]);
		draw_set_halign(fa_left);
		draw_set_valign(fa_top);
		draw_set_color(c_white);
		draw_set_font(-1);
	}
}