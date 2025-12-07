extends Area2D

@onready var label: Label = $Label

@export var required_fragments: int = 0  # 0 means no requirement, any amount works

var player_in_range: bool = false

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _process(_delta: float) -> void:
	if player_in_range and Input.is_action_just_pressed("ui_accept"):
		_submit_fragments()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_range = true
		Game.suppress_jump = true
		_show_prompt()
	label.visible = true

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_range = false
		Game.suppress_jump = false
		_hide_prompt()
	label.visible = false

func _submit_fragments() -> void:
	var fragments = Game.get_fragments()
	
	# Check if player has enough fragments
	if required_fragments > 0 and fragments < required_fragments:
		print("Need %d fragments, only have %d" % [required_fragments, fragments])
		return
	
	# Submit fragments and go to credits
	Game.submit_fragments()
	Game.load_credits_scene()

func _show_prompt() -> void:
	# You can create a label or UI element here
	print("Press SPACE to submit fragments and view credits")

func _hide_prompt() -> void:
	# Hide the prompt UI
	pass
