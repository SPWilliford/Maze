extends Node3D

@onready var maze = $MazeNode

var default_maze_size = 50  

func _ready():
	start_game(default_maze_size)

func start_game(maze_size):
	maze.setup_maze(maze_size)

func restart_game():
	start_game(default_maze_size)
