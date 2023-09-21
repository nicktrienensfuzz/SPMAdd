import Foundation  

// MARK: - Input
/*
struct ProductDependency: CustomDebugConvertilbe {
    var name: String
    var package: String
}
*/
// MARK: - EndInput

struct ProductDependency: CustomDebugStringConvertible {
    var name: String
    var package: String

    init(
        name: String,
        package: String
    ){ 
        self.name = name
        self.package = package
    }

    func toSwift() -> String {
            """
            ProductDependency(
                name: "\(name)",
                package: "\(package)"
                )
            """
    }
    
    var debugDescription: String {
                 return "Product: (\(name), \(package))"
             }
 }
