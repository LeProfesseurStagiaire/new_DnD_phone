extends Node2D

var sprites = []
var last_z_index = 0
var last_node_dragged = null

signal drag_node

func _add_sprite(sprt):
	sprites.append(sprt)
	select_draggable_node()

func _remove_sprite(sprt): 
	sprites.remove(sprites.find(sprt)) 
	select_draggable_node()

func drag_node(node):
	if last_node_dragged != node:
		var z = last_z_index + 3
		node.z_index = z
		last_z_index = z
		last_node_dragged = node

class sorter:
	static func sort(a, b):
		if a[0] > b[0]:
			return true
		return false

func select_draggable_node():
	var search_node = []
	for x in sprites:
		search_node.append([x.z_index,x])
	search_node.sort_custom(sorter, "sort")
	if search_node.size() >0:
		if search_node.size()>1:
			emit_signal("drag_node",search_node[0][1],search_node[1][1])
		else:
			emit_signal("drag_node",search_node[0][1],null)
	else:
		emit_signal("drag_node",null,null)