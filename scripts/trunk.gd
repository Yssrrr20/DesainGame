extends Enemy

func _ready():
	set_state(EnemyState.IDLE)

func idle_state(delta):
	animationPlayer.play("shoot")

func shoot():
	var bullet = preload("res://scenes/objects/bullet.tscn").instantiate()
	bullet.position = position
	
	if sprite.flip_h:
		bullet.direction = Vector2.RIGHT 
	else:
		bullet.direction = Vector2.LEFT  
	get_parent().add_child(bullet)

func _on_hitbox_area_entered(area: Area2D) -> void:
	get_tree().reload_current_scene() # Replace with function body.
