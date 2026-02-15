struct Location: Decodable, Identifiable, Hashable {
    var id: Self { self }
    
    let name: String?
    let lat: Double
    let long: Double
}
