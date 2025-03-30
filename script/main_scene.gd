extends Node2D

@onready var pointer = $camera/pointer
@onready var gameOver = $UI/game_over
@onready var camera = $camera
@onready var timer = $timer

var pointer_speed = 100
var dir = true
var tower = 0
var can_drop = true

var game_over = false

func _ready():
	get_tree().paused = false

func _physics_process(delta):
	if game_over:
		if Input.is_action_just_pressed("ui_accept"):
			get_tree().call_deferred("reload_current_scene")
		gameOver.text = "Game Over \n Score:" + str(tower)
		gameOver.visible = true
	else:
		if Input.is_action_just_pressed("ui_accept") && can_drop:
			if tower > 1:
				camera.position.y -= 24
			tower_scene_controller()
			tower += 1
			can_drop = false
			timer.start()
		pointer_controller(delta)

func tower_scene_controller():
	var tower_scene = preload("res://scene/tower_0.tscn").instantiate()
	if   tower >= 20: tower_scene = preload("res://scene/tower_5.tscn").instantiate()
	elif tower >= 15: tower_scene = preload("res://scene/tower_4.tscn").instantiate()
	elif tower >= 10: tower_scene = preload("res://scene/tower_3.tscn").instantiate()
	elif tower >= 5:  tower_scene = preload("res://scene/tower_2.tscn").instantiate()
	elif tower >= 1 : tower_scene = preload("res://scene/tower_1.tscn").instantiate()
		
	tower_scene.global_position = pointer.global_position
	call_deferred("add_child",tower_scene)

func pointer_controller(delta):
	if dir:
		pointer.position.x += pointer_speed * delta
	else:
		pointer.position.x -= pointer_speed * delta
		
	if pointer.position.x <= 4:
		dir = true
	elif pointer.position.x >= get_viewport_rect().size.x -4:
		dir = false
		
	if tower > 20:
		pointer_speed = 200
	elif tower > 10:
		pointer_speed = 150


func _on_timer_timeout():
	can_drop = true
