extends Area3D

var pos

var target
var is_aware = false

var current_level = 0
var damage = 0
var levels = []
var damages_per_level = []

func attackRangeAreaEntered(area):
	if area.is_in_group('enemy') and !is_instance_valid(target):
		target = get_new_target()

func attackRangeAreaExited(area):
	if area.is_in_group('enemy') and (area == target or !is_instance_valid(target)):
		target = get_new_target()

func get_new_target():
	var current_target = null
	var target_min_length = 0

	for area in $AttackRange.get_overlapping_areas():
		if area.is_in_group('enemy') and area != target:
			if !current_target or (area.global_position - self.global_position).length() < target_min_length:
				current_target = area
				target_min_length = (area.global_position - self.global_position).length()

	return current_target

func upgrade():
	if levels.size() > current_level:
		current_level += 1
		get_node(levels[current_level - 2]).visible = false
		get_node(levels[current_level - 1]).visible = true
		damage = damages_per_level[current_level - 1]
