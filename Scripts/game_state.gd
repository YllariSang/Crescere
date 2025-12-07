extends Node

signal coins_changed(coins)
signal fragments_changed(fragments)

var coins: int = 0
var fragments: int = 0
var total_fragments: int = 0  # Set this in your game or level
var fragments_submitted: int = 0
var suppress_jump: bool = false  # Used to disable jump input (e.g., during submission)

func _ready() -> void:
	print("Game ready. coins=%d fragments=%d" % [coins, fragments])

func add_coin(amount: int = 1) -> void:
	coins += amount
	print("Game: add_coin -> coins=%d" % coins)
	emit_signal("coins_changed", coins)

func get_coins() -> int:
	return coins

func add_fragment(amount: int = 1) -> void:
	fragments += amount
	print("Game: add_fragment -> fragments=%d/%d" % [fragments, total_fragments])
	emit_signal("fragments_changed", fragments)

func get_fragments() -> int:
	return fragments

func submit_fragments() -> void:
	fragments_submitted = fragments
	print("Submitted %d fragments" % fragments_submitted)

func get_submission_percentage() -> float:
	if total_fragments == 0:
		return 0.0
	return float(fragments_submitted) / float(total_fragments) * 100.0

func load_credits_scene() -> void:
	var percentage = get_submission_percentage()
	print("Loading credits with %.1f%% completion" % percentage)
	Transition.fade_and_change_scene("res://Scenes/credits.tscn")
