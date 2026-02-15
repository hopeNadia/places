import SwiftUI

struct AppView: View {
    var body: some View {
        NavigationStack {
            LocationsListView(
                viewModel: LocationsViewModel(
                    locationService: DependencyContainer.shared.resolve(LocationServiceProtocol.self),
                    urlService: DependencyContainer.shared.resolve(UrlServiceProtocol.self),
                    urlOpener: DependencyContainer.shared.resolve(URLOpenerServiceProtocol.self)
                )
            )
        }
    }
}

#Preview {
    AppView()
}
