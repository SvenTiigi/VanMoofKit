import AppIntents
import Foundation
import VanMoofKit

// MARK: - BikeAppEntity

/// A Bike AppEntity
struct BikeAppEntity {
    
    /// The identifier.
    let id: VanMoof.Bike.ID
    
    /// The name of the bike.
    let name: String
    
    /// The frame number.
    let frameNumber: String
    
    /// The optional thumbnail URL
    let thumbnailURL: URL?
    
}

// MARK: - BikeAppEntity+init(bike:)

extension BikeAppEntity {
    
    /// Creates a new instance of `BikeAppEntity`
    /// - Parameter bike: The VanMoof Bike.
    init(
        bike: VanMoof.Bike
    ) {
        self.init(
            id: bike.id,
            name: bike.name,
            frameNumber: bike.frameNumber,
            thumbnailURL: bike.links?.thumbnail
        )
    }
    
}

// MARK: - AppEntity

extension BikeAppEntity: AppEntity {
    
    /// Default query to use to retrieve instances of this type (by identifier, name and more).
    static let defaultQuery = BikeAppEntityQuery()
    
    /// A short, localized, human-readable name for the type.
    static let typeDisplayRepresentation = TypeDisplayRepresentation(
        name: "Bike",
        numericFormat: "\(placeholder: .int) bikes"
    )
    
    /// The visual elements to display when presenting an instance of the type.
    var displayRepresentation: DisplayRepresentation {
        .init(
            title: .init(stringLiteral: self.name),
            subtitle: .init(stringLiteral: self.frameNumber),
            image: self.thumbnailURL.flatMap { .init(url: $0) }
        )
    }
    
}

// MARK: - BikeAppEntity+bikes

extension BikeAppEntity {
    
    /// All available VanMoof Bikes.
    static var bikes: [VanMoof.Bike] {
        get async throws {
            // Check if a user is available
            if let user = try? App.ViewModel.default.user?.get() {
                // Return bikes of user
                return user.bikes
            } else {
                // Otherwise load bikes
                return try await App.ViewModel.default.vanMoof.bikes()
            }
        }
    }
    
}

// MARK: - BikeAppEntity+bike

extension BikeAppEntity {
    
    /// The VanMoof Bike
    var bike: VanMoof.Bike {
        get async throws {
            // Verify bike is available by the identifier of the entity
            guard let bike = try await Self.bikes.first(where: { $0.id == self.id }) else {
                // Otherwise throw an error
                throw VanMoof.Bike.Error(
                    errorDescription: "Couldn't find a bike with the identifier \(self.id)"
                )
            }
            // Return the matching bike
            return bike
        }
    }
    
}
