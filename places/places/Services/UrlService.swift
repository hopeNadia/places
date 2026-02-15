import Foundation

protocol UrlServiceProtocol {
    func getWikiUrl(lat: Double, long: Double) -> URL?
}

class UrlService: UrlServiceProtocol {
    func getWikiUrl(lat: Double, long: Double) -> URL? {
        let url = URL(string: "wikipedia://location")
        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "latitude", value: "\(lat)"),
            URLQueryItem(name: "longitude", value: "\(long)")
        ]
        return url?.appending(queryItems: queryItems)
    }
}
