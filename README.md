# VanMoofKit

A Swift Package to communicate with a VanMoof S3 Bike.

```swift
import Foundation
import VanMoofKit

let vanMoof = VanMoof()

try await vanMoof.authenticate(
    using: .init(
        username: "knight.rider@vanmoof.com",
        password: "********"
    )
)

let bikes = try await vanMoof.bikes()

for bike in bikes {
    try await bike.connect()
    try await bike.play(sound: .bell)
}
```
