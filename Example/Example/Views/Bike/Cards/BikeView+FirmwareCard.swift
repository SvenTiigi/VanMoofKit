import SwiftUI
import VanMoofKit

// MARK: - FirmwareCard

extension BikeView {
    
    /// The FirmwareCard
    struct FirmwareCard {
        
        /// The VanMoof Bike
        @EnvironmentObject
        private var bike: VanMoof.Bike
        
    }
    
}

// MARK: - View

extension BikeView.FirmwareCard: View {
    
    /// The content and behavior of the view.
    var body: some View {
        BikeView.Card(
            fixedHeight: nil,
            placeholderValue: .init(),
            title: "Firmware Versions",
            systemImage: "cpu",
            provider: {
                await self.bike.firmwareSummary
            },
            content: { firmwareSummary in
                VStack(spacing: 12) {
                    self.entry(
                        title: "Bike Firmware",
                        detail: firmwareSummary.bikeFirmwareVersion
                    )
                    self.entry(
                        title: "BLE Chip",
                        detail: firmwareSummary.bleChipFirmwareVersion
                    )
                    self.entry(
                        title: "E-Shifter",
                        detail: firmwareSummary.eShifterFirmwareVersion
                    )
                }
            },
            actions: { _ in
                EmptyView()
            }
        )
    }
    
}

// MARK: - Entry

private extension BikeView.FirmwareCard {
    
    /// Retrieve a FirmwareCard Entry SwiftUI View
    /// - Parameters:
    ///   - title: The title text
    ///   - detail: The optional detail text
    func entry(
        title: String,
        detail: String?
    ) -> some View {
        HStack {
            Text(
                verbatim: title
            )
            .font(.headline)
            Spacer()
            Text(
                verbatim: detail ?? "N.A."
            )
            .font(.subheadline)
            .fontWeight(.semibold)
            .monospaced()
        }
        .foregroundColor(.secondary)
    }
    
}

// MARK: - VanMoof+Bike+FirmwareSummary

private extension VanMoof.Bike {
    
    /// A Firmware Summary
    struct FirmwareSummary: Hashable {
        
        /// The bike firmware version
        var bikeFirmwareVersion: String?
        
        /// The ble chip firmware version
        var bleChipFirmwareVersion: String?
        
        /// The E-Shifter firmware version
        var eShifterFirmwareVersion: String?
        
    }
    
    /// The FirmwareSummary
    var firmwareSummary: FirmwareSummary {
        get async {
            async let bikeFirmwareVersion = self.bikeFirmwareVersion
            async let bleChipFirmwareVersion = self.bleChipFirmwareVersion
            async let eShifterFirmwareVersion = self.eShifterFirmwareVersion
            return .init(
                bikeFirmwareVersion: try? await bikeFirmwareVersion,
                bleChipFirmwareVersion: try? await bleChipFirmwareVersion,
                eShifterFirmwareVersion: try? await eShifterFirmwareVersion
            )
        }
    }
    
}
