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
	var cell = get_cell(1,1)
	
func a_star():
	var first_node = {'x': start.x, 'y': start.y, 'heuristic': 0, 'g': 0, 'previous': Vector2(-1, -1), 'f': 0}
	open.append(first_node)

	while(open.size() > 0):
		var lowest = 0
		for i in open.size():
			if open[i]['f'] < open[lowest]['f']:
				lowest = i

		var current = open[lowest]
		
		if current['x'] == end.x:
			if current['y'] == end.y:
				for item in open:
					set_cell(item['x'], item['y'], 3)
				for item in closed:
					set_cell(item['x'], item['y'], 2)
				return reconstruct_path(current)
		
		
		closed.append(current)
		open.erase(current)

		#adicionar custo dos vizinhos para cada elemento da grid
		var neighbors = []
		neighbors = set_neighbors(current)
		
		for i in neighbors.size():
			var x = neighbors[i]['x']
			var y = neighbors[i]['y']
			if (grid[x][y] != 2):
				var temp_g = current['g'] + 1
				if temp_g <= neighbors[i]['g']:
					neighbors[i]['previous'] = current
					neighbors[i]['g'] = temp_g
					neighbors[i]['f'] = neighbors[i]['g'] + neighbors[i]['heuristic']
					if !(neighbors[i] in open):
						open.append(neighbors[i])

	print('SEM SOLUCAO')
	return 1 #sem solucao
func set_neighbors(current):
	var values = []
	var point = Vector2()
	var heuristic = 0
	var g = 0
	var i = 0
	if current['y'] > 0:
		# Adicionar vizinho de cima
		point = Vector2(current['x'], current['y']-1)
		heuristic = heuristic(point, end)
		g = current['g'] + 1
		values.push_back({'x': point.x, 'y': point.y, 'heuristic': heuristic, 'g': g})

	if current['x'] < grid_size.x - 1:
		# Adicionar vizinho da direita
		point = Vector2(current['x']+1, current['y'])
		heuristic = heuristic(point, end)
		g = current['g'] + 1
		values.push_back({'x': point.x, 'y': point.y, 'heuristic': heuristic, 'g': g})

	if current['y'] < grid_size.y - 1:
		# Adicionar vizinho de baixo
		point = Vector2(current['x'], current['y']+1)
		heuristic = heuristic(point, end)
		g = current['g'] + 1
		values.push_back({'x': point.x, 'y': point.y, 'heuristic': heuristic, 'g': g})

	if current['x'] > 0:
		# Adicionar vizinho da esquerda
		point = Vector2(current['x']-1, current['y'])
		heuristic = heuristic(point, end)
		g = current['g'] + 1
		values.push_back({'x': point.x, 'y': point.y, 'heuristic': heuristic, 'g': g})
	
	return values

func reconstruct_path(current):
	var path = []
	while !(current['previous'] is Vector2):
		path.push_front(Vector2(current['x'], current['y']))
		var temp = current['previous']
		current = temp
	print(path)
	return path
	
func heuristic(next, goal):
	return abs(next.x - goal.x) + abs(next.y - goal.y)

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

