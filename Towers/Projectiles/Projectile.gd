extends Area3D

var pos

# in case the target is an enemy or a position:
var target
var target_direction

var speed
var damage

var timer = Timer.new()

func _process(delta):
	if is_instance_valid(target):
		var direction = (target.global_position - global_position).normalized()
		global_position += direction * speed * delta
	elif target_direction:
		global_position += target_direction * speed * delta
	else:
		free_projectile()

func areaEntered(area):
	if area.is_in_group('enemy') and area.has_method('take_damage'):
		area.take_damage(damage)
		free_projectile()

func free_projectile():
	queue_free()

func free_timeout():
	timer.connect("timeout", Callable(self, "free_projectile"))
	timer.wait_time = 3
	timer.one_shot = true
	add_child(timer)
	timer.start()
