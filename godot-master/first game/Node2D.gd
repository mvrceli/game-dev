extends Area2D

var SPEED = 400
var velocity = Vector2()
var direction = 1



func set_direction(dir):
	direction = dir
	if dir == -1:
		$Sprite.flip_h = true

func _physics_process(delta):
	velocity.x = SPEED * delta * direction
	translate(velocity)
	


func _on_Bullet_body_entered(body):
	queue_free()


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
