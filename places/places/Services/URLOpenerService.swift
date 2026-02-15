import UIKit

enum URLOpenerError: Error {
    case cantOpenURL
}

protocol URLOpenerServiceProtocol {
    func open(_ url: URL) throws
}

class URLOpenerService: URLOpenerServiceProtocol {
    func open(_ url: URL) throws {
        guard UIApplication.shared.canOpenURL(url) else {
            throw URLOpenerError.cantOpenURL
        }
        UIApplication.shared.open(url)
    }
}
