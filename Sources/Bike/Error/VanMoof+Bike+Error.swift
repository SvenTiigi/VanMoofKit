import Foundation

// MARK: - VanMoof+Bike+Error

public extension VanMoof.Bike {
    
    /// A VanMoof Bike Error
    struct Error: Foundation.LocalizedError {
        
        // MARK: Properties
        
        /// A localized message describing what error occurred.
        public let errorDescription: String?
        
        /// The underlying error.
        public let underlyingError: Swift.Error?
        
        /// The function name where the error occurred
        public let function: String
        
        /// The line number where the error occurred
        public let line: Int
        
        // MARK: Initializer
        
        /// Creates a new instance of `VanMoof.Bike.Error`
        /// - Parameters:
        ///   - errorDescription: A localized message describing what error occurred. Default value `nil`
        ///   - underlyingError: The underlying error. Default value `nil`
        ///   - function: The function name where the error occurred. Default value `#function`
        ///   - line: The line number where the error occurred. Default value `#line`
        public init(
            errorDescription: String? = nil,
            underlyingError: Swift.Error? = nil,
            function: String = #function,
            line: Int = #line
        ) {
            self.errorDescription = errorDescription
                ?? underlyingError.flatMap(String.init(describing:))
                ?? "An error occurred in \(function)L:\(line)"
            self.underlyingError = underlyingError
            self.function = function
            self.line = line
        }
        
    }
    
}
