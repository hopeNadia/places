import SwiftUI

extension View {
    func errorAlert(
        error: Binding<Error?>,
        buttonTitle: String = "Close"
    ) -> some View {
        return alert(
            "Something went wrong",
            isPresented: .constant(error.wrappedValue != nil),
            actions:  {
                Button(buttonTitle) {
                    error.wrappedValue = nil
                }
            }
        )
    }
}
