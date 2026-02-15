import Foundation

final class DependencyContainer {
    private init() {}
    private let lock = NSLock()
    
    static let shared = DependencyContainer()
    
    private var dependencies: [String: () -> Any] = [:]
    
    func register<T>(type: T.Type, _ dependency:  @escaping () -> T) {
        lock.lock()
        dependencies[String(describing: type)] = dependency
        lock.unlock()
    }
    
    func resolve<T>(_ type: T.Type) -> T {
        lock.lock()
        defer { lock.unlock()}
        let key = String(describing: type)
        guard let dependency = dependencies[key]?() as? T else {
            fatalError("Dependency not registered: \(type)")
        }
        return dependency
    }
}
