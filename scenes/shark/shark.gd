extends Node3D

class_name shark

@export var animation_player : AnimationPlayer

func eat():
    animation_player.play("eating")
    animation_player.queue("moving")
