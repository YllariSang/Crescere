extends Node

@export var fade_time: float = 0.4

var canvas: CanvasLayer
var color_rect: ColorRect

func _ready() -> void:
	# Create a top-level CanvasLayer so the fade is always on top
	canvas = CanvasLayer.new()
	canvas.layer = 100
	add_child(canvas)

	# Fullscreen ColorRect used for fading
	color_rect = ColorRect.new()
	color_rect.color = Color(0, 0, 0, 1)
	color_rect.anchor_left = 0.0
	color_rect.anchor_top = 0.0
	color_rect.anchor_right = 1.0
	color_rect.anchor_bottom = 1.0
	color_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	canvas.add_child(color_rect)

	# Keep it opaque by default; scenes should request fade_in() when ready.
	color_rect.color = Color(0, 0, 0, 1)

func fade_to(alpha: float, time: float = -1.0):
	var t = time if time > 0 else fade_time
	var tw = create_tween()
	tw.tween_property(color_rect, "color:a", alpha, t)
	return tw.finished

func fade_in(time: float = -1.0):
	# Fade from opaque to transparent
	color_rect.color = Color(color_rect.color.r, color_rect.color.g, color_rect.color.b, 1.0)
	return fade_to(0.0, time)

func fade_out(time: float = -1.0):
	# Fade from transparent to opaque
	color_rect.color = Color(color_rect.color.r, color_rect.color.g, color_rect.color.b, 0.0)
	return fade_to(1.0, time)

func fade_and_change_scene(scene_target) -> void:
	# Fade to black, change the scene (supports PackedScene or path string), then fade back in.
	await fade_to(1.0)

	if scene_target is PackedScene:
		var new_scene = scene_target.instantiate()
		var old_scene = get_tree().current_scene
		get_tree().root.add_child(new_scene)
		get_tree().current_scene = new_scene
		if old_scene and old_scene != new_scene:
			old_scene.queue_free()
	else:
		get_tree().change_scene_to_file(str(scene_target))

	await fade_to(0.0)
