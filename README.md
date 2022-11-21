<br/>

<p align="center">
    <img src="https://raw.githubusercontent.com/SvenTiigi/VanMoofKit/gh-pages/readme-assets/logo.png?token=GHSAT0AAAAAABVGSLDPMPVC3DHMVG75WVIQY33Y6YQ" alt="logo" width="30%">
</p>

<h1 align="center">
    VanMoofKit
</h1>

<p align="center">
    A Swift Package to communicate with a VanMoof S3 & X3 Bike.
</p>

<p align="center">
   <a href="https://github.com/SvenTiigi/VanMoofKit/actions/workflows/ci.yml">
       <img src="https://github.com/SvenTiigi/VanMoofKit/actions/workflows/ci.yml/badge.svg" alt="CI status">
   </a>
   <img src="https://img.shields.io/badge/Platform-iOS%20%7C%20tvOS%20%7C%20macOS%20%7C%20watchOS-F05138" alt="Platform">
   <a href="https://twitter.com/SvenTiigi/">
      <img src="https://img.shields.io/badge/Twitter-@SvenTiigi-blue.svg?style=flat" alt="Twitter">
   </a>
</p>

```swift
import Foundation
import VanMoofKit

let vanMoof = VanMoof()

try await vanMoof.login(
    username: "knight.rider@vanmoof.com",
    password: "********"
)

let bikes = try await vanMoof.bikes()

for bike in bikes {
    try await bike.connect()
    try await bike.play(sound: .bell)
}
```

## Features

- [x] Easily read information about your VanMoof Bike.

## Example

Check out the example application to see VanMoofKit in action. Simply open the `Example/Example.xcodeproj` and run the "Example" scheme.

## Installation

### Swift Package Manager

To integrate using Apple's [Swift Package Manager](https://swift.org/package-manager/), add the following as a dependency to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/SvenTiigi/VanMoofKit.git", from: "0.0.1")
]
```

Or navigate to your Xcode project then select `Swift Packages`, click the “+” icon and search for `VanMoofKit`.

> Please ensure to add the [`NSBluetoothAlwaysUsageDescription`](https://developer.apple.com/documentation/bundleresources/information_property_list/nsbluetoothalwaysusagedescription) key to your Info.plist.

## Usage

`t.b.d`

## License

```
VanMoofKit
Copyright (c) 2022 Sven Tiigi sven.tiigi@gmail.com

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
```
