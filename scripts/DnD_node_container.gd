extends Node2D

export(String) var group_node_expected
export(String, FILE) var base_node
var node_expected_on_shape = []
var can_get = false
var mouse_over = false
onready var main = get_tree().get_current_scene()

func _ready():
#	randomize()
#	var x = str(int(rand_range(1,4)))
	$s.texture = load("res://assets/computer_pieces/piece_"+group_node_expected+".png")
	if base_node:
		unparent(null,self)
	main.connect("drag_node",self,"another_node_is_dragged")
	self.z_index = get_parent().z_index
	var shape = $area/col.shape.duplicate()
	$area/col.shape = shape
	$area/col.shape.set_extents((($s.get_rect().size) * $s.scale) /2)

func another_node_is_dragged(node,second_node):
	if self == second_node or self == node:
		mouse_over = true
	else:
		mouse_over = false

func _on_Area2D_area_entered(area):
	if area.is_in_group(group_node_expected):
		if area.get_parent().z_index > get_parent().z_index :
			node_expected_on_shape.append(area.get_parent())
			area.get_parent().over_place = true

func _on_Area2D_area_exited(area):
	if area.is_in_group(group_node_expected):
		area.get_parent().over_place = false
		node_expected_on_shape.remove(node_expected_on_shape.find(area.get_parent()))

func _process(delta):
	self.z_index = get_parent().z_index + 1
	if node_expected_on_shape.size() > 0 && mouse_over:
		$s.modulate = Color(1,1,0,0.3)
		can_get = true
	else:
		$s.modulate = Color(0.6,0.6,0.6,0.3)
		can_get = false
	if Input.is_action_just_released("click") && can_get:
		for x in node_expected_on_shape:
			if x.last_node_dragged:
				unparent(x,self)
				return

func unparent(node_to_unparent,target):
	if !node_to_unparent:
		var source = load(base_node)
		var node = source.instance()
		target.add_child(node)
		node.placed(target)
	else:
		var node_group = node_to_unparent.piece_nb
		var old_z_index = node_to_unparent.z_index
		var old_size = node_to_unparent.scale
		if main.sprites.has(node_to_unparent):
			main._remove_sprite(node_to_unparent)
		node_to_unparent.queue_free()
		var source = load(node_to_unparent.get_filename())
		var node = source.instance()
		node.piece_nb = node_group
		target.add_child(node)
		node.placed(target)
		node.global_position = self.global_position
		node.z_index = old_z_index
		node.scale = old_size

func _on_Area2D_mouse_entered():
	main._add_sprite(self)

func _on_Area2D_mouse_exited():
	main._remove_sprite(self)
