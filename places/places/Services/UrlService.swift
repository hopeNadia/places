import Foundation

protocol UrlServiceProtocol {
    func getWikiUrl(lat: Double, long: Double) -> URL?
}

class UrlService: UrlServiceProtocol {
    func getWikiUrl(lat: Double, long: Double) -> URL? {
        return URL(string:"wikipedia://location?latitude=\(lat)&longitude=\(long)")
    }
}
