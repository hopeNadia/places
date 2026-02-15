import Foundation
import Combine
import MapKit

@MainActor
class CoordinatesFormViewModel: ObservableObject, Identifiable {
    private let urlService: UrlServiceProtocol
    private let urlOpener: URLOpenerServiceProtocol
    
    @Published var latitudeInput: String = ""
    @Published var longitudeInput: String = ""

    private var latInputNumber: Double? {
        NumberFormatter.decimalWithLocale.number(from: latitudeInput)?.doubleValue
    }
    
    private var longInputNumber: Double? {
        NumberFormatter.decimalWithLocale.number(from: longitudeInput)?.doubleValue
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
        urlService: UrlServiceProtocol,
        urlOpener: URLOpenerServiceProtocol
    ) {
        self.urlService = urlService
        self.urlOpener = urlOpener
    }
    
    func onCustomCoorinatesSubmit() {
        guard let latInputNumber,
                let longInputNumber,
                let url = urlService.getWikiUrl(lat: latInputNumber, long: longInputNumber) else {
            return
        }
        
        urlOpener.open(url)
    }
}
