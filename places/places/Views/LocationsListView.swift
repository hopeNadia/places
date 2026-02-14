import SwiftUI
struct LocationListView: View {
    @StateObject var viewModel: LocationsViewModel
    @State private var showCustomLocation = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                Text("Places")
                    .font(.headline)
                Text("Enter coordinates and search it in Wiki!")
                    .font(.headline)
                
                customSearchButtonView
                if showCustomLocation {
                    customLocationView
                        .transition(.opacity.combined(with: .move(edge: .trailing)))
                }
                
                // Location selector here
                
                Text("Or \nSelect location and read more about it in Wiki!")
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
        }
        .refreshable {
            viewModel.onRefresh()
        }
        .onAppear(perform: viewModel.onAppear)
        .onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
    
    private var customSearchButtonView: some View {
        Button(action: {
            withAnimation(.easeInOut(duration: 0.2)) {
                showCustomLocation.toggle()
            }}) {
            HStack {
                Image(systemName: showCustomLocation ? "chevron.up" : "chevron.down")
                    .rotationEffect(.degrees(showCustomLocation ? 0 : -90))
                Text("Search by Coordinates")
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(12)
            .background(Color(.systemGray6))
            .foregroundColor(.primary)
            .cornerRadius(8)
        }
    }
    
    private var customLocationView: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Search by coordinates")
                .font(.subheadline)
                .fontWeight(.semibold)
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Latitude")
                    .font(.caption)
                    .foregroundColor(.secondary)
                TextField("Lat", text: $viewModel.latitudeInput)
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.numbersAndPunctuation)
                    .accessibilityLabel("Latitude input field")
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Longitude")
                    .font(.caption)
                    .foregroundColor(.secondary)
                TextField("Long", text: $viewModel.longitudeInput)
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.numbersAndPunctuation)
                    .accessibilityLabel("Longitude input field")
            }
            
            Button(action: viewModel.onCustomCoorinatesSubmit) {
                Text("Search in Wikipedia")
            }
            .frame(maxWidth: .infinity)
            .buttonStyle(.borderedProminent)
            .disabled(!viewModel.isValidCoordinates)
            .accessibilityLabel("Open Wikipedia for coordinates")
            
            if viewModel.isInputErrorVisible {
                Text("Invalid coordinates. Enter each coordinate as a number with decimal point (e.g., 40,7128)")
                    .font(.caption)
                    .foregroundColor(.red)
                    .accessibilityLabel("Error: Enter coordinates as numbers with decimal points")
            }
        }
        .padding(16)
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
    
    private var listView: some View {
            Group {
                if let locations = viewModel.locations, !locations.isEmpty {
                    LazyVStack(spacing: 12) {
                        ForEach(locations) { location in
                            locationCard(location: location)
                        }
                    }
                    .padding(16)
                } else {
                    emptyListView
                }
            }
           
    }
    
    private var emptyListView: some View {
        VStack(spacing: 12) {
            Image(systemName: "mappin.and.ellipse")
                .font(.system(size: 48))
                .foregroundColor(.gray)
                .accessibilityHidden(true)
            Text("No locations for today")
                .font(.headline)
            Text("Please try later!")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    }
    
    @ViewBuilder
    private func locationCard(location:Location) -> some View {
        Button(action: {
            viewModel.onLocationTap(location: location)
        }) {
            VStack(alignment: .leading, spacing: 8) {
                Text(location.name ?? "Surprise location")
                    .font(.headline)
                    .foregroundColor(.primary)
                
                HStack(spacing: 4) {
                    Image(systemName: "location.fill")
                        .foregroundColor(.blue)
                        .font(.caption)
                        .accessibilityHidden(true)
                    
                    Text("Lat: \(String(format: "%.2f", location.lat)), Long: \(String(format: "%.2f", location.long))")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(16)
            .background(Color(.systemGray6))
            .cornerRadius(12)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Location: \(location.name ?? "Surprise location")")
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
