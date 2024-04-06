extends Node3D

class_name Glasses

signal glasses_picked_up

func _on_area_3d_area_entered(area):
    if area.name == "Player":
        glasses_picked_up.emit(self)
        
        
