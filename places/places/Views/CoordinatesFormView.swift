import SwiftUI

struct CoordinatesForm: View {
    @StateObject var viewModel: CoordinatesFormViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            HStack(spacing: .zero) {
                Spacer(minLength: 12)
                Button(role: .close, action: { dismiss() })
            }
            
            Form {
                Section(
                    header: Text("Search by coordinates")
                        .font(.title)
                        .foregroundStyle(.black)
                ) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Latitude")
                            .font(.caption)
                            .foregroundStyle(.primary)
                        
                        TextField(
                            "Example: 40,7128",
                            text: $viewModel.latitudeInput
                        )
                        .keyboardType(.numbersAndPunctuation)
                        .accessibilityLabel("Latitude")
                        .accessibilityHint("Enter a decimal number between minus 90 and 90")
                    }
                    
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Longitude")
                            .font(.caption)
                            .foregroundStyle(.primary)
                        
                        TextField(
                            "Example: -74,0060",
                            text: $viewModel.longitudeInput
                        )
                        .keyboardType(.numbersAndPunctuation)
                        .accessibilityLabel("Longitude")
                        .accessibilityHint("Enter a decimal number between minus 180 and 180")
                    }
                    
                    if viewModel.isInputErrorVisible {
                        Text("Invalid coordinates. Use decimal numbers, for example 40,7128")
                            .font(.caption)
                            .foregroundStyle(.red)
                            .accessibilityLabel("Error. Invalid coordinates.")
                            .accessibilityAddTraits(.isStaticText)
                    }
                    
                    Button {
                        viewModel.onCustomCoorinatesSubmit()
                    } label: {
                        Text("Search in Wikipedia")
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.blue)
                    .disabled(!viewModel.isValidCoordinates)
                    .accessibilityHint("Opens Wikipedia for the entered coordinates")
                }
            }
            .background(Color(.systemBackground))
        }
        .padding(16)
        .background(Color(.systemGroupedBackground))
    }
}
