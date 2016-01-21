func euler116(block_size: Int, _ bin_size: Int) -> Int {
    assert(block_size <= bin_size, "That doesn't make any sense")

    var results = [Int]()
    for size in block_size...bin_size {
        if size < block_size * 2 {
            results.append(size - block_size + 1)
        } else {
            let result = 1 + results.last! + results.first!
            results.append(result)
            results.removeAtIndex(0)
        }
    }

    return results.last!
}

print(euler116(2, 50) + euler116(3, 50) + euler116(4, 50))

/*
p2(2) -> 1
p2(3) -> 2
p2(4) -> 4
p2(5) -> 7
p2(6) -> 12
p2(n) -> p2(n-1) + p2(n-2) + 1

1100 -> zeroes
1111 -> p2(2)
0110 -> p2(3)
0011

11000 -> zeroes
11110 -> p2(3)
11011
01100 -> p2(4)
01111
00110 
00011

110000 -> zeroes
111100 -> p2(4)
111111
110110
110011
011000 -> p2(5)
011110
011011
001100
001111
000110
000011

---

p3(3) -> 1
p3(4) -> 2
p3(5) -> 3
p3(6) -> 5

p3(n) -> p3(n-3) + p3(n-1) + 1

111

1110
0111

11100
01110
00111

111000 -> zero
111111 -> p3(3)
011100 -> p3(5)
001110
000111

1110000 -> zero
1111110 -> p3(4)
1110111 
0111000 -> p3(6)
0111111
0011100
0001110
0000111

---

p4(4) -> 1
p4(5) -> 2
p4(6) -> 3
p4(7) -> 4
p4(8) -> 6
p4(n) -> p4(n-1) + p4(n-4) + 1

11110000 -> zeroes
11111111 -> p4(4)
01111000 -> p4(7)
00111100
00011110
00001111

*/
