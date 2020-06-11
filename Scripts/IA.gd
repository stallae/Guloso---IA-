extends Area2D

# Variáveis globais
var grid
onready var ray: RayCast2D = $"SensorDeColisao"
onready var tween: Tween = $Tween
var path : Array = Array()
var velocidade: float = 3.0
var counter : int = 1
var coins


# Função define qual será o caminho andado pela IA (admissivel ou não)
func play_solution(admissible):
	grid = get_parent()
	if admissible == true:
		path = grid.astar_path
	else:
		path = grid.astar_path_wrong
	set_path()


# Função que envia as coordenadas que a IA deve passar (path retornado pelo A*)
func set_path():
	for i in path.size():
		for m in path[i].size():
			grid.append_to_tree()
			move(path[i][m])
			yield(tween, "tween_completed")


# Função que movimenta a IA na grid
func move(node) -> void:
	var status = tween.interpolate_property(self, "position", position,
	grid.update_child_position(self, grid.get_direction(node)), 1.0/velocidade, Tween.TRANS_LINEAR,
	Tween.EASE_IN_OUT)
	
	if not status == true:
		print("Algum erro ocorreu no interpolate")
	status = tween.start()
	if not status == true:
		print("Algum erro ocorreu no tween.start()")
