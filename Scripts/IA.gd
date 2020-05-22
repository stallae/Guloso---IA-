extends Area2D

var grid
onready var ray: RayCast2D = $"SensorDeColisao"
onready var tween: Tween = $Tween
var path : Array = Array()
var velocidade: float = 3.0

func play_solution():
	grid = get_parent()
	path = grid.astar_path
	set_path()

func set_path():
	for i in path.size():
		for m in path[i].size():
			move(path[i][m])
			yield(tween, "tween_completed")

func move(node) -> void:
	tween.interpolate_property(self, "position", position,
	grid.map_to_world(node)+grid.half_tile_size, 1.0/velocidade, Tween.TRANS_LINEAR,
	Tween.EASE_IN_OUT)
	tween.start()
