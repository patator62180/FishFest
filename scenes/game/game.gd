extends Node3D

@onready var player: Player = get_tree().get_first_node_in_group("Player")
@onready var camera_parent: Node3D = $CameraParent

func _ready():
    var glasses: Glasses = get_tree().get_first_node_in_group("Glasses")
    var end_goal: EndGoal = get_tree().get_first_node_in_group("EndGoal")
       
    if glasses != null:
        glasses.glasses_picked_up.connect(on_glasses_picked_up)
        
    if end_goal != null:
        end_goal.level_won.connect(on_level_won)
        
func on_glasses_picked_up(glasses: Glasses):
    glasses.queue_free()
    if player != null:
        player.put_on_glasses()
    camera_parent.turn_camera()

func on_level_won(end_goal: EndGoal):
     if(player.glasses_on != 1):
        print("gagne")
