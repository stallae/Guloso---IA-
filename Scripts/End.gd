extends Button
var node;

func _on_Path_pressed():
	node = get_parent().get_parent()
	node.instance_ia()
	node.end_scene.queue_free()
	pass # Replace with function body.
	



func _on_Next_Level_pressed():
	get_tree().change_scene("res://Scenes/Grid.tscn")
	get_tree().paused = false
	pass # Replace with function body.
