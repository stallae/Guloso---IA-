extends Button


# Se o botão iniciar for selecionado
func _on_Iniciar_pressed():
	var status = get_tree().change_scene("res://Scenes/Grid.tscn")
	if status == 0:
		print("Cena trocada com sucesso")
	else:
		print("Erro inesperado ocorreu na troca de cenas")
