extends Node

func shoot_projectile_fixed(projectile_scene, damage, speed, spawn_location, target):
	var projectile_instance = projectile_scene.instantiate()
	projectile_instance.pos = spawn_location
	projectile_instance.damage = damage
	projectile_instance.speed = speed
	projectile_instance.target = target
	get_parent().add_child(projectile_instance)

func shoot_projectile_directional(projectile_scene, damage, speed, spawn_location, direction):
	var projectile_instance = projectile_scene.instantiate()
	projectile_instance.pos = spawn_location
	projectile_instance.damage = damage
	projectile_instance.speed = speed
	projectile_instance.target_direction = direction
	get_parent().add_child(projectile_instance)

func shoot_volley(projectile_scene, damage, speed, spawn_location, direction, angles_array):
	for i in angles_array:
		shoot_projectile_directional(projectile_scene, damage, speed, spawn_location, direction.rotated(Vector3.UP, deg_to_rad(i)))
