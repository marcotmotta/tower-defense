extends "res://Towers/Tower.gd"

var abilities_singleton = preload("res://Towers/Abilities.gd")
var abilities

var void_ability = preload("res://Towers/Projectiles/Void/VoidAbility.tscn")

var attack_cd = 1 #in seconds
var attack_duration = 3 #in seconds

func _ready():
	if pos:
		global_position = pos

	current_level = 1
	levels = ['MeshInstance3D']
	damages_per_level = [300]
	damage = damages_per_level[current_level - 1]

	$Timer.start(attack_cd)

	# instance abilities singleton
	abilities = abilities_singleton.new()
	add_child(abilities)

func _on_timer_timeout():
	target = get_new_target()
	if is_instance_valid(target):
		abilities.cast_void_ability(void_ability, self, damage, target.global_position, attack_duration)
		$Timer.stop()
		$AttackDuration.start(attack_duration)

func _on_attack_duration_timeout():
	$AttackDuration.stop()
	$Timer.start(attack_cd)
