extends Area2D

# Variáveis globais

# Referência para o nó de RayCast
onready var ray: RayCast2D = $"SensorDeColisão"
onready var debugRay: Line2D = $Sprite/Line2D
onready var debugTimer: Timer = $Sprite/Line2D/Timer
onready var tween: Tween = $Tween
var grid
export var debugMode = false



#Tamanho de cada tile do GRID
export var tile_size: int = 64 #Alterar conforme tamanho das tiles
var velocidade: float = 3.0
var type

# Possíveis movimentações do usuário
var inputs: Dictionary = {
	"ui_right": Vector2.RIGHT,
	"ui_left": Vector2.LEFT,
	"ui_up": Vector2.UP,
	"ui_down": Vector2.DOWN,
}


# Função que é iniciada quando o node é instanciado na cena
func _ready() -> void:
	grid = get_parent()


# Função que trata os eventos gerados pelo usuário
func _unhandled_input(event) -> void:
	if tween.is_active():
		return
	for dir in inputs.keys():
		if event.is_action_pressed(dir):
			if dir == "ui_left":
				$Sprite.flip_h = true
			if dir == "ui_right":
				$Sprite.flip_h = false
			move(dir)


# Função de movimentação do player
func move(dir) -> void:
	if(!is_colliding(dir)):
		tween.interpolate_property(self, "position", position,
		grid.update_child_position(self, inputs[dir]), 1.0/velocidade, Tween.TRANS_LINEAR,
		Tween.EASE_IN_OUT)
		tween.start()


# Função de checagem de colisões
func is_colliding(dir) -> bool:
	if(debugMode):
		debugRay.add_point(Vector2.ZERO)
		debugRay.add_point(inputs[dir] * tile_size)
		debugTimer.start(0.3)
	ray.cast_to = inputs[dir] * tile_size
	ray.force_raycast_update()
	if grid.is_cell_vacant(position, inputs[dir]):
		return false
	else:
		return true

func remove_line_points() -> void: 
	debugRay.points = []

func _on_Timer_timeout():
	remove_line_points()
