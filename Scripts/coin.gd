extends Node2D

@onready var area: Area2D = $Area2D

@onready var collision_shape_2d: CollisionShape2D = $Area2D/CollisionShape2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

# Guard to ensure the coin is only collected once (prevents double-counting)
var _collected: bool = false

func _ready() -> void:
	if area:
		area.connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body: Node) -> void:
	if not body or not body.is_in_group("player"):
		return
	# If this coin was already collected, ignore additional signals
	if _collected:
		return
	_collected = true
	# Prevent further pickups
	if area:
		area.monitoring = false

	# Add fragment to the Game autoload
	Game.add_fragment(1)
	print("Fragment collected! Total: %d/%d" % [Game.fragments, Game.total_fragments])

	# Play pickup SFX at the coin's position (create a short-lived player under the current scene)
	var sfx_path := "res://Assets/Audio/SFX/Pickup.wav"
	if ResourceLoader.exists(sfx_path):
		var root = get_tree().get_current_scene()
		if not root:
			root = get_tree().get_root()
		var ap := AudioStreamPlayer2D.new()
		ap.stream = load(sfx_path)
		ap.global_position = global_position
		root.add_child(ap)
		ap.play()
		var cleanup_t := Timer.new()
		cleanup_t.one_shot = true
		# try to use stream length if available, otherwise default to 1s
		var sfx_len := 1.0
		if ap.stream and ap.stream.has_method("get_length"):
			sfx_len = ap.stream.get_length()
		cleanup_t.wait_time = sfx_len + 0.1
		root.add_child(cleanup_t)
		cleanup_t.start()
		cleanup_t.timeout.connect(Callable(ap, "queue_free"))
		cleanup_t.timeout.connect(Callable(cleanup_t, "queue_free"))

	# Play a short collect animation using a Tween: scale up, fade out, and rise
	var t = create_tween()
	if sprite:
		# scale up
		t.tween_property(sprite, "scale", sprite.scale * 1.5, 0.25)
		# fade out
		t.tween_property(sprite, "modulate:a", 0.0, 0.25)
	# rise slightly (animate the coin node itself)
	t.tween_property(self, "position:y", position.y - 16, 0.25)

	# Wait for the tween to finish, then free the coin
	await t.finished
	queue_free()
