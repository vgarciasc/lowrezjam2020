extends AudioStreamPlayer

var entered_portal_seek_time = 0

export (PackedScene) var audio_player_helper

export (AudioStream) var door_unlock_sfx
export (AudioStream) var fall_hole_sfx
export (Array, AudioStream) var key_get_sfx
export (AudioStream) var portal_enter_sfx
export (AudioStream) var rock_smash_sfx
export (AudioStream) var speed_up_sfx
export (AudioStream) var wall_bump_sfx
export (AudioStream) var zoom_in_sfx
export (AudioStream) var zoom_out_sfx

export (AudioStream) var main_music
export (AudioStream) var lvl_music
export (AudioStream) var lvl_music_distant

func play_sfx(sfx, from_pos=0.0):
	var helper = audio_player_helper.instance()
	add_child(helper)
	helper.set_stream(sfx)
	helper.play(from_pos)
	yield(helper, "finished")
	helper.queue_free()

var key_get_idx = 0
func play_key_get():
	play_sfx(key_get_sfx[key_get_idx])
	key_get_idx = (key_get_idx + 1) % key_get_sfx.size()

func play_main_music():
	set_stream(main_music)
	play()
