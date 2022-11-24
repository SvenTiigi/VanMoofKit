import Foundation

// MARK: - VanMoof+Bike+execute

public extension VanMoof.Bike {
    
    /// Executes an operation to a connected VanMoof Bike
    /// - Parameters:
    ///   - resultType: The result type.
    ///   - operation: A closure performing an operation on the connected VanMoof Bike.
    /// - Returns: The result.
    func execute<Result>(
        resultType: Result.Type = Result.self,
        operation: (VanMoof.Bike) async throws -> Result
    ) async throws -> Result {
        // Initialize a bool value if the bike is already connected
        // before the operation has been executed
        let isConnected = self.isConnected
        // Check if is not connected
        if !isConnected {
            // Try tot connect to the bike
            try await self.connect()
        }
        // Execute operation
        let result: Swift.Result<Result, Swift.Error> = await {
            do {
                // Try to perform the operation and return success
                return .success(try await operation(self))
            } catch {
                // Return failure
                return .failure(error)
            }
        }()
        // Check if bike was not connected before
        // the operation has been executed
        if !isConnected {
            // Disconnect from the bike in a child task
            Task {
                try await self.disconnect()
            }
        }
        // Return the result
        return try result.get()
    }
    
}
