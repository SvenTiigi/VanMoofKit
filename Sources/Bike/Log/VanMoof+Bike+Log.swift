import Foundation
import OSLog

// MARK: - VanMoof+Bike+Log

public extension VanMoof.Bike {
    
    /// The VanMoof Bike Log
    enum Log {}
    
}

// MARK: - VanMoof+Bike+Log+log

extension VanMoof.Bike.Log {
    
    /// Log a message.
    /// - Parameters:
    ///   - message: The message that should be logged.
    ///   - type: The OSLogType. Default value `.default`
    static func log(
        message: String,
        type: OSLogType = .default
    ) {
        // Verify logging is enabled
        guard VanMoof.Bike.Configuration.isLoggingEnabled else {
            // Otherwise return out of function
            return
        }
        // Log
        os_log(
            "%@",
            log: .init(
                subsystem: "VanMoofKit",
                category: "Bike"
            ),
            type: type,
            message
        )
    }
    
}
