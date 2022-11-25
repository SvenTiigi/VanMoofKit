import SwiftUI
import VanMoofKit

// MARK: - BatteryLevelCard

extension BikeView {
    
    /// The BatteryLevelCard
    struct BatteryLevelCard {
        
        /// The VanMoof Bike
        @EnvironmentObject
        private var bike: VanMoof.Bike
        
        @State
        private var isCharging: Bool = false
        
    }
    
}

// MARK: - View

extension BikeView.BatteryLevelCard: View {
    
    /// The content and behavior of the view.
    var body: some View {
        BikeView.Card(
            placeholderValue: 50,
            provider: {
                try await self.bike.batteryLevel
            },
            publisher: self.bike.batteryLevelPublisher,
            content: { batteryLevel in
                Gauge(value: Double(batteryLevel.level), in: 0...100) {
                    Text(verbatim: batteryLevel.unitSymbol)
                } currentValueLabel: {
                    Text(verbatim: batteryLevel.formatted())
                }
                .scaleEffect(1.4)
                .gaugeStyle(.accessoryCircularCapacity)
                .tint({
                    switch batteryLevel.level {
                    case ...20:
                        return .red
                    case ..<50:
                        return .yellow
                    default:
                        return .green
                    }
                }())
            },
            label: { batteryLevel in
                Label(
                    "Battery",
                    systemImage: {
                        if self.isCharging {
                            return "battery.100.bolt"
                        }
                        switch batteryLevel.level {
                        case ...1:
                            return "battery.0"
                        case ...25:
                            return "battery.25"
                        case ...50:
                            return "battery.50"
                        case ...75:
                            return "battery.75"
                        default:
                            return "battery.100"
                        }
                    }()
                )
            },
            actions: { _ in
                EmptyView()
            }
        )
    }
    
}
