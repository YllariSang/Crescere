extends Area2D

@export var fragment_value: int = 1

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		Game.add_fragment(fragment_value)
		queue_free()
