extends CanvasLayer

@onready var panel: Node = null
@onready var label: Label = null

func _ready() -> void:
	# If this script is used as an Autoload scene, ensure children exist.
	# The user can create a `Panel` with a `Label` as children and attach this script.
	panel = get_node_or_null("Panel")
	label = get_node_or_null("Panel/Label")
	if panel:
		panel.visible = false

func show_dialogue(text: String) -> void:
	# Basic dialog display: set text, show panel, wait for `ui_accept` to close.
	if label:
		label.text = text
	if panel:
		panel.visible = true
	# Simple async wait for player confirm
	await _wait_for_accept()
	if panel:
		panel.visible = false

func _wait_for_accept() -> void:
	while true:
		await get_tree().process_frame
		if Input.is_action_just_pressed("ui_accept"):
			return
