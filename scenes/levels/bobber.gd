extends Node3D

@onready var bobber_body: Node3D = $MeshInstance3D
@onready var animation: AnimationPlayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    pass


func _on_area_3d_area_entered(area):
    if area.name == "Player":
        Player.instance.get_reeled(bobber_body)
        
        animation.play("reel_in")
