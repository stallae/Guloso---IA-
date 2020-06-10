extends Node2D

# Variáveis globais
onready var tileMap: TileMap = $Navigation2D/TileMap
var open : Array = Array()
var closed : Array = Array()
var start
var end
var grid
var horrible: int = 0


# Ela passa os valores das listas open, closed, e caminho ótimo para os vetores
func a_star_done(path, admissible):
	$Timer.stop()
	
	if admissible == true:
		get_node("Navigation2D/TileMap").astar_path.append(path)
		get_node("Navigation2D/TileMap").open_set.append(open)
		get_node("Navigation2D/TileMap").closed_set.append(closed)

	if admissible == false:
		get_node("Navigation2D/TileMap").astar_path_wrong.append(path)
		get_node("Navigation2D/TileMap").open_set_wrong.append(open)
		get_node("Navigation2D/TileMap").closed_set_wrong.append(closed)
	

# Função do algoritmo A*
func _a_star(admissible):
	$Timer.start()
	# Inicialização das variáveis
	start = get_node("Navigation2D/TileMap").start
	end = get_node("Navigation2D/TileMap").end
	grid = get_node("Navigation2D/TileMap").grid
	open.clear()
	closed.clear()

	# Adicionando o primeiro nó sendo o nó atual do jogador e adicionando a lista open
	var start_node = {'x': start.x, 'y': start.y, 'heuristic': 0, 'g': 0, 'previous': Vector2(-1, -1), 'f': 0}
	open.append(start_node)

	# Loop principal. Enquanto houver nós na lista open, será executado
	while(open.size() > 0):

		# Seleciona a posição do vetor open com o nó de menor função heurística
		# Se houverem nós empatados, o selecionado será o nó que foi adicionado primeiro na lista
		var lowest = 0
		for i in open.size():
			if open[i]['f'] < open[lowest]['f']:
				lowest = i
		var current = open[lowest]

		# Verificação se o nó atual é o nó objetivo
		if current['x'] == end.x:
			if current['y'] == end.y:
				var path = reconstruct_path(current)
				print_open_and_closed()
				a_star_done(path, admissible)

		# Retira o nó atual do open e o adiciona no closed
		open.erase(current)
		closed.append(current)

		# Adiciona os vizinhos do nó atual ao vetor 'neighbors'
		var neighbors = []
		neighbors = set_neighbors(current, admissible)

		# Loop para cada vizinho do nó atual
		for i in neighbors.size():

			# Se o vizinho não estiver na lista de closed
			if not check_neighbor_in(closed,neighbors[i]):
				var x = neighbors[i]['x']
				var y = neighbors[i]['y']

				# Se o vizinho não for um obstáculo
				if (grid[x][y] != 2):

					# Calcula o valor temporário de g(x) (é o valor g que custaria ir até o nó)
					var temp_g = current['g'] + 1

					# Se o valor temporário de g(x) for menor ou igual ao valor g(x) do nó
					if temp_g <= neighbors[i]['g']:
						# Se entrar aqui, isso quer dizer que esse é o menor caminho até o nó

						# Seta os valores do vizinho
						neighbors[i]['previous'] = current
						neighbors[i]['g'] = temp_g
						neighbors[i]['f'] = neighbors[i]['g'] + neighbors[i]['heuristic']

						# Se o vizinho ainda não tiver sido adicionado ao open
						if not check_neighbor_in(open, neighbors[i]):
							open.append(neighbors[i])

	# Se chegar nesse retorno, não há solução (não há caminho do ponto inicial ao objetivo)
	return 1


# Função que calcula os vizinhos do nó atual
func set_neighbors(current, admissible):
	var grid_size = get_node("Navigation2D/TileMap").grid_size
	var values : Array = Array()
	var point : Vector2 = Vector2()
	var heuristic : int = 0
	var g : int = 1
	
	# Se não tiver colado na parte superior:
	if current['y'] > 0:
		# Adicionar vizinho de cima
		point = Vector2(current['x'], current['y']-1)
		heuristic = heuristic(point, admissible)
		g = current['g'] + g
		values.push_back({'x': point.x, 'y': point.y, 'heuristic': heuristic, 'g': g})

	# Se não tiver colado no canto direito da grid:
	if current['x'] < grid_size.x - 1:
		# Adicionar vizinho da direita
		point = Vector2(current['x']+1, current['y'])
		heuristic = heuristic(point, admissible)
		g = current['g'] + g
		values.push_back({'x': point.x, 'y': point.y, 'heuristic': heuristic, 'g': g})

	# Se não tiver colado na parte inferior:
	if current['y'] < grid_size.y - 1:
		# Adicionar vizinho de baixo
		point = Vector2(current['x'], current['y']+1)
		heuristic = heuristic(point, admissible)
		g = current['g'] + g
		values.push_back({'x': point.x, 'y': point.y, 'heuristic': heuristic, 'g': g})

	# Se não tiver colado no canto esquerdo da grid:
	if current['x'] > 0:
		# Adicionar vizinho da esquerda
		point = Vector2(current['x']-1, current['y'])
		heuristic = heuristic(point, admissible)
		g = current['g'] + g
		values.push_back({'x': point.x, 'y': point.y, 'heuristic': heuristic, 'g': g})

	# Retorna a lista de vizinhos do nó atual
	return values


# Reconstroi o caminho ótimo calculado pelo A*
func reconstruct_path(current):
	var path = []
	while !(current['previous'] is Vector2):
		path.push_front(Vector2(current['x'], current['y']))
		var temp = current['previous']
		current = temp
	return path


# Calculo da função heurística (h(x))
func heuristic(next, admissible):
	
	# Se for a heuristica admissivel
	if admissible == true:
		# Obtem a direcao da posicao atual ate a posicao final
		var dx1 = next.x - end.x
		var dy1 = next.y - end.y

		# Obtem a direcao do no inicial ate o no final
		var dx2 = start.x - end.x
		var dy2 = start.y - end.y

		# Calcula o produto vetorial absoluto entre a d1 e a d2
		var cross = abs(dx1*dy2 - dx2*dy1)

		# Calcula a distancia do no inicial ate o no final utilizando Manhattan
		var heuristic = (abs(next.x - end.x) + abs(next.y - end.y))

		# Ajusta a heuristica com 1 centesimo do tie-breaker.
		heuristic += cross*0.001
		return heuristic

	# Se for a heuristica não admissivel
	elif admissible == false:
		var heuristic = abs(next.x - end.x) + abs(next.y - end.y)
		var overload = randi() % 100 + 1
		
		return heuristic * (overload * overload)


# Se o botão restart for ativado
func _on_Button_pressed():
	tileMap.generate_grid_with_all_entities(true)


#Checa se a posicao esta em uma dada lista. *Ex: Checar se pos (1,1) esta na lista open
func check_neighbor_in(list, neighbor):
	for item in list:
		if neighbor['x'] == item['x']:
			if neighbor['y'] == item['y']:
				return true
	return false
  
func create_vector2_array_path(dict):
	var array = []
	for item in dict:
		array.append(Vector2(item['x'], item['y']))
	return array
	
func print_open_and_closed():
	print("----------------------------------OPEN---------------------------------")
	print(create_vector2_array_path(open))
	print("---------------------------------CLOSED--------------------------------")
	print(create_vector2_array_path(closed))
