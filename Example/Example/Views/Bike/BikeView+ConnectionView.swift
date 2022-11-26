import SwiftUI
import VanMoofKit

// MARK: - BikeView+ConnectionView

extension BikeView {
    
    /// The ConnectionView
    struct ConnectionView {
        
        /// The VanMoof Bike
        @EnvironmentObject
        private var bike: VanMoof.Bike
        
        /// Bool value if the initial connect has been performed
        @State
        private var hasPerformedInitialConnect = false
        
        /// The connection error
        @State
        private var connectionError: Swift.Error?
        
        /// The ColorScheme
        @Environment(\.colorScheme)
        private var colorScheme
        
    }
    
}

private extension BikeView.ConnectionView {
    
    func connect(to bike: VanMoof.Bike) async {
        self.connectionError = nil
        do {
            try await bike.connect()
        } catch {
            self.connectionError = error
        }
    }
    
}

// MARK: - View

extension BikeView.ConnectionView: View {
    
    /// The content and behavior of the view.
    var body: some View {
        Menu {
            switch self.bike.connectionState {
            case .connected:
                Button(role: .destructive) {
                    Task {
                        try await self.bike.disconnect()
                    }
                } label: {
                    Text(verbatim: "Disconnect")
                }
            case .disconnected, .disconnecting:
                Button {
                    Task {
                        await self.connect(to: self.bike)
                    }
                } label: {
                    Text(verbatim: "Connect")
                }
            default:
                EmptyView()
            }
        } label: {
            self.content
        }
        .task {
            guard !self.hasPerformedInitialConnect else {
                return
            }
            self.hasPerformedInitialConnect = true
            await self.connect(to: self.bike)
        }
        .onChange(of: self.bike) { bike in
            Task {
                await self.connect(to: bike)
            }
        }
        .onChange(of: self.bike.connectionState) { connectionState in
            self.connectionError = nil
        }
    }
    
}

private extension BikeView.ConnectionView {
    
    var content: some View {
        ZStack {
            HStack {
                Spacer()
                Image(self.bike.connectionState == .connected ? "BikeConnected" : "Bike")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 135)
                    .padding(.top, 30)
                    .offset(x: 20)
                    .opacity({
                        switch self.bike.connectionState {
                        case .disconnected:
                            return 0.5
                        case .discovering:
                            return 0.7
                        case .connecting:
                            return 0.8
                        case .connected:
                            return 1
                        case .disconnecting:
                            return 0.5
                        }
                    }())
            }
            HStack {
                VStack {
                    VStack(alignment: .leading) {
                        Text(
                            verbatim: "Frame Number"
                        )
                        .font(.subheadline.weight(.semibold))
                        Text(
                            verbatim: self.bike.frameNumber
                        )
                        .font(.caption.monospaced())
                        .foregroundColor(.secondary)
                    }
                    Spacer()
                    VStack {
                        Circle()
                            .fill(self.connectionError != nil ? .red : self.bike.connectionState.color)
                            .frame(width: 45, height: 45)
                            .overlay {
                                if self.connectionError != nil {
                                    Image(
                                        systemName: "xmark"
                                    )
                                    .foregroundColor(.white)
                                } else {
                                    switch self.bike.connectionState {
                                    case .disconnected:
                                        Image(
                                            systemName: "antenna.radiowaves.left.and.right.slash"
                                        )
                                        .font(.title3.weight(.bold))
                                        .foregroundColor(.white)
                                    case .discovering, .connecting, .disconnecting:
                                        ProgressView()
                                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                    case .connected:
                                        Image("Bluetooth")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .foregroundColor(.white)
                                            .padding(10)
                                    }
                                }
                            }
                        Text(
                            verbatim: self.connectionError != nil
                                ? "Connection failed"
                                : self.bike.connectionState.rawValue.capitalized
                        )
                        .font(.caption)
                        .foregroundColor(
                            self.connectionError != nil ? .red : self.bike.connectionState.color
                        )
                    }
                    .padding(.top)
                    Spacer()
                }
                Spacer()
            }
            .padding()
        }
        .background(Color.foregroundColor)
        .cornerRadius(12)
    }
    
}

private extension VanMoof.Bike.ConnectionState {
    
    var color: Color {
        switch self {
        case .disconnected:
            return .secondary
        case .discovering, .connecting, .connected:
            return .blue
        case .disconnecting:
            return .red
        }
    }
    
}
