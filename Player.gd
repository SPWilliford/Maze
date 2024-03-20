extends CharacterBody3D

const SPEED = 3.0
const JUMP_VELOCITY = 4.5
var sensitivity = 0.5
var camera_pitch = 0.0

@onready var camera = $Camera3D

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	var start_x = 0.5
	var start_y = 1.5
	var start_z = -0.5
	global_transform.origin = Vector3(start_x, start_y, start_z)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "forward", "back")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		
	move_and_slide()
	
func _input(event):
	if event is InputEventMouseMotion:
		rotate_y((-event.relative.x * sensitivity * PI) / 180.0)
		camera_pitch += (-event.relative.y * sensitivity * PI) / 180.0
		camera_pitch = clamp(camera_pitch, (-89 * PI) / 180.0, (89 * PI) / 180.0)
		camera.rotation_degrees.x = (camera_pitch * 180.0) / PI

	if Input.is_action_just_pressed("escape"):
		get_tree().quit()

