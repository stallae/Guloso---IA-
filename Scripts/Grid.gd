extends TileMap

enum TILE_TYPE {EMPTY, PLAYER, OBSTACLE, COIN}


var tile_size: Vector2 = get_cell_size()
var half_tile_size: Vector2 = tile_size / 2

var grid_size = Vector2(16,10)
var grid: Array = []

export var obstacle_quantity: int
export var coin_quantity: int = 1

onready var Obstacle = preload("res://Scenes/Obstacle.tscn")
onready var Coin = preload("res://Scenes/Coin.tscn")
onready var Player = preload("res://Scenes/Player.tscn")

onready var label = get_parent().get_node("Label")

var open = []
var closed = []
var start
var end


func _ready():
	
	label.text = "MOEDAS RESTANTES: " + str(coin_quantity)
	#Cria matriz da grid
	for x in range(grid_size.x):
		grid.append([])
# warning-ignore:unused_variable
		for y in range(grid_size.y):
			grid[x].append(TILE_TYPE.EMPTY)
	randomize()
	#Cria obstaculos
	var positions: Array = []
# warning-ignore:unused_variable
	for n in range(obstacle_quantity):
		var grid_position = Vector2(randi() % int(grid_size.x), randi() % int(grid_size.y))
		if not grid_position in positions:
			positions.append(grid_position)
	
	for pos in positions:
		var new_obstacle = Obstacle.instance()
		new_obstacle.position = map_to_world(pos) + half_tile_size
		grid[pos.x][pos.y] = TILE_TYPE.OBSTACLE
		add_child(new_obstacle)
		
		
	positions = []
	#Cria moedas
	for n in range(coin_quantity):
		var grid_position = Vector2(randi() % int(grid_size.x), randi() % int(grid_size.y))
		if not grid_position in positions:
			positions.append(grid_position)
	
	for pos in positions:
		var new_obstacle = Coin.instance()
		new_obstacle.position = map_to_world(pos) + half_tile_size
		end = pos
		grid[pos.x][pos.y] = TILE_TYPE.COIN
		add_child(new_obstacle)
		
	#Cria player
	var player_pos: Vector2 = Vector2(randi() % int(grid_size.x), randi() % int(grid_size.y))
	while player_pos in positions:
		player_pos = Vector2(randi() % int(grid_size.x), randi() % int(grid_size.y))
		

	var new_player = Player.instance()
	new_player.connect("area_entered", self, "_on_Area2D_area_entered")
	new_player.position = map_to_world(player_pos) + half_tile_size
	grid[player_pos.x][player_pos.y] = TILE_TYPE.PLAYER
	start = player_pos
	add_child(new_player)
	a_star()

func a_star():
	# {'x': 1, 'y': 2, 'heuristic': '5', 'left': -1, 'right': -1, 'up': -1, 'down': -1}
	var first_node = {'x': start.x, 'y': start.y, 'heuristic': 0}
	open.append(first_node)

	if(open.size() == 0):
		print('sem solucao')
	else:
		while(open.size() > 0):
			var lowest = 0
			for i in open.size():
				if open[i]['heuristic'] < open[lowest]['heuristic']:
					lowest = i

			var current = open[lowest]

			if current['x'] == end.x:
				if current['y'] == end.y:
					print('ACABOU!')

			closed.append(current) 
			open.erase(current)

			#adicionar vizinhos para cada elemento da grid

func heuristic(a, b):
	pass

func is_cell_vacant(pos, direction) -> bool:
	#retorna se uma posiço esta vazia 
	var grid_pos = world_to_map(pos) + direction
	if grid_pos.x < grid_size.x and grid_pos.x >= 0:
		if grid_pos.y < grid_size.y and grid_pos.y >= 0:
			return true if grid[grid_pos.x][grid_pos.y] == TILE_TYPE.EMPTY || grid[grid_pos.x][grid_pos.y] == TILE_TYPE.COIN else false
	return false

func update_child_position (child_node, direction) -> Vector2:
	#Move um no filho para uma nova posiço no grid
	#Retorna a nova posiço global do no filho
	var grid_pos = world_to_map(child_node.position)
	print(grid_pos)
	grid[grid_pos.x][grid_pos.y] = TILE_TYPE.EMPTY
	
	var new_grid_pos = grid_pos + direction
	grid[new_grid_pos.x][new_grid_pos.y] = TILE_TYPE.PLAYER
	
	var target_pos = map_to_world(new_grid_pos) + half_tile_size
	return target_pos

func remove_coin_from_grid(coin) -> void:
	var pos = world_to_map(coin.position)
	grid[pos.x][pos.y] = TILE_TYPE.EMPTY
	coin_quantity -= 1
	label.text = "MOEDAS RESTANTES: " + str(coin_quantity)
	print(grid)

func _on_Area2D_area_entered(area):
	remove_coin_from_grid(area)
	area.queue_free()

