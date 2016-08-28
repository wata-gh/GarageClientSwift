# GarageClientSwift

Swift client library for the [Garage](https://github.com/cookpad/garage) application API

## Requirements

- Swift 2.2
- Mac OS 10.10+
- iOS 8.0+
- watchOS 2.0+
- tvOS 9.0+

## Installation

### Carthage

1. Add `github "slightair/GarageClientSwift" ~> 1.1.0` to `Cartfile`
1. Run `carthage update`

## Usage

### 1. Define Garage resource model

```swift
struct User: Decodable {
    let id: Int
    let name: String
    let email: String

    static func decode(e: Extractor) throws -> User {
        return try User(
            id: e <| "id",
            name: e <| "name",
            email: e <| "email"
        )
    }
}
```

### 2. Define Garage request

```swift
struct GetUsersRequest: GarageRequestType {
    typealias Resource = [User]

    var method: HTTPMethod {
        return .GET
    }

    var path: String {
        return "/users"
    }

    var queryParameters: [String: AnyObject]? {
        return [
            "per_page": 1,
            "page": 2,
        ]
    }
}
```

### 3. Define Garage configuration

```swift
struct Configuration: GarageConfigurationType {
    let endpoint: NSURL
    let accessToken: String
}

let configuration = Configuration(
    endpoint: NSURL(string: "http://localhost:3000")!,
    accessToken: "YOUR ACCESS TOKEN"
)
```

### 4. Send request

```swift
let garageClient = GarageClient(configuration: configuration)
garageClient.sendRequest(GetUsersRequest()) { result in
    switch result {
    case .Success(let response):
        debugPrint(response)

        let users = response.resource
        debugPrint(users)
    case .Failure(let error):
        debugPrint(error)
    }
}
```

## License

GarageClientSwift is available under the MIT license. See the LICENSE file for more info.
