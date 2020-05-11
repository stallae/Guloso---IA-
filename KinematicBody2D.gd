extends KinematicBody2D

var motion = Vector2()

func _physics_process(delta):
	
	motion.y = randi() % 100
	motion.x = randi() % 100

func delete():
	$".".queue_free()
