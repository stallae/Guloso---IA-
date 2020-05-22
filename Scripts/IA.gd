extends Area2D

var grid
onready var ray: RayCast2D = $"SensorDeColisão"
onready var tween: Tween = $Tween
var path : Array = Array()
var velocidade: float = 3.0

func _ready() -> void:
	grid = get_parent()
	path = grid.astar_path
	set_path()

# Se o jogador clicar para ver a solução novamente, chamar essa função
func replay_solution():
	set_path()

func set_path():
	for i in path.size():
		if tween.is_active():
			pass
		#move(path[i])

func move(node) -> void:
	pass
	#tween.interpolate_property(self, "position", position,
	#grid.update_child_position(self, inputs[dir]), 1.0/velocidade, Tween.TRANS_LINEAR,
	#Tween.EASE_IN_OUT)
	#tween.start()
