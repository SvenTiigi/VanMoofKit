import SwiftUI

extension Color {
    
    static var foregroundColor: Color {
        .init(
            uiColor: .init { traitCollection in
                traitCollection.userInterfaceStyle == .dark
                    ? .secondarySystemGroupedBackground
                    : .systemGroupedBackground
            }
        )
    }
    
}
