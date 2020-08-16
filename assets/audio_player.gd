extends AudioStreamPlayer

var entered_portal_seek_time = 0

export (PackedScene) var audio_player_helper

export (AudioStream) var door_unlock_sfx
export (AudioStream) var door_locked_sfx
export (AudioStream) var fall_hole_sfx
export (Array, AudioStream) var key_get_sfx
export (AudioStream) var portal_enter_sfx
export (AudioStream) var portal_exit_sfx
export (AudioStream) var rock_smash_sfx
export (AudioStream) var speed_up_sfx
export (AudioStream) var wall_bump_sfx
export (AudioStream) var zoom_in_sfx

export (AudioStream) var main_music
export (AudioStream) var main_music_distant
export (AudioStream) var lvl_music
export (AudioStream) var lvl_music_distant
export (AudioStream) var escape_music

var audio_active_idx = 0

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

func play_music_main(distant=false):
	var from_pos = 0
	var curr_audiop = get_active_audio_player()
	var next_audiop = get_next_audio_player()
	
	if curr_audiop.get_stream() == main_music or curr_audiop.get_stream() == main_music_distant:
		from_pos = curr_audiop.get_playback_position()
	
	next_audiop.set_stream(main_music_distant if distant else main_music)
	next_audiop.play(from_pos)
	handle_fade(curr_audiop, next_audiop)

func play_lvl_music(distant=false):
	var from_pos = 0
	var curr_audiop = get_active_audio_player()
	var next_audiop = get_next_audio_player()
	
	var music = lvl_music_distant if distant else lvl_music
	
	if curr_audiop.get_stream() == music:
		return
	
	if curr_audiop.get_stream() == lvl_music or curr_audiop.get_stream() == lvl_music_distant:
		from_pos = curr_audiop.get_playback_position()
	
	next_audiop.set_stream(music)
	next_audiop.play(from_pos)
	handle_fade(curr_audiop, next_audiop)

func play_ending_music():
	var curr_audiop = get_active_audio_player()
	var next_audiop = get_next_audio_player()
	
	curr_audiop.stop()
	next_audiop.set_stream(escape_music)
	next_audiop.play()

func get_active_audio_player():
	return [$AudioStreamPlayer1, $AudioStreamPlayer2][audio_active_idx]

func get_next_audio_player():
	return [$AudioStreamPlayer1, $AudioStreamPlayer2][(audio_active_idx + 1) % 2]

func proceed_next_audio_player():
	audio_active_idx = (audio_active_idx + 1) % 2

func handle_fade(curr_audiop, next_audiop):
	if curr_audiop.get_stream() != null:
		$Tween.interpolate_property(
			curr_audiop, "volume_db",
			0, -10, 0.5, Tween.TRANS_LINEAR)
		$Tween.interpolate_property(
			next_audiop, "volume_db",
			-10, 0, 0.5, Tween.TRANS_LINEAR)
		$Tween.start()
		
		yield($Tween, "tween_all_completed")
		curr_audiop.stop()
	
	proceed_next_audio_player()
