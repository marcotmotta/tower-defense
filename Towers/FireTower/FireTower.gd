extends "res://Towers/Tower.gd"

var abilities_singleton = preload("res://Towers/Abilities.gd")
var abilities

var projectile_scene = preload("res://Towers/Projectiles/Fireball/FireballProjectile.tscn")

var projectile_speed = 20 # projectile speed
var attack_speed = Globals.NORMAL # in seconds

func _ready():
	if pos:
		global_position = pos

	current_level = 1
	levels = ['Fire1Mesh', 'Fire2Mesh', 'Fire3Mesh', 'Fire4Mesh']
	damages_per_level = [50, 125, 225, 350]
	damage = damages_per_level[current_level - 1]

	$Timer.start(attack_speed)

	# instance abilities singleton
	abilities = abilities_singleton.new()
	add_child(abilities)

func _on_timer_timeout():
		if is_instance_valid(target):
			abilities.shoot_volley_delay_tracking(projectile_scene, self, damage, projectile_speed, $Marker3D.global_position, 6)
			#abilities.shoot_projectile_fixed(projectile_scene, self, damage, projectile_speed, $Marker3D.global_position, target)
			#abilities.shoot_projectile_directional(projectile_scene, self, damage, projectile_speed, $Marker3D.global_position, (target.global_position - $Marker3D.global_position).normalized())
			#abilities.shoot_volley(projectile_scene, self, damage, projectile_speed, $Marker3D.global_position, (target.global_position - $Marker3D.global_position).normalized(), [-20, -10, 0, 10, 20])

func _on_attackrange_area_entered(area):
	attackRangeAreaEntered(area)

func _on_attackrange_area_exited(area):
	attackRangeAreaExited(area)
