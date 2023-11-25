extends "res://Towers/Tower.gd"

var projectile_scene = preload("res://Towers/Projectiles/Fireball/FireballProjectile.tscn")

var projectile_speed = 40 # projectile speed
var attack_speed = Globals.NORMAL # in seconds

func _ready():
	if pos:
		global_position = pos

	current_level = 1
	levels = ['Fire1Mesh', 'Fire2Mesh', 'Fire3Mesh', 'Fire4Mesh']
	damages_per_level = [50, 125, 225, 350]
	damage = damages_per_level[current_level - 1]

	$Timer.start(attack_speed)

func _on_timer_timeout():
		if is_instance_valid(target):
			shoot_fireball()
			#shoot_volley()

func shoot_volley():
	for i in [-20, -10, 0, 10, 20]:
		shoot_fireball((target.global_position - $Marker3D.global_position).normalized().rotated(Vector3.UP, deg_to_rad(i)))

func shoot_fireball(target_direction = null):
	var projectile_instance = projectile_scene.instantiate()
	projectile_instance.pos = $Marker3D.global_position
	projectile_instance.damage = damage
	projectile_instance.speed = projectile_speed
	if target_direction:
		projectile_instance.target_direction = target_direction
	else:
		projectile_instance.target = target
	get_parent().add_child(projectile_instance)

func _on_attackrange_area_entered(area):
	attackRangeAreaEntered(area)

func _on_attackrange_area_exited(area):
	attackRangeAreaExited(area)
