import Foundation

// MARK: - VanMoof+User

public extension VanMoof {
    
    /// A VanMoof User
    struct User: Hashable, Identifiable {
        
        // MARK: Properties
        
        /// The identifier.
        public let id: String
        
        /// The name of the user.
        public let name: String
        
        /// Bool value if user is confirmed.
        public let confirmed: Bool
        
        /// Bool value if privacy policy is accepted by the user.
        public let privacyPolicyAccepted: Bool
        
        /// The phone number.
        public let phone: String
        
        /// The country.
        public let country: String
        
        /// Bool value if the user has pending bike sharing invitations.
        public let hasPendingBikeSharingInvitations: Bool
        
        /// The Bikes of the user.
        public let bikes: [Bike]
        
        // MARK: Initializer
        
        /// Creates a new instance of `VanMoof.User`
        /// - Parameters:
        ///   - id: The identifier.
        ///   - name: The name of the user.
        ///   - confirmed: Bool value if user is confirmed.
        ///   - privacyPolicyAccepted: Bool value if privacy policy is accepted by the user.
        ///   - phone: The phone number.
        ///   - country: The country.
        ///   - hasPendingBikeSharingInvitations: Bool value if the user has pending bike sharing invitations.
        ///   - bikes: The Bikes of the user.
        public init(
            id: String,
            name: String,
            confirmed: Bool,
            privacyPolicyAccepted: Bool,
            phone: String,
            country: String,
            hasPendingBikeSharingInvitations: Bool,
            bikes: [Bike]
        ) {
            self.id = id
            self.name = name
            self.confirmed = confirmed
            self.privacyPolicyAccepted = privacyPolicyAccepted
            self.phone = phone
            self.country = country
            self.hasPendingBikeSharingInvitations = hasPendingBikeSharingInvitations
            self.bikes = bikes
        }
        
    }
    
}

// MARK: - Codable

extension VanMoof.User: Codable {
    
    /// The CodingKeys
    private enum CodingKeys: String, CodingKey {
        case id = "uuid"
        case name
        case confirmed
        case privacyPolicyAccepted
        case phone
        case country
        case hasPendingBikeSharingInvitations
        case bikes = "bikeDetails"
    }
    
}
