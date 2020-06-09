extends Button

# Variáveis globais
var node;
onready var grid = get_parent().get_parent().get_parent().get_parent()

# Se o botão de ver solução for ativado
func _on_Path_pressed():
	node = get_parent().get_parent()
	node.instance_ia(true)
	node.end_scene.queue_free()


# Se o botão de próximo nível for ativado:
func _on_Next_Level_pressed():
	get_tree().change_scene("res://Scenes/Grid.tscn")
	get_tree().paused = false


func _on_Inadmissible_pressed():
	node = get_parent().get_parent()
	node.instance_ia(false)
	node.end_scene.queue_free()
