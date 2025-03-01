extends Node2D

@export var boundary_center: Vector2 = Vector2(0, 0)  # Fixed arena center
@export var boundary_radius: float = 1000  # Adjust for arena size
@export var boundary_color: Color = Color.RED  # Border color
@export var line_width: float = 5  # Circle thickness

func _draw():
	draw_arc(boundary_center, boundary_radius, 0, TAU, 100, boundary_color, line_width)
