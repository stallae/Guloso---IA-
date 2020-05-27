extends Button

# Variáveis globais
var node;

# Se o botão de ver solução for ativado
func _on_Path_pressed():
	node = get_parent().get_parent()
	node.instance_ia()
	node.end_scene.queue_free()


# Se o botão de próximo nível for ativado:
func _on_Next_Level_pressed():
	get_tree().change_scene("res://Scenes/Grid.tscn")
	get_tree().paused = false
