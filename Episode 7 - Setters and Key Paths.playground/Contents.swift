import Foundation

struct Food {
  var name: String
}

struct Location {
  var name: String
}

struct User {
  var favoriteFoods: [Food]
  var location: Location
  var name: String
}

let user = User(
  favoriteFoods: [Food(name: "Tacos"), Food(name: "Nachos")],
  location: Location(name: "Brooklyn"),
  name: "Blob"
)

User.init(favoriteFoods: user.favoriteFoods,
          location: Location(name: "Los Angeles"),
          name: user.name)

func first<A, B, C>(_ f: @escaping (A) -> B) -> ((A, C)) -> (B, C) {
  return { pair in
    (f(pair.0), pair.1)
  }
}


func userLocationName(_ f: @escaping (String) -> String) -> (User) -> User {
  return { user in
    User(
      favoriteFoods: user.favoriteFoods,
     location: Location(name: f(user.location.name)),
     name: user.name
   )
  }
}


user
  |> userLocationName { _ in "Los Angeles" }
  |> userLocationName { $0 + "!" }

\User.name // KeyPath<User, String>

user.name
user[keyPath: \User.name]

var copy = user
copy[keyPath: \User.name] = "Blobbo"

func prop<Root,  Value>(_ kp: WritableKeyPath<Root, Value>)
  -> (@escaping (Value) -> Value)
  -> (Root)
-> Root {

  return { update in
    return { root in
      var copy = root
      copy[keyPath: kp] = update(copy[keyPath: kp])
      return copy
    }
  }
}

prop(\User.name) // ((String) -> String) -> (User) -> User
(prop(\User.name))({ _ in "Blobbo"})

(prop(\User.name))({ $0.uppercased() })

prop(\User.location) <<< prop(\Location.name)
prop(\User.location.name)  // <- this is the same as the line above b/c keypaths are composable

user
  |> (prop(\User.name))({ $0.uppercased() })
  |> (prop(\User.location.name)) { _ in "Los Angeles" }

(42, user)
  |> (second <<< prop(\User.name)) { $0.uppercased() }
  |> first(incr)

user.favoriteFoods
  .map { Food(name: $0.name + " & Salad") }

let healthier = (prop(\User.favoriteFoods) <<< map <<< prop(\.name)) {
  $0 + " & Salad"
}

user 
  |> healthier
  |> healthier
  |> (prop(\.location.name)) { _ in "Miami" }
  |> (prop(\.name)) { "Healthy " + $0 }


(42, user)
  |> second(healthier)
  |> (second <<< prop(\.location.name)) { _ in "Miami" }
  |> (second <<< prop(\.name)) { "Healthy " + $0 }

