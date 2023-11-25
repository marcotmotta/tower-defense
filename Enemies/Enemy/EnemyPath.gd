extends PathFollow3D

# fast: 0.2
# normal: 0.15
#slow: 0.1
var speed = 0.15

var slow_amount = null

func _process(delta):
	if slow_amount:
		progress += (speed * (1 - slow_amount)) + delta
	else:
		progress += speed + delta

func take_slow(amount, duration):
	if !slow_amount:
		slow_amount = amount
	else:
		slow_amount = max(slow_amount, amount)
	$EnemyArea/SlowTimer.start(duration)

func _on_slow_timer_timeout():
	slow_amount = null
