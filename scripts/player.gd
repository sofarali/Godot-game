extends KinematicBody2D

var linear_velocity = Vector2(0,0)

const JUMP = 700
const SPEED = 250
const GRAVITY = 30
const UP = Vector2(0,-1)
const LEVEL_LIMIT = 3000
onready var sprite = $Sprite

func _physics_process(delta):
	apply_gravity()
	move()
	jump()
	move_and_slide(linear_velocity,UP)
	animate()

func apply_gravity():
	if position.y > LEVEL_LIMIT:
		end_game()
	if  is_on_floor():
		linear_velocity.y = 0
	else:
		linear_velocity.y += GRAVITY

func move():
	if Input.is_action_pressed("ui_left") and not Input.is_action_pressed("ui_right"):
		linear_velocity.x = -SPEED
	elif Input.is_action_pressed("ui_right") and not Input.is_action_pressed("ui_left"):
		linear_velocity.x = SPEED
	else:
		linear_velocity.x = 0
		
func jump():
	if Input.is_action_pressed("ui_select") and is_on_floor():
		linear_velocity.y -= JUMP
		$AudioStreamPlayer.stream = load("res://Assets - Little Funny Alien/Sounds/jump.ogg") 
		$AudioStreamPlayer.play()

func animate():
	if linear_velocity.y < 0:
		sprite.play("jump")
	elif linear_velocity.y > 0: #идем вправо
		sprite.play("walk")
		sprite.flip_h = false
	elif linear_velocity.y < 0: #идем влево
		sprite.play("walk")
		sprite.flip_h = true
	else:
		sprite.play("idle")

func end_game():
	get_tree().change_scene("res://scenes/Gameover.tscn")
