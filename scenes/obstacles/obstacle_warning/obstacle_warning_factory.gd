extends Node

class_name ObstacleWarningFactory

var warning_prefab = preload("res://scenes/obstacles/obstacle_warning/obstacle_warning.tscn")

static var instance: ObstacleWarningFactory

func _ready():
    instance = self

func generate_warning(origin: Vector3, rotation: Vector3, length: float, duration: float, width: float):
    if width == 0 or duration == 0 or length == 0:
        return
    
    var warning = warning_prefab.instantiate() as Node3D
    
    add_child(warning)
    
    warning.global_position = origin 
    warning.rotation = rotation
    var mesh = warning.get_node("Mesh") as MeshInstance3D
    mesh.mesh.size = Vector2(length, width)
    
    mesh.mesh.center_offset.x = -length / 2
    
    await get_tree().create_timer(duration).timeout
    
    warning.queue_free()
    
