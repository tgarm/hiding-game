extends CharacterBody2D

const BULLET_SCENE = preload("res://scenes/bullet.tscn")
const SPEED = 300.0
var last_direction = Vector2.RIGHT  # Default moving direction
var hp = 50

# Handle player movement input
func get_input():
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	if input_dir != Vector2.ZERO:
		velocity = input_dir * SPEED
		last_direction = input_dir.normalized()  # Save the last movement direction
	else:
		velocity = Vector2.ZERO

# Handle shooting input
func handle_shoot_input():
	if Input.is_action_just_pressed("shoot"):
		shoot_bullet()

# Shoot a bullet in the player's last moving direction
func shoot_bullet():
	var bullet = BULLET_SCENE.instantiate()
	bullet.position = position  # Spawn bullet at player's current position
	bullet.direction = last_direction  # Set bullet direction based on last player direction
	get_parent().add_child(bullet)  # Add bullet to the scene

# Called every frame
func _physics_process(delta):
	get_input()
	
	# Move player based on input
	move_and_slide()  # No arguments needed for Godot 4

	# Check for shooting input
	handle_shoot_input()


# Handle when the goblin gets hit by a bullet
func take_damage(amount: int):
	hp -= amount
	print("Player HP:", hp)

	if hp <= 0:
		die()

# Goblin dies and gets removed from the scene
func die():
	print("Player died")
	queue_free()  # Remove goblin from the scene
