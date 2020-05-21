extends Node2D

var open : Array = Array()
var closed : Array = Array()
var thread = Thread.new()

func _start_a_star():
	thread.start(self, "_a_star")

func _a_star_done():
	var path = thread.wait_to_finish()
	var final_result = [path, open, closed]
	get_node("Navigation2D/TileMap").astar_path.append(final_result)

func _a_star(userdata):
	var start = get_node("Navigation2D/TileMap").start
	var end = get_node("Navigation2D/TileMap").end
	var grid = get_node("Navigation2D/TileMap").grid
	
	var start_node = {'x': start.x, 'y': start.y, 'heuristic': 0, 'g': 0, 'previous': Vector2(-1, -1), 'f': 0}
	open.append(start_node)

	while(open.size() > 0):
		var lowest = 0
		for i in open.size():
			if open[i]['f'] < open[lowest]['f']:
				lowest = i
		var current = open[lowest]

		if current['x'] == end.x:
			if current['y'] == end.y:
				var path = reconstruct_path(current)
				call_deferred("_a_star_done")
				return path
				
		open.erase(current)
		closed.append(current)
		#adicionar custo dos vizinhos para cada elemento da grid
		var neighbors = []
		neighbors = set_neighbors(current, end)
		
		for i in neighbors.size():
			if not neighbors[i] in closed:
				var x = neighbors[i]['x']
				var y = neighbors[i]['y']
				if (grid[x][y] != 2):
					var temp_g = current['g'] + 1
					if temp_g <= neighbors[i]['g']:
						neighbors[i]['previous'] = current
						neighbors[i]['g'] = temp_g
						neighbors[i]['f'] = neighbors[i]['g'] + neighbors[i]['heuristic']
						if not neighbors[i] in open:
							open.append(neighbors[i])

	return 1 #sem solucao
func set_neighbors(current, end):
	var grid_size = get_node("Navigation2D/TileMap").grid_size
	var values : Array = Array()
	var point : Vector2 = Vector2()
	var heuristic : int = 0
	var g : int = 1
	var i : int = 0
	
	if current['y'] > 0:
		# Adicionar vizinho de cima
		point = Vector2(current['x'], current['y']-1)
		heuristic = heuristic(point, end)
		g = current['g'] + g
		values.push_back({'x': point.x, 'y': point.y, 'heuristic': heuristic, 'g': g})

	if current['x'] < grid_size.x - 1:
		# Adicionar vizinho da direita
		point = Vector2(current['x']+1, current['y'])
		heuristic = heuristic(point, end)
		g = current['g'] + g
		values.push_back({'x': point.x, 'y': point.y, 'heuristic': heuristic, 'g': g})

	if current['y'] < grid_size.y - 1:
		# Adicionar vizinho de baixo
		point = Vector2(current['x'], current['y']+1)
		heuristic = heuristic(point, end)
		g = current['g'] + g
		values.push_back({'x': point.x, 'y': point.y, 'heuristic': heuristic, 'g': g})

	if current['x'] > 0:
		# Adicionar vizinho da esquerda
		point = Vector2(current['x']-1, current['y'])
		heuristic = heuristic(point, end)
		g = current['g'] + g
		values.push_back({'x': point.x, 'y': point.y, 'heuristic': heuristic, 'g': g})
	
	return values

func reconstruct_path(current):
	var path = []
	while !(current['previous'] is Vector2):
		path.push_front(Vector2(current['x'], current['y']))
		# Obter o valor de path para pintar a Line2D
		#line.add_point(map_to_world(Vector2(current['x'], current['y'])) + half_tile_size)
		var temp = current['previous']
		current = temp
	return path
	
func heuristic(next, goal):
	return abs(next.x - goal.x) + abs(next.y - goal.y)

