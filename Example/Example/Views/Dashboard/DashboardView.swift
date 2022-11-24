import SwiftUI
import VanMoofKit

// MARK: - DashboardView

/// The DashboardView
struct DashboardView {
    
    /// The App ViewModel
    @EnvironmentObject
    private var viewModel: App.ViewModel
    
}

// MARK: - View

extension DashboardView: View {
    
    /// The content and behavior of the view.
    var body: some View {
        switch self.viewModel.user {
        case .success(let user):
            NavigationStack {
                Group {
                    if let selectedBike = user.bikes.first(where: { $0.id == self.viewModel.selectedBikeId }) {
                        BikeView(
                            bike: selectedBike
                        )
                    } else {
                        Text(
                            verbatim: "No Bike available"
                        )
                        .navigationTitle("VanMoofKit")
                    }
                }
                .toolbar {
                    if user.bikes.count > 1 {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Menu {
                                ForEach(user.bikes) { bike in
                                    Button {
                                        self.viewModel.selectedBikeId = bike.id
                                    } label: {
                                        Label(
                                            bike.name,
                                            systemImage: bike.id == self.viewModel.selectedBikeId ? "checkmark" : "bicycle"
                                        )
                                    }
                                }
                            } label: {
                                Image(
                                    systemName: "bicycle.circle.fill"
                                )
                                .font(.title3)
                            }
                        }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        NavigationLink(destination: SettingsView(user: user)) {
                            Image(
                                systemName: "gear.circle.fill"
                            )
                            .font(.title3)
                        }
                    }
                }
            }
        case .failure(let error):
            Text(verbatim: "\(error)")
        case nil:
            ProgressView()
        }
    }
    
}
