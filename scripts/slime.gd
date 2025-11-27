extends Enemy

@onready var raycasts : Node2D = $raycasts
@onready var raycast_front : RayCast2D = $raycasts/raycast_front
@onready var raycast_down : RayCast2D = $raycasts/raycast_down

func patrol_state(delta):
	super.patrol_state(delta)
	
	if raycast_front.is_colliding() or not raycast_down.is_colliding():
		
		flip_direction()

func flip_direction():
	super.flip_direction()
	
	raycasts.scale.x *= -1
