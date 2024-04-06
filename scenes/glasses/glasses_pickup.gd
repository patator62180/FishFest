extends Node3D

class_name Glasses

func _on_area_3d_area_entered(area):
    if area.name == "Player":
        Player.instance.put_on_glasses()
        GameCamera.instance.turn_camera()
        
        queue_free()
        
        
