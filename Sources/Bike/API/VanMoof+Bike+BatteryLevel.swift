import Combine
import Foundation

// MARK: - VanMoof+Bike+BatteryLevel

public extension VanMoof.Bike {
    
    /// A VanMoof Bike BatteryLevel
    struct BatteryLevel: Codable, Hashable {
        
        // MARK: Properties
        
        /// The battery level
        public let level: Int
        
        // MARK: Initializer
        
        /// Creates a new instance of `VanMoof.Bike.BatteryLevel`
        /// - Parameter level: The battery level in a range from 0 to 100
        public init(
            _ level: Int
        ) {
            self.level = max(
                Self.range.lowerBound,
                min(
                    Self.range.upperBound,
                    level
                )
            )
        }
        
    }
    
}

// MARK: - VanMoof+Bike+BatteryLevel+ExpressibleByIntegerLiteral

extension VanMoof.Bike.BatteryLevel: ExpressibleByIntegerLiteral {
    
    /// Creates a new instance of `VanMoof.Bike.BatteryLevel`
    /// - Parameter level: The battery level integer literal
    public init(
        integerLiteral level: Int
    ) {
        self.init(level)
    }
    
}

// MARK: - VanMoof+Bike+BatteryLevel+range

public extension VanMoof.Bike.BatteryLevel {
    
    /// The battery level range.
    static let range = 0...100
    
    /// The battery level range.
    var range: ClosedRange<Int> {
        Self.range
    }
    
}

// MARK: - VanMoof+Bike+BatteryLevel+formatted

public extension VanMoof.Bike.BatteryLevel {
    
    /// The unit symbole `%`
    static let unitSymbol: String = NumberFormatter().percentSymbol
    
    /// The unit symbole `%`
    var unitSymbol: String {
        Self.unitSymbol
    }
    
    /// Generates a locale-aware string representation of a battery level.
    /// - Parameter numberFormatter: The NumberFormatter. Default value `.init()`
    func formatted(
        numberFormatter: NumberFormatter = .init()
    ) -> String {
        numberFormatter.numberStyle = .percent
        return numberFormatter
            .string(
                from: (Double(self.level) / Double(Self.range.upperBound)) as NSNumber
            )
            ?? "\(self.level)\(Self.unitSymbol)"
    }
    
}

// MARK: - VanMoof+Bike+batteryLevel

public extension VanMoof.Bike {
    
    /// The battery level.
    var batteryLevel: BatteryLevel {
        get async throws {
            .init(
                try await self.bluetoothManager.read(
                    characteristic: BluetoothServices
                        .Info
                        .MotorBatteryLevelCharacteristic
                        .self
                )
                .batteryLevel
            )
        }
    }
    
}

// MARK: - VanMoof+Bike+batteryLevelPublisher

public extension VanMoof.Bike {
    
    /// A Publisher that emits the battery level whenever a change occurred.
    var batteryLevelPublisher: AnyPublisher<BatteryLevel, Never> {
        self.bluetoothManager
            .publisher(
                for: BluetoothServices
                    .Info
                    .MotorBatteryLevelCharacteristic
                    .self
            )
            .map(\.batteryLevel)
            .removeDuplicates()
            .map { BatteryLevel($0) }
            .eraseToAnyPublisher()
    }
    
}
