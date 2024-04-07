extends Node3D

class_name Player

enum PlayerMovementType { Swim, Struggle }

@export var fish: Fish

@export var move_time: float
@export var move_time_struggle: float
@export var move_distance: float
@export var move_distance_struggle: float
@export var user_interface: UI

var current_move_time: float

@export var rotation_time: float

@onready var fish_parent: Node3D = $MeshInstance3D/MeshInstance3D/FishParent
@onready var bones: Node3D = $MeshInstance3D/Bones
@onready var raycast_wall: RayCast3D = $WallDetection
@onready var raycast_ground: RayCast3D = $GroundDetection
@onready var rotate_parent: Node3D = $MeshInstance3D

var input_stack: Array

var move_start: Vector3
var move_target: Vector3

var rotation_start: float
var rotation_target: float

var move_timer: float
var rotation_timer: float

var movement_type: PlayerMovementType

var is_dead: bool
var is_wearing_glasses: bool

static var instance: Player

# Called when the node enters the scene tree for the first time.
func _ready():
    move_timer = move_time
    current_move_time = move_time 
    
    fish.set_moving(false)
    instance = self
    is_dead = true
    is_wearing_glasses = false
    
    movement_type = PlayerMovementType.Swim
    

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    if is_dead:
        return
        
    move(delta)
    
    if raycast_ground.is_colliding():
        print("is colliding")
        
func move(delta):
    start_moving()
    process_move(delta)

func start_moving():
    if move_timer >= current_move_time and not input_stack.is_empty():
        current_move_time = move_time if movement_type == PlayerMovementType.Swim else move_time_struggle
        var current_move_distance = move_distance if movement_type == PlayerMovementType.Swim else move_distance_struggle
        
        move_timer = 0
        rotation_timer = 0
        
        move_start = position
        rotation_start = rotate_parent.rotation.y
        
        match input_stack.back():
            "left":
                move_target = position + Vector3.LEFT * current_move_distance
                rotation_target = PI / 2
            "right":
                move_target = position + Vector3.RIGHT * current_move_distance
                rotation_target = PI * 1.5
            "up":
                move_target = position + Vector3.FORWARD * current_move_distance
                rotation_target = 0.0
            "down":
                move_target = position + Vector3.BACK * current_move_distance
                rotation_target = PI
        
        if movement_type == PlayerMovementType.Struggle:
            input_stack.clear()     
                
        
        raycast_wall.rotation.y = rotation_target
        raycast_wall.force_raycast_update()
        
        if raycast_wall.is_colliding():
            move_timer = current_move_time
            fish.set_moving(false)
        else:
            fish.set_moving(true)
        
func process_move(delta):
    if rotation_timer < rotation_time:
        rotation_timer = rotation_timer + delta
        rotate_parent.rotation.y = lerp_angle(rotation_start, rotation_target, min(1, rotation_timer / rotation_time))
    
    if move_timer >= current_move_time:
        return
    
    if move_timer < current_move_time:
        move_timer = move_timer + delta
        position = lerp(move_start, move_target, move_timer / current_move_time)
        
    if move_timer >= current_move_time:
        move_timer = current_move_time
        position = move_target
        
        if input_stack.is_empty():
            fish.set_moving(false) 
        
func _input(event):
    var direction = ""
    var pressed = true
    
    if event.is_action_pressed("ui_left"):
        direction = "left" if !is_wearing_glasses else "right"
    if event.is_action_pressed("ui_right"):
        direction = "right" if !is_wearing_glasses else "left"
    if event.is_action_pressed("ui_up"):
        direction = "up" if !is_wearing_glasses else "down"
    if event.is_action_pressed("ui_down"):
        direction = "down" if !is_wearing_glasses else "up"
    
    if event.is_action_released("ui_left"):
        direction = "left" if !is_wearing_glasses else "right"
        pressed = false
    if event.is_action_released("ui_right"):
        direction = "right" if !is_wearing_glasses else "left"
        pressed = false
    if event.is_action_released("ui_up"):
        direction = "up" if !is_wearing_glasses else "down"
        pressed = false
    if event.is_action_released("ui_down"):
        direction = "down" if !is_wearing_glasses else "up"
        pressed = false
    
    if direction != "":
        input_stack.erase(direction)
        if pressed: input_stack.append(direction)    
        
    ##debug wesh
    #if event.is_action_pressed("ui_select"):
        #transition_to_movement_type(PlayerMovementType.Swim if movement_type == PlayerMovementType.Struggle else PlayerMovementType.Struggle)

func die():
    if !is_dead:
        is_dead = true
        
        fish_parent.visible = false
        bones.visible = true
        bones.appear()
        
        GameCamera.instance.game_over()
        
        await get_tree().create_timer(3).timeout

        get_tree().reload_current_scene()

func win():
    if is_wearing_glasses:
        is_dead = true
        user_interface.win()
        fish.set_moving(false) 
        
func put_on_glasses():
    fish.put_on_glasses()
    is_wearing_glasses = true
    
    input_stack.clear()
    
    user_interface.reach_mid_point()

func get_reeled(reel: Node3D):
    if !is_dead:
        is_dead = true
        
        reparent(reel)
        
        GameCamera.instance.game_over()
        
        await get_tree().create_timer(3).timeout

        get_tree().reload_current_scene()
        
func transition_to_movement_type(type: PlayerMovementType):
    if movement_type == type:
        return
    
    input_stack.clear()
    
    movement_type = type
    fish.set_grounded(movement_type == PlayerMovementType.Struggle)
    raycast_wall.target_position.z = - move_distance if movement_type == PlayerMovementType.Swim else - move_distance_struggle
