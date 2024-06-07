//: [Previous](@previous)

import Foundation

func incr(_ x: Int) -> Int {
  return x + 1
}

incr(2)

func square(_ x: Int) -> Int {
  return x * x
}

square(incr(2))

extension Int {
  func incr() -> Int {
    return self + 1
  }

  func square() -> Int {
    return self * self
  }
}

2.incr()

2.incr().square()


2 |> incr


2 |> incr >>> square

2 |> incr >>> square >>> String.init

[1,2,3]
  .map { ($0 + 1) * ($0 + 1) }

[1,2,3]
  .map(square)
  .map(incr)

[1,2,3]
  .map(incr >>> square)
