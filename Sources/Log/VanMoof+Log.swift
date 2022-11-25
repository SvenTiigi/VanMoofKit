import Foundation
import OSLog

// MARK: - VanMoof+Log

public extension VanMoof {
    
    /// The VanMoof Log
    enum Log {}
    
}

// MARK: - VanMoof+Log+isEnabled

public extension VanMoof.Log {
    
    /// Bool whether logging is enabled or disabled. Default value `false`
    static var isEnabled = false
    
}

// MARK: - VanMoof+Log+log

extension VanMoof.Log {
    
    /// Log a message.
    /// - Parameters:
    ///   - message: The message that should be logged.
    ///   - type: The OSLogType. Default value `.default`
    static func log(
        message: String,
        type: OSLogType = .default
    ) {
        // Verify logging is enabled
        guard self.isEnabled else {
            // Otherwise return out of function
            return
        }
        // Log
        os_log(
            "%@",
            log: .vanMoofKit,
            type: type,
            message
        )
    }
    
}

// MARK: - OSLog+vanMoofKit

private extension OSLog {
    
    /// The VanMoofKit OSLog container.
    static let vanMoofKit = OSLog(
        subsystem: "VanMoofKit",
        category: "VanMoofKit"
    )
    
}
