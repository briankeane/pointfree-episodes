import UIKit

public final class GradientView: UIView {
  public var fromColor: UIColor = .clear {
    didSet {
      self.updateGradient()
    }
  }

  public var toColor: UIColor = .clear {
    didSet {
      self.updateGradient()
    }
  }

  private let gradientLayer = CAGradientLayer()

  public override init(frame: CGRect = .zero) {
    super.init(frame: frame)

    self.gradientLayer.locations = [0, 1]
    self.layer.insertSublayer(self.gradientLayer, at: 0)
  }

  public required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func updateGradient() {
    self.gradientLayer.colors = [fromColor.cgColor, toColor.cgColor]
  }

  public override func layoutSubviews() {
    self.gradientLayer.frame = self.bounds
  }
}

//precedencegroup ForwardApplication {
//  associativity: left
//}
//infix operator |>: ForwardApplication
//public func |> <A, B>(x: A, f: (A) -> B) -> B {
//  return f(x)
//}

//precedencegroup ForwardComposition {
//  associativity: left
//  higherThan: SingleTypeComposition
//}
//infix operator >>>: ForwardComposition
//public func >>> <A, B, C>(f: @escaping (A) -> B, g: @escaping (B) -> C) -> (A) -> C {
//  return { g(f($0)) }
//}

precedencegroup SingleTypeComposition {
  associativity: right
  higherThan: ForwardApplication
}
infix operator <>: SingleTypeComposition
public func <> <A>(f: @escaping (A) -> A, g: @escaping (A) -> A) -> (A) -> A {
  return f >>> g
}
public func <> <A>(f: @escaping (inout A) -> Void, g: @escaping (inout A) -> Void) -> (inout A) -> Void {
  return { a in
    f(&a)
    g(&a)
  }
}

public func <> <A: AnyObject>(f: @escaping (A) -> Void, g: @escaping (A) -> Void) -> (A) -> Void {
  return { a in
    f(a)
    g(a)
  }
}
