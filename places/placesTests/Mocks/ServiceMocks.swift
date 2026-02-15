import Foundation
@testable import places

extension Location {
    static var mock1: Self {
        .init(name: "Test location 1", lat: 12.23, long: 12.44)
    }
    static var mock2: Self {
        .init(name: "Test location 2", lat: 0, long: 13.45555)
    }
}

class LocationServiceMock: LocationServiceProtocol {
    var isError: Bool = false
    var locationsToReturn: [Location] = []
    
    func getLocations() async throws -> [places.Location] {
        guard !isError else {
            throw URLError(.badServerResponse)
        }
        
        return locationsToReturn
    }
}

class URLOpenerServiceMock: URLOpenerServiceProtocol {
    var isError: Bool = false
    var openedUrl: URL? = nil
    
    func open(_ url: URL) throws {
        guard !isError else {
            throw URLError(.badURL)
        }
        openedUrl = url
    }
}

class URLServiceMock: UrlServiceProtocol {
    var urlToReturn: URL? = URL(string: "https://example.com")
      var receivedLat: Double?
      var receivedLong: Double?

    func getWikiUrl(lat: Double, long: Double) -> URL? {
        receivedLat = lat
        receivedLong = long
        return urlToReturn
    }
}
