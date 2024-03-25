extends Node3D

var artwork_paths = []

# Called when the node enters the scene tree for the first time.
func _ready():
	load_artwork_paths()
	randomize()
	apply_random_artwork()

func load_artwork_paths():
	var dir = DirAccess.open("res://artwork/")
	dir.list_dir_begin()
	var filename = dir.get_next()
	while filename != "":
		if filename.ends_with(".jpg") or filename.ends_with(".png"):
			artwork_paths.append("res://artwork/" + filename)
		filename = dir.get_next()	
	dir.list_dir_end()	
		
func apply_random_artwork():
	var random_index = randi() % artwork_paths.size()
	var texture_path = artwork_paths[random_index]
	var texture = load(texture_path)
	
	if texture:
		var material = StandardMaterial3D.new()
		material.albedo_texture = texture
		var aspect_ratio = texture.get_width() / float(texture.get_height())
		var plane_mesh = PlaneMesh.new()
		plane_mesh.size = Vector2(1.0 * aspect_ratio, 1.0)
		var box_mesh = BoxMesh.new()
		box_mesh.size = Vector3(plane_mesh.size.x, plane_mesh.size.y, 0.03)
		$MeshInstance3D.mesh = plane_mesh
		$MeshInstance3D.material_override = material
		$MeshInstance3D2.mesh = box_mesh
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
