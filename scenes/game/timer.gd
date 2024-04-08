extends Panel

var time: float = 0.0
var minutes: int = 0
var seconds: int = 0
var msec: int = 0

func _ready():
    stop()

func _process(delta):
    time  += delta
    msec = fmod(time, 1) * 100
    seconds = fmod(time, 60)
    minutes = fmod(time, 3600) / 60
    $Minutes.text = "%02d:" % minutes
    $Seconds.text = "%02d." % seconds
    $Msecs.text = "%03d" % msec

func stop():
    set_process(false)

func _on_button_pressed():
    set_process(true) # Replace with function body.