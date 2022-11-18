import Foundation

// MARK: - VanMoof+Bike+Details+Permission

public extension VanMoof.Bike.Details {
    
    /// A VanMoof Bike Details Permission
    struct Permission: Hashable {
        
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

// MARK: - Well-Known

public extension VanMoof.Bike.Details.Permission {
    
    static let addUser = "ADD_USER"
    
    static let firmwareUpdates = "FIRMWARE_UPDATES"
    
    static let removeUser = "REMOVE_USER"
    
    static let reportFound = "REPORT_FOUND"
    
    static let reportStolen = "REPORT_STOLEN"
    
    static let sendStatistics = "SEND_STATISTICS"
    
    static let backupCode = "BACKUP_CODE"
    
    static let bikeName = "BIKE_NAME"
    
    static let viewTheftCases = "VIEW_THEFT_CASES"
    
    static let alarmSettings = "ALARM_SETTINGS"
    
    static let countrySettings = "COUNTRY_SETTINGS"
    
    static let lights = "LIGHTS"
    
    static let motorSupportLevel = "MOTOR_SUPPORT_LEVEL"
    
    static let unlock = "UNLOCK"
    
    static let readValues = "READ_VALUES"
    
    static let stolenMode = "STOLEN_MODE"
    
    static let swapSmartmodule = "SWAP_SMARTMODULE"
    
}


