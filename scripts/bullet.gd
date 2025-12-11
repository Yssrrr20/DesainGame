extends Area2D

@export var speed = 300

@onready var sprite: Sprite2D = $Sprite2D

var direction = Vector2.ZERO

func _process(delta):
	position += direction * speed * delta

func _on_area_entered(area: Area2D) -> void:
	queue_free()
	if area.get_parent().is_in_group("player"):
		get_tree().reload_current_scene()
