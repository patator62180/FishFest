extends Node3D

class_name EndGoal

func _on_area_3d_area_entered(area):
    if area.name == "Player":
        Player.instance.win()
