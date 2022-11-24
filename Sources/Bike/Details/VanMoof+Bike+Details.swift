import Foundation

// MARK: - VanMoof+Bike+Details

public extension VanMoof.Bike {
    
    /// The VanMoof Bike Details
    struct Details: Codable, Hashable, Identifiable, Sendable {
        
        // MARK: Properties
        
        /// The identifier.
        public let id: Int
        
        /// The name.
        public let name: String
        
        /// The frame number.
        public let frameNumber: String
        
        /// The bike identifier.
        public let bikeId: String
        
        /// The frame serial.
        public let frameSerial: String?
        
        /// The name of the owner
        public let ownerName: String
        
        /// The trip distance.
        public let tripDistance: Int
        
        /// The pending smart module mac address.
        public let pendingSmartmoduleMacAddress: String?
        
        /// The mac address.
        public let macAddress: String
        
        /// The main ecu serial.
        public let mainEcuSerial: String?
        
        /// The smart module current verison.
        public let smartmoduleCurrentVersion: String
        
        /// The smart module desired version.
        public let smartmoduleDesiredVersion: String?
        
        /// Bool if backup code has changed.
        public let changeBackupCode: Bool
        
        /// Bool value if tracking is active.
        public let isTracking: Bool
        
        /// The highest available speed limit.
        public let highestAvailableSpeedLimit: Int?
        
        /// Bool value if a message is available.
        public let messageAvailable: Bool
        
        /// The model name.
        public let modelName: String
        
        /// The model details.
        public let modelDetails: ModelDetails
        
        /// The model color.
        public let modelColor: ModelColor
        
        /// The frame shape.
        public let frameShape: String
        
        /// The manufacturer.
        public let manufacturer: String
        
        /// The controller.
        public let controller: String?
        
        /// The update method.
        public let updateMethod: String
        
        /// Bool value if eLock is available.
        public let eLock: Bool
        
        /// The GSM module.
        public let gsmModule: String
        
        /// Bool value if speaker is available.
        public let speaker: Bool
        
        /// The bluetooth profile.
        public let bleProfile: String
        
        /// The bluetooth version.
        public let bleVersion: String?
        
        /// The messages via bluetooth.
        public let messagesViaBLE: String
        
        /// The customer role family.
        public let customerRoleFamily: String
        
        /// The customer role.
        public let customerRole: String
        
        /// The permissions.
        public let permissions: [Permission]

        /// The Key.
        public let key: Key
        
        /// Bool value if is factory key.
        public let isFactoryKey: Bool
        
        /// The count of customers.
        public let customerCount: Int
        
        /// The count of invitations.
        public let invitationCount: Int
        
        /// Bool value if peace of mind is available.
        public let hasPeaceOfMind: Bool
        
        /// The links.
        public let links: Links?
        
        // MARK: Initializer
        
        /// Creates a new instance of `VanMoof.Bike.Details`
        /// - Parameters:
        ///   - id: The identifier.
        ///   - name: The name.
        ///   - frameNumber: The frame number.
        ///   - bikeId: The bike identifier.
        ///   - frameSerial: The frame serial.
        ///   - ownerName: The name of the owner
        ///   - tripDistance: The trip distance.
        ///   - pendingSmartmoduleMacAddress: The pending smart module mac address.
        ///   - macAddress: The mac address.
        ///   - mainEcuSerial: The main ecu serial.
        ///   - smartmoduleCurrentVersion: The smart module current verison.
        ///   - smartmoduleDesiredVersion: The smart module desired version.
        ///   - changeBackupCode: Bool if backup code has changed.
        ///   - isTracking: Bool value if tracking is active.
        ///   - highestAvailableSpeedLimit: The highest available speed limit.
        ///   - messageAvailable: Bool value if a message is available.
        ///   - modelName: The model name.
        ///   - modelDetails: The model details.
        ///   - modelColor: The model color.
        ///   - frameShape: The frame shape.
        ///   - manufacturer: The manufacturer.
        ///   - controller: The controller.
        ///   - updateMethod: The update method.
        ///   - eLock: Bool value if eLock is available.
        ///   - gsmModule: The GSM module.
        ///   - speaker: Bool value if speaker is available.
        ///   - bleProfile: The bluetooth profile.
        ///   - bleVersion: The bluetooth version.
        ///   - messagesViaBLE: The messages via bluetooth.
        ///   - customerRoleFamily: The customer role family.
        ///   - customerRole: The customer role.
        ///   - permissions: The permissions.
        ///   - key: The Key.
        ///   - isFactoryKey: Bool value if is factory key.
        ///   - customerCount: The count of customers.
        ///   - invitationCount: The count of invitations.
        ///   - hasPeaceOfMind: Bool value if peace of mind is available.
        ///   - links: The links.
        public init(
            id: Int,
            name: String,
            frameNumber: String,
            bikeId: String,
            frameSerial: String?,
            ownerName: String,
            tripDistance: Int,
            pendingSmartmoduleMacAddress: String?,
            macAddress: String,
            mainEcuSerial: String?,
            smartmoduleCurrentVersion: String,
            smartmoduleDesiredVersion: String?,
            changeBackupCode: Bool,
            isTracking: Bool,
            highestAvailableSpeedLimit: Int?,
            messageAvailable: Bool,
            modelName: String,
            modelDetails: ModelDetails,
            modelColor: ModelColor,
            frameShape: String,
            manufacturer: String,
            controller: String?,
            updateMethod: String,
            eLock: Bool,
            gsmModule: String,
            speaker: Bool,
            bleProfile: String,
            bleVersion: String?,
            messagesViaBLE: String,
            customerRoleFamily: String,
            customerRole: String,
            permissions: [Permission],
            key: Key,
            isFactoryKey: Bool,
            customerCount: Int,
            invitationCount: Int,
            hasPeaceOfMind: Bool,
            links: Links?
        ) {
            self.id = id
            self.name = name
            self.frameNumber = frameNumber
            self.bikeId = bikeId
            self.frameSerial = frameSerial
            self.ownerName = ownerName
            self.tripDistance = tripDistance
            self.pendingSmartmoduleMacAddress = pendingSmartmoduleMacAddress
            self.macAddress = macAddress
            self.mainEcuSerial = mainEcuSerial
            self.smartmoduleCurrentVersion = smartmoduleCurrentVersion
            self.smartmoduleDesiredVersion = smartmoduleDesiredVersion
            self.changeBackupCode = changeBackupCode
            self.isTracking = isTracking
            self.highestAvailableSpeedLimit = highestAvailableSpeedLimit
            self.messageAvailable = messageAvailable
            self.modelName = modelName
            self.modelDetails = modelDetails
            self.modelColor = modelColor
            self.frameShape = frameShape
            self.manufacturer = manufacturer
            self.controller = controller
            self.updateMethod = updateMethod
            self.eLock = eLock
            self.gsmModule = gsmModule
            self.speaker = speaker
            self.bleProfile = bleProfile
            self.bleVersion = bleVersion
            self.messagesViaBLE = messagesViaBLE
            self.customerRoleFamily = customerRoleFamily
            self.customerRole = customerRole
            self.permissions = permissions
            self.key = key
            self.isFactoryKey = isFactoryKey
            self.customerCount = customerCount
            self.invitationCount = invitationCount
            self.hasPeaceOfMind = hasPeaceOfMind
            self.links = links
        }
        
    }
    
}
