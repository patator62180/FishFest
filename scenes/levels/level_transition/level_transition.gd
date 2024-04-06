extends Area3D

@export var transition_to: Player.PlayerMovementType

func _on_area_entered(area):
    if area.name == "Player":
        Player.instance.transition_to_movement_type(transition_to)
