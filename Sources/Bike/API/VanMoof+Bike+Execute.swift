import Foundation

// MARK: - VanMoof+Bike+execute

public extension VanMoof.Bike {
    
    /// Executes an `operation` on a connected VanMoof Bike.
    /// If the bike is currently not connected this function will establish a communication to ensure the `operation`
    /// always gets executed on a connected `VanMoof.Bike` instance.
    /// After the operation has finished the bike gets disconnected if it wasn't previously not connected
    /// or by setting the `shouldDisconnectAfterOperationFinished` to `true`.
    /// - Parameters:
    ///   - resultType: The operation result type. Default value `OperationResult.self`
    ///   - shouldDisconnectAfterOperationFinished: The result type. Default value `false`
    ///   - operation: An asynchronous throwing closure performing an operation on a connected `VanMoof.Bike`.
    /// - Returns: The result.
    func execute<OperationResult>(
        resultType: OperationResult.Type = OperationResult.self,
        shouldDisconnectAfterOperationFinished: Bool = false,
        operation: (VanMoof.Bike) async throws -> OperationResult
    ) async throws -> OperationResult {
        // Initialize a bool value if the bike is already connected
        // before the operation has been executed
        let isConnected = self.isConnected
        // Check if is not connected
        if !isConnected {
            // Try tot connect to the bike
            try await self.connect()
        }
        // Execute operation
        let result: Result<OperationResult, Swift.Error> = await {
            do {
                // Try to perform the operation and return success
                return .success(try await operation(self))
            } catch {
                // Return failure
                return .failure(error)
            }
        }()
        // Check if should disconnect after operation finished
        // or if the bike was not connected before the operation has been executed
        if shouldDisconnectAfterOperationFinished || !isConnected {
            // Disconnect from the bike in a child task
            Task {
                try await self.disconnect()
            }
        }
        // Return the result
        return try result.get()
    }
    
}
