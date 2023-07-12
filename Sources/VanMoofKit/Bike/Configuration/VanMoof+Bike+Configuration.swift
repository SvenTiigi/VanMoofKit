import Foundation

// MARK: - VanMoof+Bike+Configuration

public extension VanMoof.Bike {

    /// A VanMoof Bike Configuration namespace enum
    enum Configuration {}
    
}

// MARK: - VanMoof+Bike+Configuration+timeoutInterval

public extension VanMoof.Bike.Configuration {
    
    /// The default timeout interval in seconds. Default value `30`
    static var timeoutInterval: TimeInterval = 30
    
}

// MARK: - VanMoof+Bike+Configuration+isAutoReconnectEnabled

public extension VanMoof.Bike.Configuration {
    
    /// Bool value whether auto reconnecting is enabled or disabled
    /// whenever the connection timed out. Default value `true`
    static var isAutoReconnectEnabled = true
    
}

// MARK: - VanMoof+Bike+Configuration+isLoggingEnabled

public extension VanMoof.Bike.Configuration {
    
    /// Bool value whether logging is enabled or disabled. Default value `false`
    static var isLoggingEnabled = false
    
}
