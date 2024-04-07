extends CanvasLayer

class_name UI

@onready var start_UI: Control = $StartUI
@onready var middle_UI: Control = $MiddleUI
@onready var end_UI: Control = $EndUI
@onready var splash_music: AudioStreamPlayer = $SplashMusic

signal start_pressed

func _ready():
    start_UI.visible = true
    middle_UI.visible = false
    end_UI.visible = false
    splash_music.play()

func _on_start_pressed():
    start_UI.visible = false
    Player.instance.is_dead = false
    splash_music.stop()
    start_pressed.emit()


func reach_mid_point():
    middle_UI.visible = true
    
    await get_tree().create_timer(10).timeout
    
    middle_UI.visible = false

func win():
    end_UI.visible = true

func _on_play_again_pressed():
    get_tree().reload_current_scene()
