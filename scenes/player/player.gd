extends Node3D

class_name Player

enum PlayerMovementType { Swim, Struggle }

@export var fish: Fish

@export var move_time: float
@export var move_time_struggle: float
@export var move_distance: float
@export var move_distance_struggle: float
@export var rotation_speed: float

var input_stack: Array

var move_start: Vector3
var move_target: Vector3

var rotation_start: float
var rotation_target: float

var move_timer: float

var movement_type: PlayerMovementType

static var instance: Player

# Called when the node enters the scene tree for the first time.
func _ready():
    move_timer = move_time
    fish.set_moving(false)
    instance = self
    
    movement_type = PlayerMovementType.Swim

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    move(delta)
        
func move(delta):
    start_moving()
    process_move(delta)

func start_moving():
    var current_move_time = move_time if movement_type == PlayerMovementType.Swim else move_time_struggle
    var current_move_distance = move_distance if movement_type == PlayerMovementType.Swim else move_distance_struggle
    
    if move_timer == current_move_time and not input_stack.is_empty():
        move_timer = 0
        
        move_start = position
        rotation_start = rotation_degrees.y if rotation_degrees.y < 360 else 0.0
        
        match input_stack.back():
            "left":
                move_target = position + Vector3.LEFT * current_move_distance
                rotation_target = 90.0
            "right":
                move_target = position + Vector3.RIGHT * current_move_distance
                rotation_target = 270
                
                if rotation_start == 0:
                    rotation_start = 360
            "up":
                move_target = position + Vector3.FORWARD * current_move_distance
                rotation_target = 0.0
                
                if rotation_start == 270:
                    rotation_start = -90
            "down":
                move_target = position + Vector3.BACK * current_move_distance
                rotation_target = 180  
        
        if movement_type == PlayerMovementType.Struggle:
            input_stack.clear()     
                
        fish.set_moving(true)
        
func process_move(delta):
    var current_move_time = move_time if movement_type == PlayerMovementType.Swim else move_time_struggle
    
    if move_timer >= current_move_time:
        return
    
    if move_timer < current_move_time:
        move_timer = move_timer + delta
        position = lerp(move_start, move_target, move_timer / current_move_time)
        
        rotation_degrees.y = lerp(rotation_start, rotation_target, min(1, move_timer / current_move_time * rotation_speed))
    
    if move_timer >= current_move_time:
        move_timer = current_move_time
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
        
    #debug wesh
    if event.is_action_pressed("ui_select"):
        movement_type = PlayerMovementType.Swim if movement_type == PlayerMovementType.Struggle else PlayerMovementType.Struggle
        fish.set_grounded(movement_type == PlayerMovementType.Struggle)
        move_timer = move_time if movement_type == PlayerMovementType.Swim else move_time_struggle

func die():
    visible = false
