extends Node3D

var maze_size
var sets = {}
var walls = []
var removed_walls = []
	
func setup_maze(size):
	maze_size = size
	place_outer_walls()
	place_floor_tiles()
	initialize_maze()
	generate_maze()
	visualize_maze()

func place_outer_walls():
	var wall_scene = preload("res://wall_instance.tscn")
	var material = preload("res://materials/wall_material.tres") # Load your saved material
	for i in range(maze_size):
		if i != 0:
			var wall_instance1 = wall_scene.instantiate()
			wall_instance1.get_node("MeshInstance3D").material_override = material
			wall_instance1.transform.origin = Vector3(i + 0.5, 1, 0)
			add_child(wall_instance1)
		if i != maze_size - 1:
			var wall_instance2 = wall_scene.instantiate()
			wall_instance2.get_node("MeshInstance3D").material_override = material
			wall_instance2.transform.origin = Vector3(i + 0.5, 1, -maze_size)
			add_child(wall_instance2)
		
	for i in range(maze_size):
		var wall_instance3 = wall_scene.instantiate()
		wall_instance3.get_node("MeshInstance3D").material_override = material
		var wall_instance4 = wall_scene.instantiate()
		wall_instance4.get_node("MeshInstance3D").material_override = material
		wall_instance3.transform.origin = Vector3(0, 1, -i - 0.5)
		wall_instance4.transform.origin = Vector3(maze_size, 1, -i - 0.5)
		wall_instance3.rotate(Vector3(0, 1, 0), PI / 2)
		wall_instance4.rotate(Vector3(0, 1, 0), PI / 2)
		add_child(wall_instance3)
		add_child(wall_instance4)

func initialize_maze_sets():
	for i in range(maze_size * maze_size):
		sets[i] = i

func initialize_maze():
	initialize_maze_sets()
	for i in range(maze_size):
		for j in range(maze_size):
			var n = i * maze_size + j  # Calculate the 1D index
			if j < maze_size - 1:  # Right neighbor
				walls.append(Vector2(n, n + 1))
			if i < maze_size - 1:  # Bottom neighbor
				walls.append(Vector2(n, n + maze_size))

func generate_maze():
	walls.shuffle()
	for wall in walls:
		var cell_index_1 = int(wall.x)
		var cell_index_2 = int(wall.y)
		var set1 = find_set(cell_index_1, sets)
		var set2 = find_set(cell_index_2, sets)
		if set1 != set2:
			merge_sets(set1, set2, sets)
			removed_walls.append(wall)

func find_set(cell_index, sets):
	if sets[cell_index] != cell_index:
		sets[cell_index] = find_set(sets[cell_index], sets)
	return sets[cell_index]

func merge_sets(set1, set2, sets):
	var root1 = find_set(set1, sets)
	var root2 = find_set(set2, sets)
	if root1 != root2:
		for key in sets.keys():
			if sets[key] == root2:
				sets[key] = root1;

func place_horizontal_wall(cell_index_1, cell_index_2):
	var wall_scene = preload("res://wall_instance.tscn")
	var material = preload("res://materials/wall_material.tres") # Load your saved material
	var wall_instance = wall_scene.instantiate()
	wall_instance.get_node("MeshInstance3D").material_override = material
	var col1 = cell_index_1 % maze_size
	var row1 = int(cell_index_1 / maze_size)
	var pos_x = col1 + 0.5
	var pos_z = -(row1 + 1)
	wall_instance.transform.origin = Vector3(pos_x, 1, pos_z)
	add_child(wall_instance)

func place_vertical_wall(cell_index_1, cell_index_2):
	var wall_scene = preload("res://wall_instance.tscn")
	var material = preload("res://materials/wall_material.tres") # Load your saved material
	var wall_instance = wall_scene.instantiate()
	wall_instance.get_node("MeshInstance3D").material_override = material
	var col1 = cell_index_1 % maze_size
	var row1 = int(cell_index_1 / maze_size)
	var pos_x = col1 + 1.0
	var pos_z = -(row1 + 0.5)
	wall_instance.transform.origin = Vector3(pos_x, 1, pos_z)
	wall_instance.rotate_object_local(Vector3(0, 1, 0), PI / 2)
	add_child(wall_instance)

func place_floor_tiles():
	var floor_scene = preload("res://floor_instance.tscn")
	var material = preload("res://materials/wall_material.tres")
	for x in range(maze_size):
		for z in range(maze_size):
			var floor_tile = floor_scene.instantiate()
			floor_tile.get_node("MeshInstance3D").material_override = material
			floor_tile.transform.origin = Vector3(x + 0.5, 0.9, -z - 0.5)
			add_child(floor_tile)

func visualize_maze():
	var wall_scene = preload("res://wall_instance.tscn")
	var cell_size = 1.0
	for wall in walls:
		if wall in removed_walls:
			continue
		var cell_index_1 = int(wall.x)
		var cell_index_2 = int(wall.y)
		var horizontal = abs(cell_index_1 - cell_index_2) == maze_size
		if horizontal:
			place_horizontal_wall(cell_index_1, cell_index_2)
		else:
			place_vertical_wall(cell_index_1, cell_index_2)

