extends Node2D

onready var grid = get_parent()
onready var resultado = get_node("textoResultado")

func _ready():
	print(grid)
	var resultadoIa = grid.astar_path.size()
	var resultadoPlayer = grid.player_movements 
	var placar = " Placar: " + str(resultadoPlayer) + " " + str(resultadoIa)
	if(resultadoPlayer <= resultadoIa):
		resultado.text = "Resultado: Voce ganhou da nossa IA!!!" + str(placar)
	else:
		resultado.text = "Resultado: Voce perdeu da nossa IA!!!" + str(placar) 
