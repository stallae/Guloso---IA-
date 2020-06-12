extends Area2D

onready var deathParticles = get_node("smokeParticles")
onready var animationPlayer = get_node("AnimationPlayer")

func play_animation_and_queue_free():
	$CollisionShape2D.set_deferred("disabled", true)
	monitoring = false
	animationPlayer.play("Death")
	deathParticles.emitting = true
	deathParticles.one_shot = true
