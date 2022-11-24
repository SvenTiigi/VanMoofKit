import SwiftUI

// MARK: - PowerLevelSnippetView

/// The PowerLevelSnippetView
struct PowerLevelSnippetView {
 
    /// The PowerLevel
    let powerLevel: PowerLevelAppEnum
    
}

// MARK: - View

extension PowerLevelSnippetView: View {
    
    /// The content and behavior of the view.
    var body: some View {
        Group {
            if (1...4).contains(self.powerLevel.rawValue) {
                Text(
                    verbatim: .init(self.powerLevel.rawValue)
                )
                .font(.system(size: 180).weight(.bold).italic())
            } else {
                Text(
                    self.powerLevel.localizedStringResource
                )
                .font(.system(size: 60).weight(.bold).italic())
            }
        }
    }
    
}
