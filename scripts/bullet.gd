extends Area2D

var direction = Vector2.ZERO
const SPEED = 400.0

func _physics_process(delta):
	position += direction * SPEED * delta

 	if position.distance_to(get_viewport().get_camera_2d().global_position) > 1000:
		queue_free()  # Free the bullet if it's too far off screen

# Called when bullet collides with something (Goblin)
func _on_body_entered(body: Node2D):
	if body is CharacterBody2D and  body.name.begins_with('Goblin'):  # If the bullet hits a goblin
		body.take_damage(10)  # Deal damage to the goblin
		queue_free()  # Destroy the bullet
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
