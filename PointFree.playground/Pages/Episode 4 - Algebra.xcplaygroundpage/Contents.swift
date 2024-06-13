struct Pair<A, B> {
  let first: A
  let second: B
}


Pair<Bool, Bool>.init(first: true, second: true)
Pair<Bool, Bool>.init(first: true, second: false)
Pair<Bool, Bool>.init(first: false, second: true)
Pair<Bool, Bool>.init(first: false, second: false)

enum Three {
  case one
  case two
  case three
}

Pair<Bool, Three>.init(first: true, second: .one)
Pair<Bool, Three>.init(first: true, second: .two)
Pair<Bool, Three>.init(first: true, second: .three)
Pair<Bool, Three>.init(first: false, second: .one)
Pair<Bool, Three>.init(first: false, second: .two)
Pair<Bool, Three>.init(first: false, second: .three)

let _: Void = Void()
let _: Void = ()
let _: () = ()

func foo(_ x: Int) /* -> Void */ {
  // return ()
}

Pair<Bool, Void>.init(first: true, second: ())
Pair<Bool, Void>.init(first: true, second: ())

Pair<Void, Void>.init(first: (), second: ())

// let _: Never = ???

//Pair<Bool, Never>.init(first: true, second: ???)

// Pair<Bool, Bool> = 4
// Pair<Bool, Three> = 6
// Pair<Bool, Bool>
// Pair<Void, Void> = 1
// Pair<Bool, Never> = 0

enum Theme {
  case light
  case dark
}

enum State {
  case highlighted
  case normal
  case selected
}

struct Component {
  let enabled: Bool
  let state: State
  let theme: Theme
}

// 2 * 3 * 2 = 12

// Pair<A, B> = A * B
// Pair<Bool, Bool> = Bool * Bool

// Pair<Bool, String> = Bool * String
// String * [Int]

enum Either<A, B> {
  case left(A)
  case right(B)
}

Either<Bool, Bool>.left(true)
Either<Bool, Bool>.left(false)
Either<Bool, Bool>.right(true)
Either<Bool, Bool>.right(false)

Either<Bool, Three>.left(true)
Either<Bool, Three>.left(false)
Either<Bool, Three>.right(.one)
Either<Bool, Three>.right(.two)
Either<Bool, Three>.right(.three)

Either<Bool, Never>.left(true)
Either<Bool, Never>.left(false)


// (A) -> B
// (a + 1) * (b + 1)

// (a + 1) + b
