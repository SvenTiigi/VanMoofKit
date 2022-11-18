<br/>

<p align="center">
    <img src="https://raw.githubusercontent.com/SvenTiigi/VanMoofKit/gh-pages/readme-assets/logo.png?token=GHSAT0AAAAAABVGSLDOMXHVQQSD6CVMKINOY3X3VCQ" alt="logo" width="30%">
</p>

<h1 align="center">
    VanMoofKit
</h1>

<p align="center">
    A Swift Package to communicate with a VanMoof S3 Bike.
</p>

<p align="center">
   <img src="https://img.shields.io/badge/platform-iOS-F05138" alt="Platform">
   <a href="https://twitter.com/SvenTiigi/">
      <img src="https://img.shields.io/badge/Twitter-@SvenTiigi-blue.svg?style=flat" alt="Twitter">
   </a>
</p>

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
