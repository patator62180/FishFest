extends Node3D

class_name EndGoal

signal level_won

func _on_area_3d_area_entered(area):
    if area.name == "Player":
        level_won.emit(self)
