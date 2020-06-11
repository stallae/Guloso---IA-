extends Button

onready var grid = get_parent().get_parent()

func _on_Button_toggled(button_pressed):
	if button_pressed == true:
		var option = grid.which_path
		if option == true:
			var open = grid.open_set
			var closed = grid.closed_set
			grid.generate_open_set(open)
			grid.generate_closed_set(closed)
		else:
			var open = grid.open_set_wrong
			var closed = grid.closed_set_wrong
			grid.generate_open_set(open)
			grid.generate_closed_set(closed)
	else:
		grid.generate_empty_grid()
