func p(width: Int, _ count: Int, _ target: Int) -> Int {
    assert(count > 0, "Why would you even?")
    assert(width*count <= target, "Woah woah woah")

    if count == 1 {
        return target - width + 1
    }

    var sum = 0
    var new_target = target - width
    while new_target >= (width * (count-1)) {
        sum += p(width, count - 1, new_target)
        new_target -= 1
    }

    return sum
}

func all(width: Int, _ max: Int, _ target: Int) -> Int {
    var sum = 0
    for i in 1...max {
        sum += p(width, i, target)
    }
    return sum
}

print(all(2, 25, 50) + all(3, 16, 50) + all(4, 12, 50))
