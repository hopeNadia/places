import Foundation
import UIKit

protocol URLOpenerServiceProtocol {
    func open(_ url: URL)
}

class URLOpenerService: URLOpenerServiceProtocol {
    func open(_ url: URL) {
        UIApplication.shared.open(url)
    }
}
