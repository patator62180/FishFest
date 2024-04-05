extends Camera3D

@export var cam_position : Node3D

func _process(delta):
    position = cam_position.get_global_position() + Vector3(0,0,3)
    self.rotation = cam_position.rotation
