extends CanvasLayer

@onready var start_UI: Control = $StartUI

func _on_start_pressed():
    start_UI.visible = false
    
    Player.instance.is_dead = false
