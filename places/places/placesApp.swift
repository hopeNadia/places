import SwiftUI

@main
struct placesApp: App {
    init() {
        DependencyContainer.shared.register(type: LocationServiceProtocol.self) { LocationService()
        }
        
        DependencyContainer.shared.register(type: UrlServiceProtocol.self) {
            UrlService()
        }
    }
    
    var body: some Scene {
        WindowGroup {
            AppView()
        }
    }
}
