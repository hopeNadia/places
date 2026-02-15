import SwiftUI

@main
struct PlacesApp: App {
    init() {
        DependencyContainer.shared.register(type: LocationServiceProtocol.self) {
            LocationService(
                decoder: .default,
                urlSession: URLSession.shared
            )
        }
        DependencyContainer.shared.register(type: UrlServiceProtocol.self) {
            UrlService()
        }
        
        DependencyContainer.shared.register(type: URLOpenerServiceProtocol.self) {
            URLOpenerService()
        }
    }
    
    var body: some Scene {
        WindowGroup {
            AppView()
        }
    }
}
