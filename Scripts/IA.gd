extends Area2D

# Variáveis globais
var grid
onready var ray: RayCast2D = $"SensorDeColisao"
onready var tween: Tween = $Tween
var path : Array = Array()
var velocidade: float = 3.0


# Função que é chamada quando o sinal "calculated" é emitido
func play_solution():
	grid = get_parent()
	path = grid.astar_path
	set_path()


# Função que envia as coordenadas que a IA deve passar (caminho ótimo retornado pelo A*)
func set_path():
	for i in path.size():
		for m in path[i].size():
			move(path[i][m])
			yield(tween, "tween_completed")


# Função que movimenta a IA na grid
func move(node) -> void:
	tween.interpolate_property(self, "position", position,
	grid.map_to_world(node)+grid.half_tile_size, 1.0/velocidade, Tween.TRANS_LINEAR,
	Tween.EASE_IN_OUT)
	tween.start()
