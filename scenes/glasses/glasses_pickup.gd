extends Node3D

@export var fish : Fish

func _on_area_3d_area_entered(area):
    if area.name == "Player":
        get_node("Glasses").visible = false
        #Fish.visible = false
        
