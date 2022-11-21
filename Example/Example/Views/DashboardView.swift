import SwiftUI
import VanMoofKit

// MARK: - DashboardView

/// The DashboardView
struct DashboardView {
    
    @State
    private var user: Result<VanMoof.User, Error>?
    
    /// The VanMoof object
    @EnvironmentObject
    private var vanMoof: VanMoof
    
}

// MARK: - View

extension DashboardView: View {
    
    /// The content and behavior of the view.
    var body: some View {
        Group {
            switch self.user {
            case .success(let user):
                NavigationStack {
                    List {
                        ForEach(user.bikes) { bike in
                            NavigationLink(value: bike) {
                                HStack(spacing: 10) {
                                    Image(
                                        systemName: "bicycle.circle.fill"
                                    )
                                    VStack(alignment: .leading) {
                                        Text(
                                            verbatim: bike.name
                                        )
                                        .font(.headline)
                                        Text(
                                            verbatim: bike.modelName
                                        )
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                    }
                                }
                            }
                        }
                    }
                    .navigationDestination(
                        for: VanMoof.Bike.self,
                        destination: BikeView.init
                    )
                    .navigationTitle("VanMoofKit")
                }
            case .failure(let error):
                Text(verbatim: "\(error)")
            case nil:
                ProgressView()
            }
        }
        .task {
            do {
                self.user = .success(
                    try await self.vanMoof.user()
                )
            } catch {
                self.user = .failure(error)
            }
        }
    }
    
}
