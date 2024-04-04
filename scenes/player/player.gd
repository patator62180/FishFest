extends Node3D

class_name Player

@export var fish: Fish

@export var move_time: float
@export var move_distance: float
@export var rotation_speed: float

var input_stack: Array

var move_start: Vector3
var move_target: Vector3

var rotation_start: float
var rotation_target: float

var move_timer: float

# Called when the node enters the scene tree for the first time.
func _ready():
    move_timer = move_time
    fish.set_moving(false)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    move(delta)
        
func move(delta):
    start_moving()
    process_move(delta)

func start_moving():
    if move_timer == move_time and not input_stack.is_empty():
        move_timer = 0
        
        move_start = position
        rotation_start = rotation_degrees.y if rotation_degrees.y < 360 else 0.0
        
        match input_stack.back():
            "left":
                move_target = position + Vector3.LEFT * move_distance
                rotation_target = 90.0
            "right":
                move_target = position + Vector3.RIGHT * move_distance
                rotation_target = 270
                
                if rotation_start == 0:
                    rotation_start = 360
            "up":
                move_target = position + Vector3.FORWARD * move_distance
                rotation_target = 0.0
                
                if rotation_start == 270:
                    rotation_start = -90
            "down":
                move_target = position + Vector3.BACK * move_distance
                rotation_target = 180         
                
        fish.set_moving(true)
        
func process_move(delta):
    if move_timer == move_time:
        return
    
    if move_timer < move_time:
        move_timer = move_timer + delta
        position = lerp(move_start, move_target, move_timer / move_time)
        
        rotation_degrees.y = lerp(rotation_start, rotation_target, min(1, move_timer / move_time * rotation_speed))
    
    if move_timer >= move_time:
        move_timer = move_time
        position = move_target
        
        if input_stack.is_empty():
            fish.set_moving(false)
        
func _input(event):
    if event.is_action_pressed("ui_left"):
        input_stack.append("left")
    if event.is_action_pressed("ui_right"):
        input_stack.append("right")
    if event.is_action_pressed("ui_up"):
        input_stack.append("up")
    if event.is_action_pressed("ui_down"):
        input_stack.append("down")
    
    if event.is_action_released("ui_left"):
        input_stack.erase("left")
    if event.is_action_released("ui_right"):
        input_stack.erase("right")
    if event.is_action_released("ui_up"):
        input_stack.erase("up")
    if event.is_action_released("ui_down"):
        input_stack.erase("down")
