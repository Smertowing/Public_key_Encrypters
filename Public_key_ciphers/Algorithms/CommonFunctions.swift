//
//  CommonFunctions.swift
//  Public_key_ciphers
//
//  Created by Kiryl Holubeu on 10/7/18.
//  Copyright © 2018 Kiryl Holubeu. All rights reserved.
//

import Foundation

extension Int {
    var isPrime: Bool { return self > 1 && !(2 ..< self).contains { self % $0 == 0 } }
}

// Fast exponentiation algorithm
func fastexp(a: Int, z: Int, n: Int) -> Int {
    var a1 = a, z1 = z
    var x = 1
    while z1 != 0 {
        while (z1 % 2) == 0 {
            z1 = z1 / 2
            a1 = (a1*a1) % n
        }
        z1 = z1 - 1
        x = (x * a1) % n
    }
    return x
}

// Advanced Euclidean algorithm
func euclidex(a: Int, b: Int) -> (Int,Int,Int) {
    var d0 = a, d1 = b
    var x0 = 1, x1 = 0, y0 = 0, y1 = 1
    while d1 > 1 {
        let q = d0 / d1, d2 = d0 % d1
        let x2 = x0 - q*x1, y2 = y0 - q*y1
        d0 = d1; d1 = d2
        x0 = x1; x1 = x2
        y0 = y1; y1 = y2
    }
    return (x1, y1, d1)
}
