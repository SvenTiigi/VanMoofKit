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
            exit(
                code: EXIT_FAILURE,
                message: "Please specify a command for example: \"vanmoof export\""
            )
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
            // Exit with failure
            exit(
                code: EXIT_FAILURE,
                message: "Unsupported command: \(self.command)"
            )
        }
    }
    
}

// MARK: - Export

extension VanMoofCLI {
    
    /// Export VanMoof Data
    func export() async throws {
        // Verify username is available
        guard let username = self.parameters["username"] else {
            // Otherwise exit with failure
            exit(
                code: EXIT_FAILURE,
                message: "Please specify a username via \"--username knight.rider@vanmoof.com\""
            )
        }
        // Verify password is available
        guard let password = self.parameters["password"] else {
            // Otherwise exit with failure
            exit(
                code: EXIT_FAILURE,
                message: "Please specify a password via \"--password ********\""
            )
        }
        // Initialize outpur directory url either by using the specified output directory
        // or when the parameter is unavailable the desktop directory
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
        // Initialize the file url
        let fileURL = outputDirectoryURL.appendingPathComponent("VanMoof-Export.json")
        print("Starting export...")
        do {
            // Create the output directory url
            try FileManager
                .default
                .createDirectory(
                    at: outputDirectoryURL,
                    withIntermediateDirectories: true
                )
            // Try to login
            try await self.vanMoof.login(
                username: username,
                password: password
            )
            // Try to retrieve the user data
            let userData = try await self.vanMoof.userData()
            // Serialize json and write data to file
            try JSONSerialization
                .data(
                    withJSONObject: JSONSerialization
                        .jsonObject(with: userData),
                    options: [
                        .prettyPrinted,
                        .sortedKeys,
                        .withoutEscapingSlashes
                    ]
                )
                .write(
                    to: fileURL
                )
        } catch {
            // Exit with failure
            exit(
                code: EXIT_FAILURE,
                message: "The export failed: \(error)"
            )
        }
        // Exit with success
        exit(
            message: "Export successfully saved at \(fileURL.path)"
        )
    }
    
}

// MARK: - CommandLine+arguments()

private extension CommandLine {
    
    /// Extracts command and parameters from the given arguments.
    /// - Returns: A tuple containing the command and parameters, or `nil` if no command is found.
    static func arguments() -> (command: String, parameters: [String: String])? {
        // Drop first argument which is the path of the executable
        let arguments = self.arguments.dropFirst()
        // Verify a command is available
        guard let command = arguments.first else {
            // Otherwise return nil
            return nil
        }
        // Return arguments including command and parameters
        return (
            command: command,
            parameters: {
                var parameters = [String: String]()
                let parameterPrefix = "--"
                var currentParameterName: String?
                for argument in arguments.dropFirst() {
                    if argument.hasPrefix(parameterPrefix) {
                        currentParameterName = argument
                            .replacingOccurrences(of: parameterPrefix, with: String())
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

// MARK: - Exit

/// Exit program.
/// - Parameters:
///   - code: The termination code.
///   - message: The optional message. Default value `nil`
func exit(
    code: Int32 = EXIT_SUCCESS,
    message: String? = nil
) -> Never {
    message.flatMap { print($0) }
    exit(code)
}
