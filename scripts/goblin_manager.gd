extends Node2D  # Or Position2D if you want a specific point of reference

const GOBLIN_SCENE = preload("res://scenes/goblin.tscn")
const SPAWN_DISTANCE = 100  # Distance range to spawn goblins
const MAX_ATTEMPTS = 10  # Number of attempts to find a valid spawn location
const MAX_GOBLIN_COUNT = 10
const OBSTACLE_LAYER = 1  # Define the layer for obstacles (adjust according to your setup)
var player  # Reference to the player node
var goblin_index = 0

func _ready():
	# Get the reference to the player (make sure your player's node name is 'Player')
	player = get_parent().get_node("Player")
	var spawn_timer = Timer.new()
	spawn_timer.wait_time = 5.0  # Set a spawn delay (5 seconds)
	spawn_timer.autostart = true
	spawn_timer.one_shot = false
	spawn_timer.connect("timeout", _on_spawn_timer_timeout)
	add_child(spawn_timer)

func _on_spawn_timer_timeout():
	spawn_goblin()

func spawn_goblin():
	var attempts = 0
	while attempts < MAX_ATTEMPTS:
		attempts += 1
		print('player at', player.position)
		# Generate a random angle and distance from the player
		var random_angle = randf() * TAU  # TAU is 2 * PI, gives us a full circle
		var random_distance = randf_range(SPAWN_DISTANCE, SPAWN_DISTANCE * 2)  # Distance range
		
		# Calculate a random position based on angle and distance
		var spawn_position = player.position + Vector2(cos(random_angle), sin(random_angle)) * random_distance
		
		print('check to spawn goblin')
		# Check if the goblin is accessible (no obstacles between player and spawn point)
		if is_accessible(spawn_position):
			print('spawn')
			var goblin = GOBLIN_SCENE.instantiate()
			print('position', spawn_position)
			goblin.position = spawn_position
			goblin_index += 1
			goblin.name = 'Goblin'+str(goblin_index)
			goblin.z_index = 1
			get_parent().add_child.call_deferred(goblin)
			break

func is_accessible(spawn_position: Vector2) -> bool:
	# Use a RayCast2D to check for obstacles between the player and the spawn position
	var raycast = RayCast2D.new()
	raycast.position = player.position  # Start the raycast from the player
	raycast.target_position = spawn_position - player.position  # Cast the ray towards the spawn position
	raycast.collision_mask = OBSTACLE_LAYER  # Set the layer for obstacles (adjust this to match your game)
	
	# Add the raycast temporarily to the scene to check for collisions
	add_child(raycast)
	raycast.enabled = true
	raycast.force_raycast_update()  # Force the raycast to update immediately
	
	var has_obstacle = raycast.is_colliding()
	remove_child(raycast)  # Clean up the temporary raycast node
	
	# Return true if no obstacles were detected
	return not has_obstacle
