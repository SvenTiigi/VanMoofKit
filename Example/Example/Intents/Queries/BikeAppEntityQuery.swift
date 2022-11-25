import AppIntents
import Foundation
import VanMoofKit

// MARK: - BikeAppEntityQuery

/// A Bike AppEntity Query
struct BikeAppEntityQuery {}

// MARK: - EntityQuery

extension BikeAppEntityQuery: EntityStringQuery {
    
    /// Retrieves instances by string.
    /// - Parameters:
    ///    - string: "Name" used to refer to an entity instance (or a set thereof).
    func entities(
        matching string: String
    ) async throws -> [BikeAppEntity] {
        try await BikeAppEntity
            .bikes
            .filter { $0.name.localizedCaseInsensitiveContains(string) }
            .map(BikeAppEntity.init)
    }
    
    /// Retrieves instances by identifier.
    /// - Parameters:
    ///    - identifiers: Array of entity identifiers
    func entities(
        for identifiers: [BikeAppEntity.ID]
    ) async throws -> [BikeAppEntity] {
        try await BikeAppEntity
            .bikes
            .filter { identifiers.contains($0.id) }
            .map(BikeAppEntity.init)
    }
    
    /// Returns the initial results shown when a list of options backed by this query is presented.
    func suggestedEntities() async throws -> [BikeAppEntity] {
        try await BikeAppEntity
            .bikes
            .map(BikeAppEntity.init)
    }
    
    /// The default value for parameters using this provider when no value is provided by the user.
    func defaultResult() async -> BikeAppEntity? {
        try? await BikeAppEntity
            .bikes
            .first
            .map(BikeAppEntity.init)
    }
    
}
