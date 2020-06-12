extends TileMap
# Variaveis globais
enum TILE_TYPE {EMPTY, PLAYER, OBSTACLE, COIN}
onready var line = $Line2D
onready var button = get_parent().get_parent().get_node("CameraLonge/Popup/Button")
var tile_size: Vector2 = get_cell_size()
var half_tile_size: Vector2 = tile_size / 2
var grid_size = Vector2(32,20)
var grid: Array = []
var astar_path : Array = Array()
var open_set : Array = Array()
var closed_set : Array = Array()
var astar_path_wrong : Array = Array()
var open_set_wrong : Array = Array()
var closed_set_wrong : Array = Array()
export var obstacle_quantity: int
export var coin_quantity: int = 3
var NUM_COINS = coin_quantity
var realCoinQuantity = coin_quantity
onready var Astar = get_node("/root/Grid")
onready var Obstacle = preload("res://Scenes/Obstacle.tscn")
onready var Coin = preload("res://Scenes/Coin.tscn")
onready var Player = preload("res://Scenes/Player.tscn")
onready var IA = preload("res://Scenes/IA.tscn")
onready var End = preload("res://Scenes/End.tscn")
onready var Debug = preload("res://Scenes/Debug.tscn")
onready var camera_longe = get_parent().get_parent().get_node("CameraLonge")
onready var camera_perto : Camera2D
var end_scene
var obstacles_in_scene = []
var player_in_scene
var agent_in_scene
var coin_in_scene
var debug_in_scene
var pos_IA_init
onready var label = get_parent().get_parent().get_node("CameraLonge/Control/Label")
var start : Vector2 = Vector2()
var end : Vector2 = Vector2()
var pos_moedas: Array = [] #posições de 0 a 2
var moedas_pegas = 0
var first_player_position
var which_path : bool
var final_tree : Array = []

var player_movements : int = 0
var can_switch_camera = false
onready var cameraEnd = get_parent().get_parent().get_node("CameraEnd")
onready var popup = get_parent().get_parent().get_node("CameraLonge/Popup")
var camera_atual
# Função que é chamada quando o node é instanciado na cena
func _ready():
	generate_grid_with_all_entities(false)

func _input(event):
	if event.is_action_pressed("mouse"):
		if can_switch_camera and not popup.visible:
			change_camera()
	if event.is_action_pressed("esc") and can_switch_camera:
		if camera_longe.current: 
			camera_atual = camera_longe 
		elif camera_perto.current: 
			camera_atual = camera_perto
		if not cameraEnd.is_current() || popup.visible:
			if popup.visible: 
				cameraEnd.current = false
				camera_atual.current = true
			else: cameraEnd.current = true
			popup.visible = not popup.visible

# Função de criar moedas na grid
func criar_moeda():
	var positions: Array = []
	var grid_position = pos_moedas[moedas_pegas]
	positions.append(grid_position)
	for pos in positions:
		var moeda = Coin.instance()
		coin_in_scene = moeda
		moeda.position = map_to_world(pos) + half_tile_size
		grid[pos.x][pos.y] = TILE_TYPE.COIN
		get_parent().call_deferred("add_child",moeda)
		moedas_pegas=moedas_pegas+1


# Função que chama o A*
func start_pathfinding():
	var admissible = true
	for j in range(2):
		start = first_player_position
		if j == 1:
			admissible = false
		for i in range(NUM_COINS):
			if i > 0:
				start = pos_moedas[i-1]
			end = pos_moedas[i]
			get_node("/root/Grid")._a_star(admissible)


# Verificação se a célula da grid é vazia
func is_cell_vacant(pos, direction) -> bool:
	var grid_pos = world_to_map(pos) + direction
	if grid_pos.x < grid_size.x and grid_pos.x >= 0:
		if grid_pos.y < grid_size.y and grid_pos.y >= 0:
			return true if grid[grid_pos.x][grid_pos.y] == TILE_TYPE.EMPTY || grid[grid_pos.x][grid_pos.y] == TILE_TYPE.COIN else false
	return false


# Função que move um no filho para uma nova posiçao no grid
# Retorna a nova posiçao global do no filho
func update_child_position (child_node, direction) -> Vector2:
	var grid_pos = world_to_map(child_node.position)
	grid[grid_pos.x][grid_pos.y] = TILE_TYPE.EMPTY

	var new_grid_pos = grid_pos + direction
	grid[new_grid_pos.x][new_grid_pos.y] = TILE_TYPE.PLAYER

	var target_pos = map_to_world(new_grid_pos) + half_tile_size
	player_movements += 1
	
	return target_pos

func appending(path, s):
	if s == "open":
		open_set.append(path)
	elif s == "closed":
		closed_set.append(path)
	elif s == "astar_path":
		astar_path.append(path)
	elif s == "open_wrong":
		open_set_wrong.append(path)
	elif s == "closed_wrong":
		closed_set_wrong.append(path)
	elif s == "astar_wrong":
		astar_path_wrong.append(path)
	
# Função que remove as moedas da grid
func remove_coin_from_grid(coin) -> void:
	var pos = world_to_map(coin.position)
	if (coin_quantity>1):
		criar_moeda()
	else:
		end_scene = End.instance()
		camera_longe.current = false
		cameraEnd.current = true
		if is_instance_valid(player_in_scene):
			player_in_scene.queue_free()
			can_switch_camera = false

		if is_instance_valid(agent_in_scene):
			save()
			final_tree.clear()
			agent_in_scene.queue_free()
		else:
			start_pathfinding()
		
		if is_instance_valid(debug_in_scene):
			debug_in_scene.queue_free()
	
		button.disabled = true
		add_child(end_scene)

	grid[pos.x][pos.y] = TILE_TYPE.PLAYER
	coin_quantity -= 1



func _on_Area2D_area_entered(area):
	coin_in_scene.play_animation_and_queue_free()
	remove_coin_from_grid(area)
	
# Função de criação do jogador
func create_player(): 
	player_movements = 0
	var player_pos: Vector2 = Vector2(randi() % int(grid_size.x), randi() % int(grid_size.y))
	pos_IA_init = player_pos
	player_in_scene = Player.instance()
	can_switch_camera = true
	player_in_scene.connect("area_entered", self, "_on_Area2D_area_entered")
	player_in_scene.position = map_to_world(player_pos) + half_tile_size
	camera_perto = player_in_scene.get_node("Camera2D")
	camera_perto.current = true
	grid[player_pos.x][player_pos.y] = TILE_TYPE.PLAYER
	first_player_position = player_pos
	start = first_player_position
	add_child(player_in_scene)


# Função de criação dos obstáculos
func create_obstacles(positions):
	var aux = 0
	while aux != obstacle_quantity:
		var grid_position = Vector2(randi() % int(grid_size.x), randi() % int(grid_size.y))
		if grid[grid_position.x][grid_position.y] == TILE_TYPE.EMPTY:
			positions.append(grid_position)
			aux += 1

	for pos in positions:
		var new_obstacle = Obstacle.instance()
		new_obstacle.position = map_to_world(pos) + half_tile_size
		grid[pos.x][pos.y] = TILE_TYPE.OBSTACLE
		add_child(new_obstacle)
		obstacles_in_scene.append(new_obstacle)


# Função de criação das posições em que as moedas devem ser instanciadas
func create_coins_positions():
	pos_moedas = []
	var aux = 0
	while(aux != realCoinQuantity):
		var rand_pos = Vector2(randi() % int(grid_size.x), randi() % int(grid_size.y))
		if grid[rand_pos.x][rand_pos.y] == TILE_TYPE.EMPTY:
			pos_moedas.append(rand_pos)
			aux += 1


# Função que gera a grid vazia
func generate_empty_grid():
	var alternatecell = false
	
	for x in range(grid_size.x):
		grid.append([])
		for y in range(grid_size.y):
			grid[x].append(TILE_TYPE.EMPTY)
			if alternatecell :
				set_cell(x,y,3)
			else:
				set_cell(x,y,2)
			alternatecell = not alternatecell
		alternatecell = not alternatecell


# Função de reinicio da grid (limpa as instancias)
func clear_grid():
	player_in_scene.queue_free()
	for obstacle in obstacles_in_scene:
		obstacle.queue_free()

	obstacles_in_scene = []
	coin_quantity = realCoinQuantity
	if is_instance_valid(coin_in_scene): coin_in_scene.play_animation_and_queue_free()
	moedas_pegas = 0

	for x in range(grid_size.x):
		for y in range(grid_size.y):
			grid[x][y] = TILE_TYPE.EMPTY
	clear_paths()


# Função que gera as entidades da grid
func generate_grid_with_all_entities(restart):
	if restart:
		clear_grid()
	else: generate_empty_grid()
	var positions: Array = []
	create_player()
	randomize()
	create_obstacles(positions)
	randomize()
	create_coins_positions()
	randomize()
	criar_moeda()


# Função de instanciação do agente
func instance_ia(admissible):
	camera_longe.current = true
	generate_empty_grid()
	agent_in_scene = IA.instance()
	agent_in_scene.connect("area_entered", self, "_on_Area2D_area_entered")
	agent_in_scene.position = map_to_world(pos_IA_init) + half_tile_size
	grid[pos_IA_init.x][pos_IA_init.y] = TILE_TYPE.PLAYER
	add_child(agent_in_scene)

	moedas_pegas = 0
	coin_quantity = NUM_COINS
	criar_moeda()
	
	instance_debug(admissible)
	show_path(admissible)
	get_node("IA").play_solution(admissible)


func instance_debug(admissible):
	debug_in_scene = Debug.instance()
	which_path = admissible
	add_child(debug_in_scene)


# Função que mostra o caminho ótimo
func show_path(admissible):
	
	line.clear_points()
	if admissible == true:
		for i in astar_path.size():
			for m in astar_path[i].size():
				line.add_point(map_to_world(Vector2(astar_path[i][m])) + Vector2(32,32))
	else:
		for i in astar_path_wrong.size():
			for m in astar_path_wrong[i].size():
				line.add_point(map_to_world(Vector2(astar_path_wrong[i][m])) + Vector2(32,32))


# Função que limpa os vetores do A*
func clear_paths() -> void:
	astar_path.clear()
	open_set.clear()
	closed_set.clear()
	astar_path_wrong.clear()
	open_set_wrong.clear()
	closed_set_wrong.clear()


func generate_open_set(path):
	for i in path.size():
		var nodes = get_node("/root/Grid").create_vector2_array_path(path[i])
		for j in nodes.size():
			set_cell(nodes[j].x, nodes[j].y, 5)


func generate_closed_set(path):
	for i in path.size():
		var nodes = get_node("/root/Grid").create_vector2_array_path(path[i])
		for j in nodes.size():
			set_cell(nodes[j].x, nodes[j].y, 4)


func append_to_tree():
	for k in range(grid_size.x):
			final_tree.append("=")
	final_tree.append("\n")
	for i in range(grid_size.y):
		for j in range(grid_size.x):
			final_tree.append(grid[j][i])
		final_tree.append("\n")


func save():
	var file = File.new()
	var status = file.open("res://arvore.txt", File.WRITE)
	if status != 0:
		print("Erro ao escrever no arquivo, o erro foi: ", status)
	var info = str(TILE_TYPE.EMPTY) + " é vazio, " + str(TILE_TYPE.PLAYER) + " é o jogador, "  + str(TILE_TYPE.OBSTACLE) + " são os obstáculos, " + str(TILE_TYPE.COIN) + " é o hamburguer."
	file.store_string(str(info) + "\n" + str(final_tree))
	file.close()
func change_camera() -> void:
	if camera_perto.current:
		camera_longe.current = true
	else:
		camera_perto.current = true
		
func get_direction(node):
	return (node - world_to_map(agent_in_scene.position)).normalized()

func _on_Button2_pressed():
	get_tree().quit()
