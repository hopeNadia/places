import SwiftUI

struct AppView: View {
    var body: some View {
        VStack {
            LocationListView(
                viewModel: LocationsViewModel(
                    locationService: DependencyContainer.shared.resolve(LocationServiceProtocol.self),
                    urlService: DependencyContainer.shared.resolve(UrlServiceProtocol.self),
                )
            )
        }
        .padding()
    }
}

#Preview {
    AppView()
}
