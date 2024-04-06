extends Node3D

@onready var player: Player = get_tree().get_first_node_in_group("Player")

func _ready():
    var glasses: Glasses = get_tree().get_first_node_in_group("Glasses")
       
    if glasses != null:
        glasses.glasses_picked_up.connect(on_glasses_picked_up)

func on_glasses_picked_up(glasses: Glasses):
    glasses.queue_free()
    if player != null:
        player.put_on_glasses()
