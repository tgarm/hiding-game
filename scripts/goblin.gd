extends CharacterBody2D  # Or KinematicBody2D

const SPEED = 100.0
var direction = Vector2.ZERO
var hp = 20

func _ready():
	# Pick a random direction initially
	pick_random_direction()

func check_collide(delta):
	var collision = move_and_collide(velocity * delta)
	if collision:
		if collision.get_collider() is CharacterBody2D and collision.get_collider().name == "Player":
			collision.get_collider().take_damage(10)  # Reduce player's HP

func _physics_process(delta):
	# Move in the current direction
	velocity = direction * SPEED
	check_collide(delta)
	move_and_slide()

	# Change direction randomly every 2 to 4 seconds
	if randf() < 0.01:
		pick_random_direction()

func pick_random_direction():
	# Pick a random direction between -1 and 1 for both X and Y
	direction.x = randf_range(-1, 1)
	direction.y = randf_range(-1, 1)
	direction = direction.normalized()  # Normalize to prevent faster diagonal movement


# Handle when the goblin gets hit by a bullet
func take_damage(amount: int):
	hp -= amount
	print("Goblin HP:", hp)

	if hp <= 0:
		die()

# Goblin dies and gets removed from the scene
func die():
	print("Goblin died")
	queue_free()  # Remove goblin from the scene
