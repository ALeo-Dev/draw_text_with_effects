#region MACRO DRAW_TEXT_WITH_EFFECTS
enum _TEXTS_EFFECTS {
	TXT,
	COL,
	FNT,
	ANG,
	BUG,
	TOTAL
}

#macro __COL "col_" // cor
#macro __FNT "fnt_" // fonte
#macro __ANG "ang_" // angulo
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
	var _grid = ds_grid_create(0,_TEXTS_EFFECTS.TOTAL);	
	var _string_len = string_length(_string);
	var _grid_xpos = -1;
	
	for (var i = 1; i < _string_len; i++){ // passando os efeitos para um array e os textos para uma ds_grid
		var _char_at = string_char_at(_string,i);
		var _initial_char = 1;
		if (_char_at == "{"){ // Iniciando um comando
			_grid_xpos++;
			ds_grid_resize(_grid,ds_grid_width(_grid)+1,_TEXTS_EFFECTS.TOTAL);
			ds_grid_set_region(_grid,_grid_xpos,0,_grid_xpos,_TEXTS_EFFECTS.TOTAL,undefined);
			var _array = [];
			var _copy_from = i+1;
			var _qnt_chars = 0;
			
			for (var j = 1; j <= _string_len; j++){
				var _char_command_at = string_char_at(_string,i+j);
				_qnt_chars++;
				if (_char_command_at == ",") or (_char_command_at == "}"){
					array_push(_array,string_copy(_string,_copy_from, _qnt_chars-1));
					_copy_from=i+j+1;
					_qnt_chars = 0;
					if (_char_command_at == "}"){
						_initial_char=i+j+1
						break;
					}
				}
			}
		}
	}
	
	for (var i = 0; i < array_length(_array); i++){
		show_message(_array[i])
	}
}