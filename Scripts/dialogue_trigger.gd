extends Area2D

@export var dialogue_text: String = "Hello!"
@export var only_once: bool = true

signal triggered(text: String)

var _triggered: bool = false

func _ready() -> void:
	connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body: Node) -> void:
	if _triggered and only_once:
		return
	# Detect player by group (player.gd already adds the player to 'player')
	if body and body.is_in_group("player"):
		_triggered = true
		# If a DialogManager autoload exists, call it directly
		var dm = get_node_or_null("/root/DialogManager")
		if dm:
			if dm.has_method("show_dialogue"):
				dm.show_dialogue(dialogue_text)
		# Emit signal for other systems to listen
		emit_signal("triggered", dialogue_text)
		if only_once:
			queue_free()
