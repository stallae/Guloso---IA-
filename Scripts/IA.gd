extends Area2D

var grid
onready var ray: RayCast2D = $"SensorDeColisao"
onready var tween: Tween = $Tween
var path : Array = Array()
var velocidade: float = 3.0
var counter : int = 0
var ready : bool = false

func play_solution():
	grid = get_parent()
	counter += 1
	if counter == grid.NUM_COINS:
		ready = true

	if ready == true:
		path = grid.astar_path
		print("A IA vai andar agora!!")
		#set_path()

#Colocar a conexão no TileMap
#Astar.connect("calculated", new_player, "play_solution")

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
