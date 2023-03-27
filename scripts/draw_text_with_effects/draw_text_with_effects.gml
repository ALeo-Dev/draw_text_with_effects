#region MACRO DRAW_TEXT_WITH_EFFECTS
enum _TEXTS_EFFECTS {
	TXT,
	COL,
	FNT,
	ANG,
	ROT,
	CL4,
	WAV,
	ANI,
	SCR,
	SPR,
	ALP,
	GHT,
	BLD,
	XSC,
	YSC,
	XSI,
	YSI
}
#macro __COL "col_" // cor
#macro __FNT "fnt_" // fonte
#macro __ANG "ang_" // angulo
#macro __ROT "rot_" // rotação
#macro __CL4 "cl4_" // 4 cores no texto
#macro __WAV "wav_" // letras dançando
#macro __ANI "ani_" // texto com animação
#macro __SCR "scr_" // Scream / Grito
#macro __SPR "spr_" // sprite
#macro __ALP "alp_" // alpha
#macro __GHT "ght_" // Ghost
#macro __BLD "bld_" // Ballad
#macro __XSC "xsc_" // xscale
#macro __YSC "ysc_" // yscale
#macro __XSI "xsi_" // xscale increase
#macro __YSI "ysi_" // yscale increase
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
///@arg array_effects
function get_string_effects(){
	var _string = argument0;
	var _array_with_effects = argument1;
	
	var _fill_array = function(){
		var __array;
		__array[_TEXTS_EFFECTS.TXT]="";
		__array[_TEXTS_EFFECTS.ANG]=0;
		__array[_TEXTS_EFFECTS.COL]=hex("FFFFFF");
		__array[_TEXTS_EFFECTS.FNT]=-1;
		__array[_TEXTS_EFFECTS.ROT]=0;
		__array[_TEXTS_EFFECTS.CL4]=noone;
		__array[_TEXTS_EFFECTS.WAV]=0;
		__array[_TEXTS_EFFECTS.ANI]=false;
		__array[_TEXTS_EFFECTS.SCR]=0;
		__array[_TEXTS_EFFECTS.SPR]=noone;
		__array[_TEXTS_EFFECTS.ALP]=1;
		__array[_TEXTS_EFFECTS.GHT]=0;
		__array[_TEXTS_EFFECTS.BLD]=0;
		__array[_TEXTS_EFFECTS.XSC]=1;
		__array[_TEXTS_EFFECTS.YSC]=1;
		__array[_TEXTS_EFFECTS.YSI]=0;
		__array[_TEXTS_EFFECTS.XSI]=0;
		return __array;
	}
	var _array_output = [];
	for (var i = 1; i < string_length(_string); i++){
		var _char_at = string_char_at(_string,i);
		if (_char_at = "{"){
			var _array = _fill_array();
			for (var index = 1; string_char_at(_string,i+index)!="}"; index++){
			} // pegando o index da array que tá os efeitos desejados
			
			#region passando o texto
			for (var j = index+i+1; j < string_length(_string); j++){
				var __char_at = string_char_at(_string,j);
				if (__char_at == "{"){
					var _string_to_copy = string_copy(_string,i+index+1,j-index-i-1)
					_array[_TEXTS_EFFECTS.TXT] = _string_to_copy;
					break;
				}
				if (j == string_length(_string)-1){
					var _string_to_copy = string_copy(_string,i+index+1,j)
					_array[_TEXTS_EFFECTS.TXT] = _string_to_copy;
					break;
				}
			}
			#endregion
			#region passando os efeitos
			var _index_effect = string_copy(_string,i+1,index-1);
			var _array_len = array_length(_array_with_effects[_index_effect]);
			for (var j = 0; j < _array_len; j++){
				var _string_effect = _array_with_effects[_index_effect][j];
				var _string_effect_len = string_length(_string_effect);
				var _command = string_copy(_string_effect,1,4);
				var _effect = string_copy(_string_effect,5,_string_effect_len);
				
				switch(_command){
					case __COL: _array[_TEXTS_EFFECTS.COL] = hex(_effect) break;
					case __ANG: _array[_TEXTS_EFFECTS.ANG] = real(_effect) break;
					case __FNT: _array[_TEXTS_EFFECTS.FNT] = asset_get_index(_effect) break;
					case __ROT: _array[_TEXTS_EFFECTS.ROT] = real(_effect) break;
					case __CL4:
						var _array_colors = [];
						for (var l = 0; l < 4; l++){
							array_push(_array_colors,hex(string_copy(_effect,1+l*6,6)));
						}
						_array[_TEXTS_EFFECTS.CL4] = _array_colors;
					break;
					case __WAV: _array[_TEXTS_EFFECTS.WAV] = real(_effect) break;
					case __ANI: _array[_TEXTS_EFFECTS.ANI] = true break;
					case __SCR: _array[_TEXTS_EFFECTS.SCR] = real(_effect) break;
					case __SPR: _array[_TEXTS_EFFECTS.SPR] = asset_get_index(_effect) break;
					case __ALP: _array[_TEXTS_EFFECTS.ALP] = real(_effect) break;
					case __GHT: _array[_TEXTS_EFFECTS.GHT] = real(_effect) break;
					case __BLD: _array[_TEXTS_EFFECTS.BLD] = real(_effect) break;
					case __XSC: _array[_TEXTS_EFFECTS.XSC] = real(_effect) break;
					case __YSC: _array[_TEXTS_EFFECTS.YSC] = real(_effect) break;
					case __YSI: _array[_TEXTS_EFFECTS.YSI] = real(_effect) break;
					case __XSI: _array[_TEXTS_EFFECTS.XSI] = real(_effect) break;
				}
			}
			#endregion
			array_push(_array_output,_array);
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
		_rot = (get_timer() / 1000000*_array[i][_TEXTS_EFFECTS.ROT] % 1) * 360;
		var _spr = _array[i][_TEXTS_EFFECTS.SPR];
		
		if (_spr == noone){
			draw_set_color(_array[i][_TEXTS_EFFECTS.COL]);
			draw_set_font(_array[i][_TEXTS_EFFECTS.FNT]);
			
			if (_array[i][_TEXTS_EFFECTS.GHT]>0){
				_alpha = abs(dsin((get_timer() / 1000000*_array[i][_TEXTS_EFFECTS.GHT] % 1)*360));
			}else{
				var _alpha = _array[i][_TEXTS_EFFECTS.ALP];
			}
			
			if (_array[i][_TEXTS_EFFECTS.BLD]>0){
				var _hue = get_timer() / 1000000*_array[i][_TEXTS_EFFECTS.BLD] % 1 *255;
				_array[i][_TEXTS_EFFECTS.COL] = make_color_hsv(_hue,255,255);
			}
			
			var _xscale = _array[i][_TEXTS_EFFECTS.XSC];
			var _yscale = _array[i][_TEXTS_EFFECTS.YSC];			

			if (_array[i][_TEXTS_EFFECTS.XSI]!=0){
				var _channel = animcurve_get_channel(ac_draw_text_with_effects,"curve0to1");
				var _pos = (get_timer() / 1000000 % 1);
				_xscale+=animcurve_channel_evaluate(_channel,_pos)*_array[i][_TEXTS_EFFECTS.XSI];
			}
			
			if (_array[i][_TEXTS_EFFECTS.YSI]!=0){
				var _channel = animcurve_get_channel(ac_draw_text_with_effects,"curve0to1");
				var _pos = (get_timer() / 1000000 % 1);
				_yscale+=animcurve_channel_evaluate(_channel,_pos)*_array[i][_TEXTS_EFFECTS.YSI];
			}
			
			draw_set_alpha(_alpha);
			
			if (!_array[i][_TEXTS_EFFECTS.ANI]){ // se o texto não tem animação
				var _string_len = string_length(_array[i][_TEXTS_EFFECTS.TXT]);
				var _draw_pos = 1;
				for (var j = 0; j < _string_len+1; j++){
					var _string_draw = string_copy(_array[i][_TEXTS_EFFECTS.TXT],_draw_pos,j-_draw_pos);
					var _string = string_char_at(_array[i][_TEXTS_EFFECTS.TXT],j);
					if (j == _string_len){
						var _string_draw = string_copy(_array[i][_TEXTS_EFFECTS.TXT],_draw_pos,j-_draw_pos+1);
						if (_array[i][_TEXTS_EFFECTS.CL4]==noone){
							draw_text_transformed(_x,_y,_string_draw,_xscale,_yscale,_ang+_rot);
						}else{
							var _colors = _array[i][_TEXTS_EFFECTS.CL4];
							draw_text_transformed_color(_x,_y,_string_draw,_xscale,_yscale,_ang+_rot,_colors[0],_colors[1],_colors[2],_colors[3],_alpha);
						}
						_x += string_width(_string_draw)*_xscale;
					}else{
						if (_string == "☺"){
							if (_array[i][_TEXTS_EFFECTS.CL4]==noone){
								draw_text_transformed(_x,_y,_string_draw,_xscale,_yscale,_ang+_rot);
							}else{
								var _colors = _array[i][_TEXTS_EFFECTS.CL4];
								draw_text_transformed_color(_x,_y,_string_draw,_xscale,_yscale,_ang+_rot,_colors[0],_colors[1],_colors[2],_colors[3],_alpha);
							}
							_x = argument1;
							_y += string_height(_string_draw)*_yscale;
							_draw_pos = j+1;
						}
					}
				}
			}else{ // texto com animações
				var _anim_string_len = string_length(_array[i][_TEXTS_EFFECTS.TXT]);
				for (var j = 1; j < _anim_string_len+1; j++){
					var _string = string_char_at(_array[i][_TEXTS_EFFECTS.TXT],j);
					var _xadd = 0;
					var _yadd = 0;
				
					if (_string == "☺"){
						_x = argument1;
						_y += string_height(_string)*_yscale;
					}else{
						if (_array[i][_TEXTS_EFFECTS.WAV]>0) { // configurando a wave
							_yadd += dsin(get_timer()/7000+j*45) *_array[i][_TEXTS_EFFECTS.WAV];
						}
				
						if (_array[i][_TEXTS_EFFECTS.SCR]>0){ // configurando o grito
							_xadd += dcos(random(360)) * _array[i][_TEXTS_EFFECTS.SCR];
							_yadd += dsin(random(360)) * _array[i][_TEXTS_EFFECTS.SCR];
						}
				
				
						if (_array[i][_TEXTS_EFFECTS.CL4]==noone){
							draw_text_transformed(_x+_xadd,_y+_yadd,_string,_xscale,_yscale,_ang+_rot);
						}else{
							var _colors = _array[i][_TEXTS_EFFECTS.CL4];
							draw_text_transformed_color(_x+_xadd,_y+_yadd,_string,_xscale,_yscale,_ang+_rot,_colors[0],_colors[1],_colors[2],_colors[3],_alpha);
						}
				
						_x += string_width(_string)*_xscale;
					}
				}
			}
		}else{
			draw_sprite(_spr,0,_x,_y);
			_x += sprite_get_width(_spr);
		}
		draw_set_color(c_white);
		draw_set_font(-1);
		draw_set_alpha(1);
	}
}