import Combine
import Foundation

// MARK: - VanMoof+Bike+SignalStrength

public extension VanMoof.Bike {
    
    /// A VanMoof Bike SignalStrength.
    struct SignalStrength: Codable, Hashable, Sendable {
        
        // MARK: Properties
        
        /// The signal strength measured in decibels.
        public let decibels: Int
        
        // MARK: Initializer
        
        /// Creates a new instance of `VanMoof.Bike.SignalStrength`
        /// - Parameter decibels: The signal strength measured in decibels.
        public init(
            decibels: Int
        ) {
            self.decibels = decibels
        }
        
    }
    
}

// MARK: - VanMoof+Bike+SignalStrength+ExpressibleByIntegerLiteral

extension VanMoof.Bike.SignalStrength: ExpressibleByIntegerLiteral {
    
    /// Creates a new instance of `VanMoof.Bike.SignalStrength`
    /// - Parameter value: The integer literal value
    public init(
        integerLiteral value: Int
    ) {
        self.init(decibels: value)
    }
    
}

// MARK: - VanMoof+Bike+SignalStrength+level

public extension VanMoof.Bike.SignalStrength {
    
    /// The SignalStrength Level.
    var level: Level {
        switch self.decibels {
        case (-55)...:
            return .good
        case (-67)...:
            return .fair
        case (-90)...:
            return .poor
        default:
            return .bad
        }
    }
    
    /// A SignalStrength Level.
    enum Level: Codable, Hashable, CaseIterable, Sendable {
        /// Bad signal strength.
        case bad
        /// Poor signal strength.
        case poor
        /// Fair signal strength.
        case fair
        /// Good signal strength.
        case good
    }
    
}

// MARK: - VanMoof+Bike+signalStrength

public extension VanMoof.Bike {
    
    /// The current SignalStrength.
    var signalStrength: SignalStrength {
        get async throws {
            .init(
                decibels: try await self
                    .bluetoothManager
                    .readRSSI()
                    .intValue
            )
        }
    }
    
}

// MARK: - VanMoof+Bike+signalStrengthPublisher

public extension VanMoof.Bike {
    
    /// A Publisher that emits the current SignalStrength.
    /// - Parameter updateInterval: The time interval in which the signal strength should be read.
    func signalStrengthPublisher(
        updateInterval: TimeInterval = 5
    ) -> AnyPublisher<SignalStrength, Never> {
        Just(
            .init()
        )
        .append(
            Timer
                .publish(
                    every: updateInterval,
                    on: .main,
                    in: .common
                )
                .autoconnect()
        )
        .flatMap { [weak self] _ in
            Future { [weak self] promise in
                guard let self = self else {
                    return
                }
                Task {
                    guard let signalStrength = try? await self.signalStrength else {
                        return
                    }
                    promise(.success(signalStrength))
                }
            }
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
    
}
