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
            value: self.speedLimit.measurement.value,
            in: 0...37
        ) {
            Text(verbatim: self.speedLimit.measurement.unit.symbol)
        } currentValueLabel: {
            Text(verbatim: .init(Int(speedLimit.measurement.value)))
        }
        .scaleEffect(1.4)
        .gaugeStyle(.accessoryCircular)
        .tint(.teal)
        .padding()
        .padding(.top)
    }
    
}
