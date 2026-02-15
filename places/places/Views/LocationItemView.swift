import SwiftUI

struct LocationItem: View {
    private let location: Location
    private let onLocationTap: (_ location: Location) -> Void
    
    public init(location: Location, onLocationTap: @escaping (_: Location) -> Void) {
        self.location = location
        self.onLocationTap = onLocationTap
    }
    
    var body: some View {
        Button(
            action: { onLocationTap(location) }
        ) {
            VStack(alignment: .leading, spacing: 8) {
                Text(location.name ?? "N/A")
                    .font(.headline)
                    .foregroundColor(.primary)
                    .accessibilityLabel("Location: \(location.name ?? "Unknown").")
                
                HStack(spacing: 4) {
                    Image(systemName: "location.fill")
                        .foregroundColor(.blue)
                        .font(.caption)
                        .accessibilityHidden(true)
                    Text("Lat: \(location.lat.formatted(.number)), Long: \(location.long.formatted(.number))")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .accessibilityLabel("Coordinates: Lat: \(location.lat.formatted(.number)), Long: \(location.long.formatted(.number))")
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(16)
            .background(Color(.systemGray6))
            .cornerRadius(12)
        }
        .accessibilityElement(children: .combine)
        .accessibilityHint("Tap to view location in Wikipedia")
    }
}
