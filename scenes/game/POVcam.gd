extends Node3D

@export var player : Node3D
@export var fish : Fish

func _process(delta):
    self.position = player.get_global_position()
    #self.position.y = fish.position.y
    #ligne du dessus: pour que la cam saute avec le poisson
    self.rotation_degrees.y = player.rotation_degrees.y
    self.rotation_degrees.x = -fish.rotation_degrees.x

    
