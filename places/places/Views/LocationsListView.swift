import SwiftUI

struct LocationsListView: View {
    @StateObject var viewModel: LocationsViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Enter coordinates and search it in Wiki!")
                .font(.headline)
            
            coordinatesFormButtonView
            
            Text("Select location and read more about it in Wiki!")
                .font(.headline)
            
            switch viewModel.viewState {
            case .loading:
                loadingView
            case .idle:
                listView
            case .error:
                errorView
            }
        }
        .padding(16)
        .navigationTitle("Places")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear(perform: viewModel.onAppear)
        .sheet(item: $viewModel.coordinatesFormViewModel) {
            CoordinatesForm(
                viewModel: $0
            )
        }
    }
    
    private var coordinatesFormButtonView: some View {
        Button(
            action: viewModel.onShowFormTap
        ) {
            Text("Search by Coordinates")
        }
        .buttonStyle(.borderedProminent)
        .accessibilityLabel("Open search by coordinates form.")
    }
    
    private var listView: some View {
        VStack(spacing: .zero) {
            ScrollView {
                if let locations = viewModel.locations, !locations.isEmpty {
                    LazyVStack(spacing: 12) {
                        ForEach(locations) { location in
                            LocationItemView(
                                location: location,
                                onLocationTap: viewModel.onLocationTap
                            )
                        }
                    }
                } else {
                    emptyListView
                }
            }
            .refreshable(action: viewModel.onRefresh)
        }
    }
    
    private var emptyListView: some View {
        VStack(spacing: 12) {
            Image(systemName: "mappin.and.ellipse")
                .font(.system(size: 48))
                .foregroundColor(.gray)
                .accessibilityHidden(true)
            Text("No locations")
                .font(.headline)
            Text("Please try later!")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    }

    private var errorView: some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 48))
                .foregroundColor(.red)
                .accessibilityHidden(true)
            
            Text("Something went wrong!")
                .font(.headline)
            
            Text("Failed to load locations. Please try again.")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            Button(action: viewModel.onRefresh) {
                Text("Retry")
                    .frame(maxWidth: .infinity)
                    .padding(12)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .accessibilityLabel("Retry loading locations")
        }
        .padding(32)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    }
    
    private var loadingView: some View {
        VStack(spacing: 16) {
            ProgressView()
                .scaleEffect(1.5, anchor: .center)
                .accessibilityHidden(true)
            
            Text("Loading places...")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 12)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .accessibilityLabel("Loading locations")
        .accessibilityHint("Please wait while we fetch your places")
    }
}
