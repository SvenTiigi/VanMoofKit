<br/>

<p align="center">
    <img src="Assets/logo.png" alt="logo" width="30%">
</p>

<h1 align="center">
    VanMoofKit
</h1>

<p align="center">
    A Swift Package to communicate with a <a href="https://vanmoof.com/s3">VanMoof S3 & X3 Bike</a> 🚲
</p>

<p align="center">
   <a href="https://swiftpackageindex.com/SvenTiigi/VanMoofKit">
    <img src="https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FSvenTiigi%2FVanMoofKit%2Fbadge%3Ftype%3Dswift-versions" alt="Swift Version">
   </a>
   <a href="https://swiftpackageindex.com/SvenTiigi/VanMoofKit">
    <img src="https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FSvenTiigi%2FVanMoofKit%2Fbadge%3Ftype%3Dplatforms" alt="Platforms">
   </a>
   <br/>
   <a href="https://github.com/SvenTiigi/VanMoofKit/actions/workflows/build_and_test.yml">
       <img src="https://github.com/SvenTiigi/VanMoofKit/actions/workflows/build_and_test.yml/badge.svg" alt="Build and Test Status">
   </a>
   <a href="https://sventiigi.github.io/VanMoofKit/documentation/vanmoofkit/">
       <img src="https://img.shields.io/badge/Documentation-DocC-blue" alt="Documentation">
   </a>
   <a href="https://twitter.com/SvenTiigi/">
      <img src="https://img.shields.io/badge/Twitter-@SvenTiigi-blue.svg?style=flat" alt="Twitter">
   </a>
</p>

<img align="right" width="307" src="Assets/example-app.png" alt="Example application">

```swift
import VanMoofKit

let vanMoof = VanMoof()

try await vanMoof.login(
    username: "knight.rider@vanmoof.com",
    password: "********"
)

let bikes = try await vanMoof.bikes()

for bike in bikes {
    try await bike.connect()
    try await bike.playSound()
}
```

## Disclaimer

> VanMoofKit is not an official library of [VanMoof B.V](https://vanmoof.com). This Swift Package makes certain features of the bike accessible which may be illegal to use in certain jurisdictions. As this library hasn't reached an official stable version some features are not yet available or may not working as expected.

## Features

- [x] Access the VanMoof Web API through native Swift Code 👨‍💻👩‍💻
- [x] Establish a bluetooth connection to a VanMoof Bike using async/await 🚲.
- [x] Easily change the configuration of the bike such as bell sound, power level, light mode and many more ⚙️
- [x] Combine support to react to changes of certain functions ⛓️

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

## Info.plist

As the VanMoofKit is using the [`CoreBluetooth`](https://developer.apple.com/documentation/corebluetooth) framework to establish a [BLE](https://wikipedia.org/wiki/Bluetooth_Low_Energy) connection to a bike the [`NSBluetoothAlwaysUsageDescription`](https://developer.apple.com/documentation/bundleresources/information_property_list/nsbluetoothalwaysusagedescription) key needs to be added to the Info.plist of your application.

```xml
<key>NSBluetoothAlwaysUsageDescription</key>
<string>Establishing a bluetooth connection to your VanMoof Bike.</string>
```

## VanMoof

To retrieve bikes of a VanMoof account you first need to initialize an instance of `VanMoof`.

```swift
let vanMoof = VanMoof()
```

To authenticate simply call the `login` function on instance of a `VanMoof` object.

```swift
try await vanMoof.login(
    username: "kight.rider@vanmoof.com",
    password: "********"
)
```

> **Note**: The login credentials aren't persisted or logged they are only used to authenticate against the VanMoof API.

Make use of the `vanMoof.isAuthenticated` property to check if the user is already logged in.

```swift
if vanMoof.isAuthenticated {
    // ...
}
```

The login produces a `VanMoof.Token` which is automatically stored in an instance of a `VanMoofTokenStore`. You can configure the persistence of the token when creating an instance of `VanMoof`.

```swift
let vanMoof = VanMoof(
    // Specify an instance which conforms to the `VanMoofTokenStore` protocol.
    // Predefined implementations:
    // - KeychainVanMoofTokenStore
    // - UbiquitousVanMoofTokenStore (iCloud Key-Value Store)
    // - UserDefaultsVanMoofTokenStore
    // - InMemoryVanMoofTokenStore
    tokenStore: UserDefaultsVanMoofTokenStore()
)
```

> **Note**: In default the `UserDefaultsVanMoofTokenStore` will be used to store the `VanMoof.Token`.

After the login has succeeded you can retrieve the user profile and the associated bikes.

```swift
// Retrieve the user
let user: VanMoof.User = try await vanMoof.user()
print("Available Bikes", user.bikes)

// If you want to directly retrieve the bikes call:
let bikes: [VanMoof.Bike] = try vanMoof.bikes()
```

To logout the current user call:

```swift
vanMoof.logout()
```

> **Note**: Logging out an user has no effect on any available VanMoof.Bike instance. It is the developer responsibility to terminate any open connection to a VanMoof.Bike.

## VanMoof.Bike 🚲

Some information such as the name of the bike, frame number and more are available without an active connection to the bike. You can access those information via the `bike.details` property.

```swift
let details: VanMoof.Bike.Details = bike.details
print(details.name)
print(details.macAddress)
print(details.frameNumber)

// Or access the details properties directly
// (powered by the @dynamicMemberLookup attribute)
print(bike.name, bike.macAddress, bike.frameNumber)
```

### Connection

To establish a connection to a `VanMoof.Bike` call:

```swift
// Try to connect to the bike
try await bike.connect()
```

You can retrieve the current state of the connection in the following way.

```swift
// Switch on connectionState
switch bike.connectionState {
case .disconnected:
    print("Disconnected")
case .discovering:
    print("Disconvering / Searching")
case .connecting:
    print("Connecting")
case .connected:
    print("Connected")
case .disconnecting:
    print("Disconnecting")
}

// Or make use of convience properties such as:
let isConnected: Bool = bike.isConnected
let isDisconnected: Bool = bike.isDiconnected

// Alternatively you can use a Publisher
bike.connectionStatePublisher
    .sink { connectionState in
        // ...
    }

// Or a specialized publisher which only emits connection errors
bike.connectionErrorPublisher
    .sink { connectionError in
        // ...
    }
```

Additionally, you can monitor the signal strength of the connection via:

```swift
// Retrieve the current signal strength
let signalStrength: VanMoof.Bike.SignalStrength = try await bike.signalStrength

// A Publisher that emits the current signal strength in a given update interval
bike.signalStrengthPublisher(
    updateInterval: 5
).sink { signalStrength in
    // ...
}
```

If you wish to terminate the connection simply call:

```swift
// Disconnect from the bike
try await bike.disconnect()
```

### ModuleState

```swift
switch try await bike.moduleState {
case .on:
    break
case .off:
    break
default:
    break
}

bike.moduleStatePublisher.sink { moduleState in
    // ...
}

try await bike.set(moduleState: .on)

// Alias for setting the module state to on
try await bike.wakeUp()
```

### LockState

```swift
switch try await bike.lockState {
case .unlocked:
    break
case .locked:
    break
case .awaitingUnlock:
    break
}

bike.lockStatePublisher.sink { lockState in
    // ...
}

// Unlock Bike
try await bike.unlock()
```

### Battery Level

```swift
let batteryLevel = try await bike.batteryLevel

bike.batteryLevelPublisher.sink { batteryLevel in
    // ...
}
```

### Battery State

```swift
switch try await bike.batteryState {
case .notCharging;
    break
case .charging:
    break
}

bike.batteryStatePublisher.sink { batteryState in
    // ...
}
```

### Speed Limit

```swift
switch try await bike.speedLimit {
case .europe:
    print("Europe 25 km/h")
case .unitedStates:
    print("United States 32 km/h")
case .japan:
    print("Japan 24 km/h")
}

bike.speedLimitPublisher.sink { speedLimit in
    // ...
}
```

> **Warning**: Changing the speed limit may be illegal in certain jurisdictions.

```swift
try await bike.set(speedLimit: .unitedStates)
```

### Power Level

```swift
switch try await bike.powerLevel {
case .off:
    break
case .one:
    break
case .two:
    break
case .three:
    break
case .four:
    break
}

bike.powerLevelPublisher.sink { powerLevel in
    // ...
}

try await bike.set(powerLevel: .four)
```

### Light Mode

```swift
switch try await bike.lightMode {
case .auto:
    break
case .alwaysOn:
    break
case .off:
    break
}

bike.lightModePublisher.sink { lightMode in
    // ...
}

try await bike.set(lightMode: .alwaysOn)
```

### Bell Sound

```swift
switch try await bike.bellSound {
case .sonar:
    break
case .bell:
    break
case .party:
    break
case .foghorn:
    break
}

bike.bellSoundPublisher.sink { bellSound in
    // ...
}

try await bike.set(bellSound: .party)
```

### Play Sound

```swift
try await bike.play(sound: .scrollingTone)
try await bike.play(sound: .beepPositive)
try await bike.play(sound: .alarmStageOne)
```

### Sound Volume

```swift
// An integer in the range from 0 to 100
let soundVolume: Int = try await bike.soundVolume
```

### Total Distance

```swift
let totalDistance: VanMoof.Bike.Distance = try await bike.totalDistance

bike.totalDistancePublisher.sink { totalDistance in
    // ...
}
```

### Unit System

```swift
switch try await bike.unitSystem {
case .metric:
    break
case .imperial:
    break
}

bike.unitSystemPublisher.sink { unitSystem in
    // ...
}

try await bike.set(unitSystem: .metric)
```

### Firmware Versions

```swift
let bikeFirmwareVersion: String = try await bike.firmwareVersion
let bleChipFirmwareVersion: String = try await bike.bleChipFirmwareVersion
let eShifterFirmwareVersion: String = try await bike.eShifterFirmwareVersion
```

## Credits

#### AES ECB Crypto

- [CryptoSwift](https://github.com/krzyzanowskim/CryptoSwift)

#### VanMoof Bike Bluetooth API Reverse Engineering

- [pymoof](https://github.com/quantsini/pymoof)
- [vanbike-lib](https://github.com/Poket-Jony/vanbike-lib)
- [Mooovy](https://github.com/mjarkk/vanmoof-web-controller)

#### GitHub Workflow Files and Issue Templates

- [Runestone](https://github.com/simonbs/Runestone)

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
