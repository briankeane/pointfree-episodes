import Foundation

// pipe forward
precedencegroup ForwardApplication {
  associativity: left
}

infix operator |>: ForwardApplication
public func |> <A, B>(a: A, f: (A) -> B) -> B {
  return f(a)
}

// forward compose
precedencegroup ForwardComposition {
  associativity: left
  higherThan: ForwardApplication
}

infix operator >>>: ForwardComposition
public func >>> <A, B, C>(f: @escaping (A) -> B, g: @escaping (B) -> C) -> ((A) -> C) {
  return { a in
    g(f(a))
  }
}
