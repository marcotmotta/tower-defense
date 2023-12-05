extends Node

const SLOW = 2
const NORMAL = 1
const FAST = 0.5

var current_wave = 1
var enemies_per_wave = 10
var spawn_enemy_count = 0

var spawned_enemies = 0
var spawned_all_enemies = true

var gold = 0

const arrow_tower_cost = 10
const fire_tower_cost = 10
const ice_tower_cost = 20
const void_tower_cost = 10

var highlighted_tower = null

func reset() -> void:
	current_wave = 1
	enemies_per_wave = 10
	spawn_enemy_count = 0

	gold = 10

func _ready() -> void:
	randomize()
	reset()

func _process(delta: float) -> void:
	pass

func current_enemy_health() -> int:
	return current_wave * 100 + ((current_wave - 1) * 25)

func choose(array: Array) -> Variant:
	array.shuffle()
	return array.front()

func enemy_killed() -> void:
	spawned_enemies -= 1
	gold += 1

	if spawned_all_enemies and spawned_enemies <= 0:
		current_wave += 1
		spawned_enemies = 0

func reset_highlight() -> void:
	if highlighted_tower:
		highlighted_tower.get_node('Highlight').visible = false
		highlighted_tower.get_node('AttackRange').get_node('AreaMesh').visible = false
	highlighted_tower = null

func highlight_tower(tower: Area3D) -> void:
	highlighted_tower = tower
	tower.get_node('Highlight').visible = true
	tower.get_node('AttackRange').get_node('AreaMesh').visible = true

# test
func _unhandled_input(event):
	if Input.is_action_just_pressed("f1"):
		if highlighted_tower:
			highlighted_tower.upgrade()
			reset_highlight()
