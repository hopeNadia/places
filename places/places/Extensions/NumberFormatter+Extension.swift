import Foundation

extension NumberFormatter {
    static let decimalWithLocale: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = Locale.current
        
        return formatter
    }()
}
