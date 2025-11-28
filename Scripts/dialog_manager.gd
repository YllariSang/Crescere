extends CanvasLayer

@onready var panel: Panel = null
@onready var label: RichTextLabel = null

func _ready() -> void:
	# Look up the nodes and start hidden
	panel = get_node_or_null("Panel")
	label = get_node_or_null("Panel/RichTextLabel")
	if panel:
		panel.visible = false

func show_dialogue(text: String, typing_speed := 0.0) -> void:
	# Display dialog with optional typing effect (seconds per character).
	if not label or not panel:
		return

	panel.visible = true
	label.clear()
	label.bbcode_enabled = true

	if typing_speed > 0.0:
		# Type character-by-character
		for i in text.length():
			label.append_text(text[i])
			await get_tree().create_timer(typing_speed).timeout
	else:
		# Show instantly (safe for BBCode by escaping)
		# If the text contains BBCode intentionally, pass it through `append_bbcode` instead.
		label.append_text(text)

	# Wait for player confirm
	await _wait_for_accept()
	panel.visible = false

func _wait_for_accept() -> void:
	while true:
		await get_tree().process_frame
		if Input.is_action_just_pressed("ui_accept"):
			return
