extends CharacterBody2D

const SPEED = 200.0
const JUMP_VELOCITY = -300.0

enum State { IDLE, RUN, JUMP, FALL }

var state: State = State.IDLE

@onready var sprite: Sprite2D = $Sprite
@onready var animationPlayer: AnimationPlayer = $AnimationPlayer


func _physics_process(delta: float) -> void:
	process_gravity(delta)
	process_state(delta)
	move_and_slide()

# ---------------------------------------------------------
# FSM MAIN LOGIC
# ---------------------------------------------------------
func process_state(delta: float) -> void:
	match state:

		State.IDLE:
			state_idle()

		State.RUN:
			state_run()

		State.JUMP:
			state_jump()

		State.FALL:
			state_fall()


# ---------------------------------------------------------
# STATES
# ---------------------------------------------------------

func state_idle():
	animationPlayer.play("idle")
	velocity.x = move_toward(velocity.x, 0, SPEED)

	var dir := Input.get_axis("move_left", "move_right")

	if Input.is_action_just_pressed("jump"):
		start_jump()
	elif dir != 0:
		switch_state(State.RUN)
	elif not is_on_floor():
		switch_state(State.FALL)


func state_run():
	animationPlayer.play("run")

	var dir := Input.get_axis("move_left", "move_right")
	if dir == 0:
		switch_state(State.IDLE)
	else:
		velocity.x = dir * SPEED
		sprite.flip_h = dir < 0

	if Input.is_action_just_pressed("jump"):
		start_jump()
	elif not is_on_floor():
		switch_state(State.FALL)


func state_jump():
	animationPlayer.play("jump")

	var dir := Input.get_axis("move_left", "move_right")

	if dir:
		velocity.x = dir * SPEED
		sprite.flip_h = dir < 0

	if velocity.y > 0:
		switch_state(State.FALL)


func state_fall():
	animationPlayer.play("fall")

	var dir := Input.get_axis("move_left", "move_right")
	velocity.x = dir * SPEED

	if is_on_floor():
		if dir == 0:
			switch_state(State.IDLE)
		else:
			switch_state(State.RUN)


# ---------------------------------------------------------
# UTILS
# ---------------------------------------------------------
func process_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

func start_jump():
	velocity.y = JUMP_VELOCITY
	switch_state(State.JUMP)


func switch_state(new_state: State):
	state = new_state
