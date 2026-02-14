import SwiftUI

struct AppView: View {
    var body: some View {
        VStack {
            LocationListView(
                viewModel: LocationsViewModel(
                    locationService: LocationService(),
                    urlService: UrlService()
                )
            )
        }
        .padding()
    }
}

#Preview {
    AppView()
}
