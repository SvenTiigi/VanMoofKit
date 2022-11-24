import SwiftUI
import VanMoofKit

// MARK: - SpeedLimitSnippetView

/// The SpeedLimitSnippetView
struct SpeedLimitSnippetView {
    
    /// The SpeedLimit
    let speedLimit: VanMoof.Bike.SpeedLimit
    
}

// MARK: - View

extension SpeedLimitSnippetView: View {
    
    /// The content and behavior of the view.
    var body: some View {
        Gauge(
            value: Double(self.speedLimit.maximumKilometersPerHour),
            in: 0...37
        ) {
            Text(verbatim: "km/h")
        } currentValueLabel: {
            Text(verbatim: .init(self.speedLimit.maximumKilometersPerHour))
        }
        .scaleEffect(1.4)
        .gaugeStyle(.accessoryCircular)
        .tint(.teal)
        .padding()
        .padding(.top)
    }
    
}
