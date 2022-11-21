import Combine
import Foundation

// MARK: - VanMoof+Bike+ErrorCode

public extension VanMoof.Bike {
    
    /// A VanMoof Bike ErrorCode
    struct ErrorCode: Codable, Hashable {
        
        // MARK: Properties
        
        /// The code.
        public let code: Int
        
        // MARK: Initializer
        
        /// Creates a new instance of `VanMoof.Bike.ErrorCode`
        /// - Parameter code: The code.
        public init(
            code: Int
        ) {
            self.code = code
        }
        
    }
    
}

// MARK: - VanMoof+Bike+ErrorCode+ExpressibleByIntegerLiteral

extension VanMoof.Bike.ErrorCode: ExpressibleByIntegerLiteral {
    
    /// Creates a new instance of `VanMoof.Bike.ErrorCode`
    /// - Parameter value: The value
    public init(
        integerLiteral value: Int
    ) {
        self.init(code: value)
    }
    
}

// MARK: - VanMoof+Bike+ErrorCode+WellKnown

public extension VanMoof.Bike.ErrorCode {
    
    /// No error.
    static let noError: Self = 0
    
    /// Motor stalled.
    static let motorStalled: Self = 1
    
    /// Over voltage.
    static let overVoltage: Self = 2
    
    /// Under voltage.
    static let underVoltage: Self = 3
    
    /// Motor fast.
    static let motorFast: Self = 5
    
    /// Over current.
    static let overCurrent: Self = 6
    
    /// Torque abnormal.
    static let torqueAbnormal: Self = 7
    
    /// Torque initial abnormal.
    static let torqueInitialAbnormal: Self = 8
    
    /// Over temperature.
    static let overTemperature: Self = 9
    
    /// Hall arrangement mismatch.
    static let hallArrangementMismatch: Self = 16
    
    /// I2C bus error.
    static let i2cBusError: Self = 25
    
    /// GSM UART timeout.
    static let gsmUARTTimeout: Self = 26
    
    /// Controller UART timeout.
    static let controllerUARTTimeout: Self = 27
    
    /// GSM registration failure
    static let gsmRegistrationFailure: Self = 28
    
    /// No battery output.
    static let noBatteryOutput: Self = 29
    
}

// MARK: - VanMoof+Bike+errorCode

public extension VanMoof.Bike {
    
    /// The ErrorCode
    var errorCode: ErrorCode {
        get async throws {
            try await self.bluetoothManager
                .read(
                    characteristic: BluetoothServices
                        .State
                        .ErrorsCharacteristic
                        .self
                )
                .errorCode
        }
    }
    
}

// MARK: - VanMoof+Bike+errorCodePublisher

public extension VanMoof.Bike {
    
    /// A Publisher that emits the ErrorCode whenever a change occurred.
    var errorCodePublisher: AnyPublisher<ErrorCode, Never> {
        self.bluetoothManager
            .publisher(
                for: BluetoothServices
                    .State
                    .ErrorsCharacteristic
                    .self
            )
            .map(\.errorCode)
            .removeDuplicates()
            .eraseToAnyPublisher()
    }
    
}
