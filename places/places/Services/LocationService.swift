import Foundation

protocol LocationServiceProtocol {
    func getLocations() async throws -> [Location]
}

class LocationService: LocationServiceProtocol {
    private let decoder = JSONDecoder()
    private let locationsEndpoint = URL(string: "https://raw.githubusercontent.com/abnamrocoesd/assignment-ios/main/locations.json")!
    
    func getLocations() async throws -> [Location] {
        let (data, _) = try await URLSession.shared.data(from: locationsEndpoint)
        let response = try decoder.decode(Response.self, from: data)
        
        return response.locations
    }
}
