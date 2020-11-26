extends KinematicBody2D

const ACC = 500
const MAX_SPEED = 80
const FRICTION = 0.25
const AIR_RESISTANCE = 0 
const GRAVITY = 800
const JUMP_FORCE = 290

const BULLET = preload("res://Bullet2.tscn")

onready var sprite =$Sprite
onready var animation_player = $AnimationPlayer
var motion = Vector2.ZERO

func _physics_process(delta):
	var x_input = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	
	if x_input != 0:
		animation_player.play("Run")
		motion.x += x_input * ACC * delta
		motion.x = clamp(motion.x, -MAX_SPEED, MAX_SPEED)
		sprite.flip_h = x_input < 0 
	else:
		animation_player.play("Stand")
	motion.y += GRAVITY * delta

	if x_input == 1:
		if sign($Position2D.position.x) == -1:
			$Position2D.position.x *= -1

	if x_input == -1:
		if sign($Position2D.position.x) == 1:
			$Position2D.position.x *= -1

	if Input.is_action_just_pressed("ui_accept"):
		var bullet = BULLET.instance()
		if sign($Position2D.position.x) == 1:
			bullet.set_direction(1)
		else:
			bullet.set_direction(-1)
		get_parent().add_child(bullet)
		bullet.position = $Position2D.global_position
	
	if is_on_floor():
		if x_input == 0:
			motion.x = lerp(motion.x, 0, FRICTION)
		if Input.is_action_just_pressed("ui_up"):
			motion.y = -JUMP_FORCE
	else: 
		animation_player.play("Jump")
		if Input.is_action_just_pressed("ui_up") and motion.y < -JUMP_FORCE/2:
			motion.y = -JUMP_FORCE/2
		if x_input == 0:
			motion.x = lerp(motion.x, 0, AIR_RESISTANCE)
			
	motion = move_and_slide(motion, Vector2.UP)
