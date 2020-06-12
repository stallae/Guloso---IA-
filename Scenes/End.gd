extends Node2D

onready var grid = get_parent()
onready var resultado = get_node("textoResultado")

func _ready():
	print(grid)
	var resultadoIa = counter(grid.astar_path)
	var resultadoPlayer = grid.player_movements 
	var placar = " Placar: " + str(resultadoPlayer) + " contra " + str(resultadoIa) + " da IA."
	if(resultadoPlayer <= resultadoIa):
		resultado.text = "Resultado: Voce ganhou da nossa IA!!!" + str(placar)
	else:
		resultado.text = "Resultado: Voce perdeu da nossa IA!!!" + str(placar) 



func counter(array) -> int:
	var result = 0
	for i in range(array.size()):
		for j in array[i]:
			result += 1
	return result
