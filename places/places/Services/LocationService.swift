import Foundation

protocol LocationServiceProtocol {
    func getLocations() async throws -> [Location]
}

enum ServiceError: Error {
    case wrongEndpointURL
}

class LocationService: LocationServiceProtocol {
    private let decoder: JSONDecoder
    private let urlSession: URLSession
    private let locationsEndpoint: URL? = URL(string: "https://raw.githubusercontent.com/abnamrocoesd/assignment-ios/main/locations.json")
    
    init(
        decoder: JSONDecoder,
        urlSession: URLSession
    ) {
        self.decoder = decoder
        self.urlSession = urlSession
    }
    
    func getLocations() async throws -> [Location] {
        guard let locationsEndpoint else {
            throw ServiceError.wrongEndpointURL
        }
        let (data, _) = try await urlSession.data(from: locationsEndpoint)
        let response = try decoder.decode(LocationsResponse.self, from: data)
        
        return response.locations
    }
}
