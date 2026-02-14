import Foundation
import SwiftUI
import Combine
import MapKit

enum ViewState {
    case loading, idle, error
}

@MainActor
class LocationsViewModel: ObservableObject {
    private let locationService: LocationServiceProtocol
    private let urlService: UrlServiceProtocol
    
    @Published var locations: [Location]?
    @Published var viewState: ViewState = .idle
    
    @Published var latitudeInput: String = ""
    @Published var longitudeInput: String = ""

    private var latInputNumber: Double? {
        NumberFormatter.decimalWithLocale.number(from: latitudeInput) as? Double
    }
    
    private var longInputNumber: Double? {
        NumberFormatter.decimalWithLocale.number(from: longitudeInput) as? Double
    }
    
    var isValidCoordinates: Bool {
        guard let latInputNumber, let longInputNumber  else {
            return false
        }

        return CLLocationCoordinate2DIsValid(CLLocationCoordinate2D(latitude: latInputNumber, longitude: longInputNumber))
    }
    
    var isInputErrorVisible: Bool {
        !isValidCoordinates && !latitudeInput.isEmpty && !longitudeInput.isEmpty
    }
    
    init(
        locationService: LocationServiceProtocol,
        urlService: UrlServiceProtocol
    ) {
        self.locationService = locationService
        self.urlService = urlService
    }
    
    func onAppear() {
        getLocations()
    }
    
    func onRefresh() {
        getLocations()
    }
    
    func onCustomCoorinatesSubmit() {
        guard let latInputNumber,
                let longInputNumber,
                let url = urlService.getWikiUrl(lat: latInputNumber, long: longInputNumber) else {
            return
        }
        
        UIApplication.shared.open(url)
    }
    
    func onLocationTap(location: Location) {
        guard let url = urlService.getWikiUrl(lat: location.lat, long: location.long) else {
            return
        }
        
        UIApplication.shared.open(url)
    }
    
    private func getLocations() {
        Task {
            viewState = .loading
            do {
                locations = try await locationService.getLocations()
                viewState = .idle
            } catch {
                print(error)
                viewState = .error
            }
        }
    }
}
