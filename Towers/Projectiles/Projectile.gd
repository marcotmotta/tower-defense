extends Area3D

var tracking_box_scene = preload("res://Towers/Projectiles/TrackingBox.tscn")

var pos

# tower that shot the projectile
var caster

# in case the target is an enemy or a position:
var target
var target_direction

# in case the projectile has tracking after a delay
var has_tracking = true

var speed
var damage

# expiration timer
var timer = Timer.new()

# tracking timer, if needed
var tracking_timer = Timer.new()

func _process(delta):
	if is_instance_valid(target):
		var direction = (target.global_position - global_position).normalized()
		global_position += direction * speed * delta
		look_at(target.global_position)
	elif target_direction:
		global_position += target_direction * speed * delta
		look_at(global_position + target_direction)
	else:
		free_projectile()

func areaEntered(area):
	if area.is_in_group('enemy') and area.has_method('take_damage'):
		area.take_damage(damage)
		free_projectile()

# if has tracking, just add this to the ready function
func ready_tracking():
	speed *= 0.5
	tracking_timer.connect("timeout", Callable(self, "begin_tracking"))
	tracking_timer.wait_time = 1
	tracking_timer.one_shot = true
	add_child(tracking_timer)
	tracking_timer.start()

	var tracking_box_instance = tracking_box_scene.instantiate()
	add_child(tracking_box_instance)

func begin_tracking():
	speed *= 2

	var current_target = null
	var target_min_length = 0

	for area in $TrackingBox.get_overlapping_areas():
		if area.is_in_group('enemy') and area != target:
			if !current_target or (area.global_position - self.global_position).length() < target_min_length:
				current_target = area
				target_min_length = (area.global_position - self.global_position).length()

	target = current_target
	target_direction = null

func free_projectile():
	queue_free()

func free_timeout():
	timer.connect("timeout", Callable(self, "free_projectile"))
	timer.wait_time = 3
	timer.one_shot = true
	add_child(timer)
	timer.start()
