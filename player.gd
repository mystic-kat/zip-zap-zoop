extends CharacterBody2D

@export var speed: float = 300
var charge_power: float = 0
var max_charge: float = 1000
@onready var charge_bar = get_node_or_null("../Control/Charge_bar")
var direction: Vector2 = Vector2.UP
@onready var camera = $Camera2D  # Reference the Camera2D node
@export var boundary_center: Vector2 = Vector2(0, 0)  # Fixed arena center
@export var boundary_radius: float = 1000  # Match visual circle
@export var bounce_factor: float = 0.8  # Adjust elasticity)

func get_random_spawn_position() -> Vector2:
	var angle = randf() * TAU  # Random angle (0 to 2π)
	var distance = sqrt(randf()) * boundary_radius  # Random radius (sqrt for even spread)
	var spawn_offset = Vector2(cos(angle), sin(angle)) * distance  # Convert to Cartesian
	return boundary_center + spawn_offset  # Final spawn position
	
func _ready():
	# Random spawn within circle
	global_position = get_random_spawn_position()
	camera.make_current()  # Activate camera
	camera.position_smoothing_enabled = true
	camera.position_smoothing_speed = 7  # Smooth camera movement
	await get_tree().process_frame
	charge_bar = get_node_or_null("../Control/Charge_bar")

	if charge_bar == null:
		print("❌ Charge_Bar STILL not found!")
	else:
		print("✅ Charge_Bar FOUND!")
		charge_bar.visible = false  # Hide initially

func _process(delta):
	if Input.is_action_pressed("charge"):
		modulate = Color(1, 1, 1, 0.5)  # Half transparency when charging
		charge_power += max_charge * delta * (1 - charge_power / max_charge)  # Full charge in 1 sec
		charge_power = min(charge_power, max_charge)

		if charge_bar:
			charge_bar.value = charge_power
			charge_bar.visible = true  # Show when charging
			charge_bar.global_position = camera.global_position + Vector2(-150, 300)  # Center of screen, 300px below

	elif charge_power > 0:
		modulate = Color(1, 1, 1, 1)  # Normal when released
		var launch_speed = charge_power * 2.5
		velocity = direction.normalized() * launch_speed
		charge_power = 0  # Reset after launch

		if charge_bar:
			charge_bar.value = charge_power
			charge_bar.visible = false  # Hide when not charging

func _physics_process(delta):
	camera.global_position = lerp(camera.global_position, global_position, 0.1)
	move_and_slide()
	velocity *= 0.95  # Slow down gradually
	# Check for boundary collisions
	var distance_from_center = (global_position - boundary_center).length()
	if distance_from_center >= boundary_radius:
		var normal = (global_position - boundary_center).normalized()  # Get normal direction
		velocity = velocity.bounce(normal) * bounce_factor  # Elastic bounce
		global_position = boundary_center + normal * (boundary_radius - 5)  # Keep inside boundary

func _input(event):
	if event is InputEventMouseMotion:
		var mouse_pos = get_global_mouse_position()
		direction = (mouse_pos - global_position).normalized()
		rotation = direction.angle()
