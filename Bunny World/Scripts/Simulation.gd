#SIMULATION
extends Node2D

var bunny = preload("res://Scenes/Bunny.tscn")
onready var spawnPoint = get_node("SpawnPoint")

export var start_bunny_count = 5 # the number of bunnies to start with

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(start_bunny_count):
		SpawnBunny(spawnPoint.position + Vector2(rand_range(-30,30),0))

func SpawnBunny(pos):
	var new_bunny = bunny.instance() 	# temp variable to hold the bunny instance
	add_child(new_bunny)
	new_bunny.position = pos
	
func _input(event):
   # Mouse in viewport coordinates.
   if event is InputEventMouseButton:
	   SpawnBunny(event.position)

