extends Node2D

onready var nav : Navigation2D = $Ambiente

var caminho : PoolVector2Array
var objetivo : Vector2
export var velocidade := 250

func _input(event: InputEvent):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			objetivo = event.position
			caminho = nav.get_simple_path($Agente.position, objetivo, false)
			print(caminho)
			$Linha.points = PoolVector2Array(caminho)
			$Linha.show()


func _process(delta: float) -> void:
	if !caminho:
		$Linha.hide()
		return
	if caminho.size() > 0:
		var d: float = $Agente.position.distance_to(caminho[0])
		if d > 10:
			$Agente.position = $Agente.position.linear_interpolate(caminho[0], (velocidade * delta)/d)
		else:
			caminho.remove(0)
