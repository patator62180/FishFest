extends Node3D

class_name Fish

@export var animation_player: AnimationPlayer
@export var animation_tree: AnimationTree

@export var is_moving_transition_speed: float

var is_moving_bool: bool
var is_moving_float: float


func play_anim(animation: String):
    animation_player.play(animation)

func set_moving(is_moving: bool):
    is_moving_bool = is_moving
    
func _process(delta):
    if is_moving_bool and is_moving_float < 1:
        is_moving_float = is_moving_float + is_moving_transition_speed * delta
    elif !is_moving_bool and is_moving_float > 0:
        is_moving_float = is_moving_float - is_moving_transition_speed * delta
    
    is_moving_float = clampf(is_moving_float, 0.0, 1.0)
    
    animation_tree.set("parameters/is_moving/blend_amount", is_moving_float)
