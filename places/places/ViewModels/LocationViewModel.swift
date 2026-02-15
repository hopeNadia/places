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
    private let urlOpener: URLOpenerServiceProtocol
    
    @Published var alertError: Error?
    @Published var coordinatesFormViewModel: CoordinatesFormViewModel?
    @Published var locations: [Location]?
    @Published var viewState: ViewState = .idle

    init(
        locationService: LocationServiceProtocol,
        urlService: UrlServiceProtocol,
        urlOpener: URLOpenerServiceProtocol
    ) {
        self.locationService = locationService
        self.urlService = urlService
        self.urlOpener = urlOpener
    }
    
    func onAppear() {
        getLocations()
    }
    
    func onRefresh() {
        getLocations()
    }
    
    func onShowFormTap() {
        coordinatesFormViewModel = .init(
            urlService: DependencyContainer.shared.resolve(UrlServiceProtocol.self),
            urlOpener: DependencyContainer.shared.resolve(URLOpenerServiceProtocol.self)
        )
    }
    
    func onLocationTap(location: Location) {
        guard let url = urlService.getWikiUrl(lat: location.lat, long: location.long) else {
            return
        }
        
        do {
            try urlOpener.open(url)
        } catch {
            alertError = error
        }
    }
    
    private func getLocations() {
        Task {
            viewState = .loading
            do {
                locations = try await locationService.getLocations()
                viewState = .idle
            } catch {
                viewState = .error
            }
        }
    }
}
