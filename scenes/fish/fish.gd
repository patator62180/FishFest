extends Node3D

class_name Fish

@export var animation_player: AnimationPlayer
@export var is_moving_transition_speed: float
@export var is_grounded_transition_speed: float

@onready var animation_tree: AnimationTree = $AnimationTree
@onready var glasses: MeshInstance3D = $Glasses

var is_moving_bool: bool
var is_moving_float: float

var is_grounded_bool: bool
var is_grounded_float: float

func _ready():
    glasses.visible = false

func play_anim(animation: String):
    animation_player.play(animation)

func set_moving(is_moving: bool):
    is_moving_bool = is_moving
    
    if is_moving:
        animation_tree.set("parameters/TimeSeek/seek_request", 0.0)
        animation_tree.set("parameters/struggle_height/blend_amount", 2)
    else:
        animation_tree.set("parameters/struggle_height/blend_amount", 1)

func set_grounded(is_grounded: bool):
    is_grounded_bool = is_grounded
    animation_tree.set("parameters/struggle_height/blend_amount", 1)
    
func put_on_glasses():
    glasses.visible = true
    
func _process(delta):
    if is_moving_bool and is_moving_float < 1:
        is_moving_float = is_moving_float + is_moving_transition_speed * delta
    elif !is_moving_bool and is_moving_float > 0:
        is_moving_float = is_moving_float - is_moving_transition_speed * delta
    
    is_moving_float = clampf(is_moving_float, 0.0, 1.0)
    animation_tree.set("parameters/is_moving/blend_amount", is_moving_float)
    
    if is_grounded_bool and is_grounded_float < 1:
        is_grounded_float = is_grounded_float + is_grounded_transition_speed * delta
    elif !is_grounded_bool and is_grounded_float > 0:
        is_grounded_float = is_grounded_float - is_grounded_transition_speed * delta
    
    is_grounded_float = clampf(is_grounded_float, 0.0, 1.0)
    animation_tree.set("parameters/is_grounded/blend_amount", is_grounded_float)
