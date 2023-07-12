import Foundation
import VanMoofKit

// MARK: - VanMoofCLI

/// The VanMoof CLI
@main
struct VanMoofCLI {
    
    /// The VanMoof instance.
    let vanMoof = VanMoof(tokenStore: InMemoryVanMoofTokenStore())
    
    /// The command name
    let command: String
    
    /// The parameters
    let parameters: [String: String]
    
}

// MARK: - Main

extension VanMoofCLI {
    
    /// Main
    static func main() async throws {
        // Verify CLI can be initialized from arguments
        guard let cli = CommandLine.arguments().flatMap(VanMoofCLI.init) else {
            // Otherwise exit with failure
            fatalError("Please add a command for example: \"vanmoof export\"")
        }
        // Execute CLI
        try await cli()
    }
    
}

// MARK: - Call as Function

extension VanMoofCLI {
    
    /// Call VanMoofCLI as function to run the CLI
    func callAsFunction() async throws {
        switch self.command {
        case "export":
            // Export
            try await self.export()
        default:
            // Otherwise exit with failure
            fatalError("Unsupported command: \(command)")
        }
    }
    
}

// MARK: - Export

extension VanMoofCLI {
    
    /// Export VanMoof Data
    func export() async throws {
        guard let username = self.parameters["username"] else {
            fatalError("Please specify your username via \"--username knight.rider@vanmoof.com\"")
        }
        guard let password = self.parameters["password"] else {
            fatalError("Please specify your password via \"--password ********\"")
        }
        let outputDirectoryURL: URL = try {
            if let outputDirectoryURLString = self.parameters["outputDirectory"]?
                .replacingOccurrences(
                    of: "~",
                    with: {
                        #if os(macOS)
                        return FileManager.default.homeDirectoryForCurrentUser.path
                        #else
                        return ""
                        #endif
                    }()
                ) {
                return URL(fileURLWithPath: outputDirectoryURLString)
            } else {
                return try FileManager
                    .default
                    .url(
                        for: .desktopDirectory,
                        in: .userDomainMask,
                        appropriateFor: nil,
                        create: false
                    )
            }
        }()
        print("Starting export...")
        do {
            try await self.vanMoof.login(
                username: username,
                password: password
            )
            let userData = try await self.vanMoof.userData()
            try FileManager
                .default
                .createDirectory(
                    at: outputDirectoryURL,
                    withIntermediateDirectories: true
                )
            let jsonEncoder = JSONEncoder()
            jsonEncoder.outputFormatting = [
                .withoutEscapingSlashes,
                .sortedKeys,
                .prettyPrinted
            ]
            try jsonEncoder
                .encode(userData)
                .write(
                    to: outputDirectoryURL
                        .appendingPathComponent("VanMoof-Export.json")
                )
        } catch {
            print("The export failed. \(error)")
            throw error
        }
        print("Export successfully saved at \(outputDirectoryURL)")
    }
    
}

// MARK: - CommandLine+arguments()

private extension CommandLine {
    
    /// Extracts command and parameters from the given arguments.
    /// - Returns: A tuple containing the command and parameters, or `nil` if no command is found.
    static func arguments() -> (command: String, parameters: [String: String])? {
        let arguments = self.arguments.dropFirst()
        guard let command = arguments.first else {
            return nil
        }
        return (
            command: command,
            parameters: {
                var parameters = [String: String]()
                var currentParameterName: String?
                for argument in arguments.dropFirst() {
                    if argument.hasPrefix("--") {
                        currentParameterName = argument
                            .replacingOccurrences(of: "--", with: "")
                            .trimmingCharacters(in: .whitespaces)
                        continue
                    }
                    if let parameterName = currentParameterName {
                        parameters[parameterName] = argument.trimmingCharacters(in: .whitespaces)
                    }
                    currentParameterName = nil
                }
                return parameters
            }()
        )
    }
    
}
