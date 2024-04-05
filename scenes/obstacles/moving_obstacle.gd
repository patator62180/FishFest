extends Node3D

class_name MovingObstacle

@export var movement_type: MovementType

@export var targets: Array[Vector3]

@export var movement_speed: float
@export var wait_duration: float
@export var rotation_duration: float

@export var kill_switch: bool

@export var warning_width: float

enum MovementType { BackAndForth, OneWay, OnceAndGone }

var movement_duration: float
var movement_timer: float
var wait_timer:float

var target_start: Vector3
var target_end: Vector3

var rotation_start: float
var rotation_target: float
var rotation_timer:float

var target_index: int
var movement_started: bool

# Called when the node enters the scene tree for the first time.
func _ready():
    movement_timer = movement_duration
    wait_timer = wait_duration
    rotation_timer = rotation_duration
    
    var previous_target = position
    
    for i in range(targets.size()):
        targets[i] = previous_target + targets[i]
        previous_target = targets[i]
        
    target_index = -1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    match movement_type:
        MovementType.BackAndForth:
            if rotation_timer < rotation_duration:
                rotation_timer = min(rotation_timer + delta, rotation_duration)
                rotation.y = lerp_angle(rotation_start, rotation_target, min(1, rotation_timer / rotation_duration))                
            
            if wait_timer < wait_duration:
                wait_timer = min(wait_timer + delta, wait_duration)
                return
            
            movement_timer = min(movement_timer + delta, movement_duration)
            
            if movement_timer == movement_duration:
                movement_timer = 0
                target_start = position
                
                target_index = target_index + 1
                if target_index >= targets.size():
                    target_index = 0
                target_end = targets[target_index]
                
                rotation_start = rotation.y
                rotation_target = get_rotation_for_segment()
                
                if movement_started:
                    wait_timer = 0
                    rotation_timer = 0
                else:
                    movement_started = true
                    rotation.y = rotation_target
                
                refresh_movement_duration()
            else:
                position = lerp(target_start, target_end, movement_timer / movement_duration)
        
        MovementType.OneWay:
            if !movement_started:
                target_start = targets[0]
                target_end = targets[1]
                refresh_movement_duration()
                rotation.y = get_rotation_for_segment()
                position = target_start
                movement_started = true
                
                generate_warning_one_way()
                wait_timer = 0                
                
            if wait_timer < wait_duration:
                wait_timer = min(wait_timer + delta, wait_duration)
                return
            
            movement_timer = min(movement_timer + delta, movement_duration)
            position = lerp(target_start, target_end, movement_timer / movement_duration)
            
            if movement_timer == movement_duration:
                movement_timer = 0
                wait_timer = 0
                generate_warning_one_way()
        
        MovementType.OnceAndGone:
            if !movement_started:
                target_start = position
                target_end = targets[0]
                refresh_movement_duration()
                rotation.y = get_rotation_for_segment()
                movement_started = true
            
            movement_timer = min(movement_timer + delta, movement_duration)
            position = lerp(target_start, target_end, movement_timer / movement_duration)
            
            if movement_timer == movement_duration:
                queue_free()

func refresh_movement_duration():
    movement_duration = movement_speed * (target_start - target_end).length()
    
func get_rotation_for_segment():
    return Vector2(target_end.x - target_start.x, target_start.z - target_end.z).rotated(deg_to_rad(90)).angle()

func _on_area_3d_area_entered(area):
    if !kill_switch:
        return
        
    if area.name == "Player":
        get_tree().reload_current_scene()
        
func generate_warning_one_way():
    ObstacleWarningFactory.instance.generate_warning(target_start, rotation, movement_duration / movement_speed, wait_duration, warning_width)
    
