import Foundation

// MARK: - VanMoof+Bike+Details+Permission

public extension VanMoof.Bike.Details {
    
    /// A VanMoof Bike Details Permission
    struct Permission: Hashable, Sendable {
        
        // MARK: Properties
        
        /// The value.
        public let value: String
        
        // MARK: Initializer
        
        /// Creates a new instance of `VanMoof.Bike.Details.Permission`
        /// - Parameter value: The value.
        public init(
            _ value: String
        ) {
            self.value = value
        }
        
    }
    
}

// MARK: - ExpressibleByStringLiteral

extension VanMoof.Bike.Details.Permission: ExpressibleByStringLiteral {
    
    /// Creates a new instance of `VanMoof.Bike.Details.Permission`
    /// - Parameter value: The string literal value
    public init(
        stringLiteral value: String
    ) {
        self.init(value)
    }
    
}

// MARK: - Codable

extension VanMoof.Bike.Details.Permission: Codable {
    
    /// Creates a new instance of `VanMoof.Bike.Details.Permission`
    /// - Parameter decoder: The Decoder.
    public init(
        from decoder: Decoder
    ) throws {
        let container = try decoder.singleValueContainer()
        self.init(try container.decode(String.self))
    }
    
    /// Encode
    /// - Parameter encoder: The Encoder
    public func encode(
        to encoder: Encoder
    ) throws {
        var container = encoder.singleValueContainer()
        try container.encode(self.value)
    }
    
}

// MARK: - CustomStringConvertible

extension VanMoof.Bike.Details.Permission: CustomStringConvertible {
    
    /// A textual representation of this instance.
    public var description: String {
        self.value
    }
    
}

// MARK: - Well-Known

public extension VanMoof.Bike.Details.Permission {
    
    /// The `Add User` Permission
    static let addUser = "ADD_USER"
    
    /// The `Firmware Update` Permission
    static let firmwareUpdates = "FIRMWARE_UPDATES"
    
    /// The `Remove User` Permission
    static let removeUser = "REMOVE_USER"
    
    /// The `Report Found` Permission
    static let reportFound = "REPORT_FOUND"
    
    /// The `Report Stolen` Permission
    static let reportStolen = "REPORT_STOLEN"
    
    /// The `Send Statistics` Permission
    static let sendStatistics = "SEND_STATISTICS"
    
    /// The `Backup Code` Permission
    static let backupCode = "BACKUP_CODE"
    
    /// The `Bike Name` Permission
    static let bikeName = "BIKE_NAME"
    
    /// The `View Theft Cases` Permission
    static let viewTheftCases = "VIEW_THEFT_CASES"
    
    /// The `Alarm Settings` Permission
    static let alarmSettings = "ALARM_SETTINGS"
    
    /// The `Country Settings` Permission
    static let countrySettings = "COUNTRY_SETTINGS"
    
    /// The `Lights` Permission
    static let lights = "LIGHTS"
    
    /// The `Motor Support Level` Permission
    static let motorSupportLevel = "MOTOR_SUPPORT_LEVEL"
    
    /// The `Unlock` Permission
    static let unlock = "UNLOCK"
    
    /// The `Read Values` Permission
    static let readValues = "READ_VALUES"
    
    /// The `Stolen Mode` Permission
    static let stolenMode = "STOLEN_MODE"
    
    /// The `Swap Smart Module` Permission
    static let swapSmartmodule = "SWAP_SMARTMODULE"
    
}


