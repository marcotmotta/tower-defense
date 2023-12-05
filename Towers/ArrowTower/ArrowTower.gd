extends "res://Towers/Tower.gd"

var abilities_singleton = preload("res://Towers/Abilities.gd")
var abilities

var projectile_scene = preload("res://Towers/Projectiles/Arrow/ArrowProjectile.tscn")

var projectile_speed = 40 # projectile speed
var attack_speed = Globals.FAST # in seconds

func _ready():
	if pos:
		global_position = pos

	current_level = 1
	levels = ['MeshInstance3D']
	damages_per_level = [25]
	damage = damages_per_level[current_level - 1]

	$Timer.start(attack_speed)

	# instance abilities singleton
	abilities = abilities_singleton.new()
	add_child(abilities)

func _on_timer_timeout():
		if is_instance_valid(target):
			abilities.shoot_projectile_fixed(projectile_scene, self, damage, projectile_speed, $Marker3D.global_position, target)
			#abilities.shoot_projectile_directional(projectile_scene, self, damage, projectile_speed, $Marker3D.global_position, (target.global_position - $Marker3D.global_position).normalized())
			#abilities.shoot_volley(projectile_scene, self, damage, projectile_speed, $Marker3D.global_position, (target.global_position - $Marker3D.global_position).normalized(), [-20, -10, 0, 10, 20])

func _on_attack_range_area_entered(area):
	attackRangeAreaEntered(area)

func _on_attack_range_area_exited(area):
	attackRangeAreaExited(area)
