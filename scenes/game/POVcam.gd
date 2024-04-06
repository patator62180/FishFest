extends Node3D

@export var target_position : Node3D
@export var target_rotation : Node3D

func _process(delta):
    global_position = target_position.global_position
    global_rotation = target_rotation.global_rotation
    #self.position.y = fish.position.y
    #ligne du dessus: pour que la cam saute avec le poisson
