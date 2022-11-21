import SwiftUI
import VanMoofKit

// MARK: - BikeView

/// The BikeView
struct BikeView {
    
    /// The VanMoof Bike
    @ObservedObject
    var bike: VanMoof.Bike
    
}

// MARK: - View

extension BikeView: View {
    
    /// The content and behavior of the view.
    var body: some View {
        List {
            HStack {
                Text(verbatim: "Status")
                Spacer()
                Text(
                    verbatim: {
                        switch self.bike.connectionState {
                        case .disconnected:
                            return "Disconnected"
                        case .discovering:
                            return "Discovering"
                        case .connecting:
                            return "Connecting"
                        case .connected:
                            return "Connected"
                        case .disconnecting:
                            return "Disconnecting"
                        }
                    }()
                )
                .foregroundColor(.secondary)
            }
            if self.bike.isDisconnected {
                Button {
                    Task {
                        do {
                            print("Start Connecting")
                            try await self.bike.connect()
                            print("Connected")
                        } catch {
                            print("Connecting failed", error)
                        }
                    }
                } label: {
                    Text(verbatim: "Connect")
                }
            }
            if self.bike.isConnected {
                Button {
                    Task {
                        try await self.bike.play(sound: .scrollingTone)
                    }
                } label: {
                    Text(verbatim: "Play Sound")
                }
                Button {
                    Task {
                        try await self.bike.disconnect()
                    }
                } label: {
                    Text(verbatim: "Disconnect")
                }
                
            }
        }
        .navigationTitle(self.bike.name)
    }
    
}
