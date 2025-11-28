extends Node2D

@export var target_path: NodePath
@export var follow_speed: float = 10.0 # higher = snappier; 0 for instant
@export var max_offset: Vector2 = Vector2.ZERO # if zero, calculated from sprite sizes

@onready var iris: Sprite2D = $Iris
@onready var eye_sprite: Sprite2D = $Eye
@onready var mask_polygon: Polygon2D = get_node_or_null("MaskPolygon")

func _ready() -> void:
	# If max_offset not set, compute from textures: (eye_size - iris_size)/2 per axis
	if max_offset == Vector2.ZERO and eye_sprite and iris and eye_sprite.texture and iris.texture:
		var eye_size = eye_sprite.texture.get_size() * eye_sprite.scale
		var iris_size = iris.texture.get_size() * iris.scale
		max_offset = (eye_size - iris_size) * 0.5
		# Ensure positive values
		max_offset = Vector2(abs(max_offset.x), abs(max_offset.y))

func _process(delta: float) -> void:
	var target = null
	if target_path and target_path != NodePath("") and has_node(target_path):
		target = get_node(target_path)
	else:
		var players = get_tree().get_nodes_in_group("player")
		if players.size() > 0:
			target = players[0]

	if not target:
		return

	# Convert target global position into local space of the eye root
	var local_pos = to_local(target.global_position)

	# First, apply rectangular clamping based on max_offset if set
	var clamped = local_pos
	if max_offset != Vector2.ZERO:
		clamped.x = clamp(clamped.x, -max_offset.x, max_offset.x)
		clamped.y = clamp(clamped.y, -max_offset.y, max_offset.y)

	# If a MaskPolygon exists, ensure the iris stays inside it. If desired position
	# lies outside the polygon, snap it to the nearest point on the polygon boundary.
	if mask_polygon and mask_polygon.polygon.size() >= 3:
		var poly = mask_polygon.polygon
		# polygon points are in mask_polygon local coords; convert desired point to that space
		var desired = clamped
		# Check point-in-polygon (Geometry.is_point_in_polygon expects array of Vector2)
		if not _point_in_polygon(desired, poly):
			# Find closest point on polygon edges
			var best = poly[0]
			var best_dist = INF
			var n = poly.size()
			for i in range(n):
				var a = poly[i]
				var b = poly[(i + 1) % n]
				var cp = _closest_point_on_segment(desired, a, b)
				var d = cp.distance_to(desired)
				if d < best_dist:
					best_dist = d
					best = cp
			clamped = best

	# Smooth-follow or snap
	if follow_speed > 0:
		var t = clamp(follow_speed * delta, 0.0, 1.0)
		iris.position = iris.position.lerp(clamped, t)
	else:
		iris.position = clamped


func _closest_point_on_segment(p: Vector2, a: Vector2, b: Vector2) -> Vector2:
	var ab = b - a
	var t = 0.0
	var denom = ab.dot(ab)
	if denom > 0.000001:
		t = (p - a).dot(ab) / denom
		t = clamp(t, 0.0, 1.0)
	return a + ab * t


func _point_in_polygon(point: Vector2, poly: PackedVector2Array) -> bool:
	var inside := false
	var j := poly.size() - 1
	for i in range(poly.size()):
		var pi = poly[i]
		var pj = poly[j]
		if ((pi.y > point.y) != (pj.y > point.y)):
			var x_intersect = (pj.x - pi.x) * (point.y - pi.y) / (pj.y - pi.y) + pi.x
			if point.x < x_intersect:
				inside = not inside
		j = i
	return inside
