extends Node


func calc_curve(start: Vector2, target: Vector2, weight: float) -> Vector2:
    var p0 = start
    var p1 = start + (target - start) / 2 + Vector2.UP * 80
    var p2 = target

    var m1 = lerp(p0, p1, weight)
    var m2 = lerp(p1, p2, weight)

    return lerp(m1, m2, weight)


