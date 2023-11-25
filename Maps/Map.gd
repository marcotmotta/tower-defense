extends Node3D

var enemy_scene = preload("res://Enemies/Enemy/Enemy.tscn")

var spawn_delay = 1

func _on_spawn_timer_timeout():
	if Globals.spawn_enemy_count < Globals.enemies_per_wave:
		var enemy_instance = enemy_scene.instantiate()
		enemy_instance.get_node('EnemyArea').max_health = Globals.current_enemy_health()
		$Path3D.add_child(enemy_instance)
		Globals.spawn_enemy_count += 1
		Globals.spawned_enemies += 1
		if Globals.spawn_enemy_count >= Globals.enemies_per_wave:
			Globals.spawned_all_enemies = true
			$SpawnTimer.stop()
			Globals.spawn_enemy_count = 0

func start_wave():
	Globals.spawned_all_enemies = false
	Globals.spawned_enemies = 0
	$SpawnTimer.start(spawn_delay)
