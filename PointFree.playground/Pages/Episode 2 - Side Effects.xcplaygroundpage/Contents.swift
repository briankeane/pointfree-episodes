func compute(_ x: Int) -> Int {
  return x * x + 1
}

compute(2)
compute(2)
compute(2)

assertEqual(5, compute(2))
assertEqual(6, compute(2))
assertEqual(5, compute(3))

func computeWithEffect(_ x: Int) -> Int {
  let computation = x * x + 1
  print("Computed \(computation)")
  return computation
}

computeWithEffect(2)

assertEqual(5, computeWithEffect(2))

[2,10].map(compute).map(compute)
[2, 10].map(compute >>> compute)

[2,10].map(computeWithEffect).map(computeWithEffect)
[2, 10].map(computeWithEffect >>> computeWithEffect)


func computeAndPrint(_ x: Int) -> (Int, [String]) {
  let computation = x * x + 1
  return (computation, ["Computed \(computation)"])
}

let (computation, logs) = computeAndPrint(2)
logs.forEach { print($0) }

2 |> compute >>> compute

2 |> computeWithEffect >>> computeWithEffect

func compose<A, B, C>(
  _ f: @escaping (A) -> (B, [String]),
  _ g: @escaping (B) -> (C, [String])) -> (A) -> (C, [String]) {
    return { a in
      let (result1, log1) = f(a)
      let (result2, log2) = g(result1)
      return (result2, log1 + log2)
    }
  }

2 |> compose(computeAndPrint, compose(computeAndPrint, computeAndPrint))

precedencegroup EffectfulComposition {
  associativity: left
  higherThan: ForwardApplication
  lowerThan: ForwardComposition
}

infix operator >=>: EffectfulComposition
public func >=><A, B, C>(
  _ f: @escaping (A) -> (B, [String]),
  _ g: @escaping (B) -> (C, [String])) -> (A) -> (C, [String]) {
    return { a in
      let (result1, log1) = f(a)
      let (result2, log2) = g(result1)
      return (result2, log1 + log2)
    }
  }

2
  |> computeAndPrint 
  >=> computeAndPrint
  >=> computeAndPrint

2
  |> computeAndPrint
  >=> incr
  >>> computeAndPrint
  >=> square >>> computeAndPrint

public func >=><A, B, C>(
  _ f: @escaping (A) -> B?,
  _ g: @escaping (B) -> C?
) -> (A) -> C? {
  return { a in
    if let firstResult = f(a) {
      return g(firstResult)
    }
    return nil
  }
}

func greetWithEffect(_ name: String) -> String {
  let seconds = Int(Date().timeIntervalSince1970) % 60
  return "Hello \(name)! It's \(seconds) seconds past the minute."
}

greetWithEffect("Blob")

assertEqual("Hello Blob! It's 32 seconds past the minute.", greetWithEffect("Blob"))

func greet(at date: Date = Date(), name: String) -> String {
  let seconds = Int(date.timeIntervalSince1970) % 60
  return "Hello\(name)! It's \(seconds) seconds past the minute."
}

assertEqual(
  "Hello Blob! It's 39 seconds past the minute.",
  greet(at: Date(timeIntervalSince1970: 39), name: "Blob"))

func uppercased(_ string: String) -> String {
  return string.uppercased()
}

"Blob" |> uppercased >>> greetWithEffect
"Blob" |> greetWithEffect >>> uppercased

func greet(at date: Date = Date()) -> (String) -> String {
  return { name in
    let seconds = Int(date.timeIntervalSince1970) % 60
    return "Hello \(name)! It's \(seconds) seconds past the minute."
  }
}

assertEqual(
  "Hello BLOB! It's 37 seconds past the minute.",
  "Blob" |> uppercased >>> greet(at: Date(timeIntervalSince1970: 37))
)

//
let formatter = NumberFormatter()

func decimalStyle(_ format: NumberFormatter) {
  format.numberStyle = .decimal
  format.maximumFractionDigits = 2
}

func currencyStyle(_ format: NumberFormatter) {
  format.numberStyle = .currency
  format.roundingMode = .down
}

func wholeStyle(_ format: NumberFormatter) {
  format.maximumFractionDigits = 0
}

decimalStyle(formatter)
wholeStyle(formatter)

currencyStyle(formatter)
formatter.string(for: 1234.6)

decimalStyle(formatter)
wholeStyle(formatter)
formatter.string(for: 1234.6)


struct NumberFormatterConfig {
  var numberStyle: NumberFormatter.Style = .none
  var roundingMode: NumberFormatter.RoundingMode = .up
  var maximumFractionDigits: Int = 0

  var formatter: NumberFormatter {
    let result = NumberFormatter()
    result.numberStyle = self.numberStyle
    result.roundingMode = self.roundingMode
    result.maximumFractionDigits = self.maximumFractionDigits
    return result
  }
}

func decimalStyle(_ format: NumberFormatterConfig) -> NumberFormatterConfig {
  var format = format
  format.numberStyle = .decimal
  format.maximumFractionDigits = 2
  return format
}

func currencyStyle(_ format: NumberFormatterConfig) -> NumberFormatterConfig {
  var format = format
  format.numberStyle = .currency
  format.roundingMode = .down
  return format
}

func wholeStyle(_ format: NumberFormatterConfig) -> NumberFormatterConfig {
  var format = format
  format.maximumFractionDigits = 0
  return format
}

decimalStyle >>> currencyStyle

wholeStyle(decimalStyle(NumberFormatterConfig()))
  .formatter
  .string(for: 1234.6)

wholeStyle(currencyStyle(NumberFormatterConfig()))
  .formatter
  .string(for: 1234.6)


func inoutDecimalStyle(_ format: inout NumberFormatterConfig) {
  format.numberStyle = .decimal
  format.maximumFractionDigits = 2
}

func inoutCurrencyStyle(_ format: inout NumberFormatterConfig) {
  format.numberStyle = .currency
  format.roundingMode = .down
}

func inoutWholeStyle(_ format: inout NumberFormatterConfig) {
  format.maximumFractionDigits = 0
}

var config = NumberFormatterConfig()

inoutDecimalStyle(&config)
inoutWholeStyle(&config)
config.formatter.string(for: 1234.6)

inoutCurrencyStyle(&config)
inoutWholeStyle(&config)
config.formatter.string(for: 1234.6)


func toInOut<A>(_ f: @escaping (A) -> A) -> (inout A) -> Void {
  return { a in
    a = f(a)
  }
}

func fromInOut<A>(_ f: @escaping (inout A) -> Void) -> (A) -> A {
  return { a in
    var a = a
    f(&a)
    return a
  }
}

precedencegroup SingleTypeComposition {
  associativity: left
  higherThan: ForwardApplication
}

infix operator <>: SingleTypeComposition

public func <> <A>(
  f: @escaping (A) -> A,
  g: @escaping(A) -> A) -> (A) -> A {
  return f >>> g
}

public func <> <A>(
  f: @escaping (inout A) -> Void, 
  g: @escaping (inout A) -> Void) -> (inout A) -> Void {
  return { a in
    f(&a)
    g(&a)
  }
}

decimalStyle <> currencyStyle
inoutDecimalStyle <> inoutCurrencyStyle

config |> decimalStyle <> currencyStyle

func |> <A>(a: inout A, f: (inout A) -> Void) -> Void {
  f(&a)
}
config |> inoutDecimalStyle <> inoutCurrencyStyle
