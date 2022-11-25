import SwiftUI
import VanMoofKit

// MARK: - BatteryLevelSnippetView

/// The BatteryLevelSnippetView
struct BatteryLevelSnippetView {
    
    /// The battery level
    let batteryLevel: VanMoof.Bike.BatteryLevel
    
}

// MARK: - View

extension BatteryLevelSnippetView: View {
    
    /// The content and behavior of the view.
    var body: some View {
        Gauge(value: Double(self.batteryLevel.level), in: 0...100) {
            Text(verbatim: self.batteryLevel.unitSymbol)
        } currentValueLabel: {
            Text(verbatim: self.batteryLevel.formatted())
        }
        .scaleEffect(1.4)
        .gaugeStyle(.accessoryCircularCapacity)
        .tint({
            switch self.batteryLevel.level {
            case ...20:
                return .red
            case ..<50:
                return .yellow
            default:
                return .green
            }
        }())
        .padding()
        .padding(.top)
    }
    
}
