struct Location: Codable, Identifiable {
    var id: String {
        "\(lat)\(long)"
    }
    
    let name: String?
    let lat: Double
    let long: Double
}
