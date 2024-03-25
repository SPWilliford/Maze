extends OmniLight3D

var timer = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	timer = randf() * 0.1


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	timer += delta
	if timer >= 0.1: # Adjust the flicker speed
		timer = 0
		omni_range = randf_range(1.9, 2.3)
		omni_attenuation = randf_range(0.3, 0.5)

