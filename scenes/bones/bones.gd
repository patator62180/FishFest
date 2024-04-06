extends Node3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func appear():
    animation_player.play("appear")
