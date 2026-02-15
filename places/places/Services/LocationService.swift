import Foundation

protocol LocationServiceProtocol {
    func getLocations() async throws -> [Location]
}

enum ServiceError: Error {
    case wrongEndpointURL
}

class LocationService: LocationServiceProtocol {
    private let decoder = JSONDecoder() // inject during init
    private let locationsEndpoint: URL? = URL(string: "https://raw.githubusercontent.com/abnamrocoesd/assignment-ios/main/locations.json")
    
    func getLocations() async throws -> [Location] {
        guard let locationsEndpoint else {
            throw ServiceError.wrongEndpointURL
        }
        let (data, _) = try await URLSession.shared.data(from: locationsEndpoint)
        let response = try decoder.decode(LocationsResponse.self, from: data)
        
        return response.locations
    }
}
