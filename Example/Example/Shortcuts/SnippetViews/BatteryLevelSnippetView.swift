import SwiftUI

// MARK: - BatteryLevelSnippetView

/// The BatteryLevelSnippetView
struct BatteryLevelSnippetView {
    
    /// The battery level
    let batteryLevel: Int
    
}

// MARK: - View

extension BatteryLevelSnippetView: View {
    
    /// The content and behavior of the view.
    var body: some View {
        Gauge(value: Double(self.batteryLevel), in: 0...100) {
            Text(verbatim: "%")
        } currentValueLabel: {
            Text(verbatim: "\(self.batteryLevel) %")
        }
        .scaleEffect(1.4)
        .gaugeStyle(.accessoryCircularCapacity)
        .tint({
            switch self.batteryLevel {
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
