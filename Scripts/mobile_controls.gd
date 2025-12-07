extends CanvasLayer

# Virtual button states
var move_left: bool = false
var move_right: bool = false
var jump_pressed: bool = false
var dash_pressed: bool = false
var crouch_pressed: bool = false

# Touch tracking
var touch_positions: Dictionary = {}

func _ready() -> void:
	# Only show controls on mobile
	if OS.get_name() in ["Android", "iOS"]:
		visible = true
	else:
		visible = false

func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		_handle_screen_touch(event)
	elif event is InputEventScreenDrag:
		_handle_screen_drag(event)

func _handle_screen_touch(event: InputEventScreenTouch) -> void:
	if event.pressed:
		touch_positions[event.index] = event.position
		_update_button_states(event.position, true)
	else:
		touch_positions.erase(event.index)
		_update_button_states(event.position, false)

func _handle_screen_drag(event: InputEventScreenDrag) -> void:
	touch_positions[event.index] = event.position

func _update_button_states(pos: Vector2, pressed: bool) -> void:
	# Check which virtual button was touched
	var viewport_size = get_viewport().get_visible_rect().size
	
	# Left side is movement (left third of screen)
	if pos.x < viewport_size.x / 3:
		if pos.x < viewport_size.x / 6:
			move_left = pressed
			move_right = false
		else:
			move_right = pressed
			move_left = false
	
	# Right side buttons (right third of screen)
	elif pos.x > viewport_size.x * 2 / 3:
		# Jump button (top right)
		if pos.y < viewport_size.y / 2:
			jump_pressed = pressed
		# Dash button (middle right)
		elif pos.y < viewport_size.y * 0.75:
			dash_pressed = pressed
		# Crouch button (bottom right)
		else:
			crouch_pressed = pressed

func get_movement_direction() -> float:
	if move_left:
		return -1.0
	elif move_right:
		return 1.0
	return 0.0

func is_jump_pressed() -> bool:
	return jump_pressed

func is_dash_pressed() -> bool:
	return dash_pressed

func is_crouch_pressed() -> bool:
	return crouch_pressed
