extends Node3D

@export var player : Node3D
@export var fish : Fish

func _process(delta):
    self.position = player.get_global_position()
    self.rotation_degrees.y = player.rotation_degrees.y
    self.rotation_degrees.x = -fish.rotation_degrees.x

    
