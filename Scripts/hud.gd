extends CanvasLayer

@onready var fragments_label: Label = $Control/CoinsLabel

func _ready() -> void:
	print("HUD: ready - connecting to Game autoload")
	
	# Initialize the label with current fragments
	fragments_label.text = "Fragments: %d" % Game.get_fragments()
	
	# Connect to the fragments_changed signal
	print("HUD: connecting to fragments_changed signal")
	Game.connect("fragments_changed", Callable(self, "_on_fragments_changed"))

	# If a Transition autoload exists, request a fade-in so the scene appears smoothly.
	if get_tree().root.has_node("Transition"):
		var transition_node = get_tree().root.get_node("Transition")
		transition_node.fade_in()

func _on_fragments_changed(fragments: int) -> void:
	print("HUD: fragments_changed -> %d" % fragments)
	if fragments_label:
		fragments_label.text = "Fragments: %d" % fragments
		print("HUD: label updated to '%s'" % fragments_label.text)
	else:
		push_warning("HUD: fragments_label is null when updating")
