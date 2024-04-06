extends Node3D

class_name GameCamera

@export var camera: Camera3D
@export var player: Player
@export var dummy_look_at: Node3D

@export var camera_speed: float
@export var catchup_speed: float

@export var dummy_dampening: float
@export var dummy_speed: float

var target_z: float
var highest_player_z: float

var go_back: bool

static var instance: GameCamera

var is_moving: bool

# Called when the node enters the scene tree for the first time.
func _ready():
    instance = self
    is_moving = true
    go_back = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    if !is_moving:
        return
        
    highest_player_z = max(highest_player_z, player.position.z) if go_back else min(highest_player_z, player.position.z)
    
    target_z = target_z - delta * camera_speed
    
    if (go_back and highest_player_z > target_z) or (highest_player_z < target_z and not go_back):
        target_z = lerp(target_z, highest_player_z, catchup_speed)
        
    
    var average = (target_z + player.position.z) / 2
    
    position.z = lerp(position.z, average, catchup_speed)
    
    dummy_look_at.global_position.x = lerp(dummy_look_at.global_position.x, player.global_position.x * dummy_dampening, dummy_speed)
    camera.look_at(dummy_look_at.global_position, Vector3.UP)
    
    if go_back and rotation_degrees.y != 180:
        rotation_degrees.y = lerp(rotation_degrees.y, 180.0, 0.05)
        if rotation_degrees.y >= 180 : rotation_degrees.y = 180
        
func game_over():
    if !is_moving:
        return
        
    is_moving = false

func turn_camera():
    go_back = true
    camera_speed = - camera_speed
