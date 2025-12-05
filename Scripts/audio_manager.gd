extends Node

const MENU_MUSIC = preload("res://Assets/Audio/OST/Main Menu.mp3")
const GAME_MUSIC = preload("res://Assets/Audio/OST/In Game BG.mp3")

var player: AudioStreamPlayer = null

func _ready() -> void:
    player = AudioStreamPlayer.new()
    add_child(player)
    player.autoplay = false
    player.bus = "Master"
    # Start with the menu music by default
    play("menu")

    # Replay when a track finishes so music loops
    # Connect finished signal; safe in Godot 4 where AudioStreamPlayer emits it
    if player.has_signal("finished"):
        player.connect("finished", Callable(self, "_on_player_finished"))

func play(track_name: String) -> void:
    match track_name:
        "menu":
            _play_stream(MENU_MUSIC)
        "game":
            _play_stream(GAME_MUSIC)
        _:
            push_warning("AudioManager: Unknown track: %s" % track_name)

func stop() -> void:
    if player:
        player.stop()

func _play_stream(stream: AudioStream) -> void:
    if not player:
        return
    if not stream:
        push_warning("AudioManager: stream is null")
        return
    player.stop()
    player.stream = stream
    player.play()

func _on_player_finished() -> void:
    if player and player.stream:
        player.play()
