import Foundation

public protocol GarageConfigurationType {
    var endpoint: NSURL { get }
    var accessToken: String { get }
    var headers: [String: String] { get }
    var pathPrefix: String { get }
    var verbose: Bool { get }
}

public extension GarageConfigurationType {
    public var defaultUserAgent: String {
        let clientName = "GarageClientSwift"

        if let info = NSBundle.mainBundle().infoDictionary {
            let executable = info[kCFBundleExecutableKey as String] as? String ?? "Unknown"
            let version = info[kCFBundleVersionKey as String] as? String ?? "Unknown"

            return "\(clientName) \(executable) (\(version))"
        }

        return clientName
    }

    public var headers: [String: String] {
        return [
            "Accept": "application/json",
            "User-Agent": defaultUserAgent,
        ]
    }

    public var pathPrefix: String {
        return "v1"
    }

    public var verbose: Bool {
        return false
    }
}
