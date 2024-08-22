extends CharacterBody3D

@onready var neck : Node3D = $Neck
@onready var camera : Camera3D = $Neck/Camera3D

@export var speed : float = 15
@export var sensitivity_h : float = 0.005
@export var sensitivity_v : float = 0.005
@export var gravity : float = 0.75

func _unhandled_input(event):
	if event is InputEventMouseButton:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	elif event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		
	if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			neck.rotate_y(-event.relative.x * sensitivity_h)
			camera.rotate_x(-event.relative.y * sensitivity_v)
			camera.rotation_degrees.x = clamp(camera.rotation_degrees.x , -90, 90)

func _physics_process(delta):
	
	if !is_on_floor():
		velocity.y -= gravity
		
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	input_dir = (neck.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	velocity = input_dir * speed + Vector3(0, velocity.y,0)
	
	if is_on_floor():
		velocity += Vector3(0,20.0,0) * Input.get_axis("_", "jump")
	
	move_and_slide()
