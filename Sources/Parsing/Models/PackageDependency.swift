import Foundation  

// MARK: - Input
/*
struct PackageDependency: CustomDebugConvertilbe {
    var name: String
    var url: String
    var version: String
    var versionStyle: String
}
*/
// MARK: - EndInput

struct PackageDependency: CustomDebugStringConvertible, CustomStringConvertible {
    var name: String
    var url: String
    var version: String
    var versionStyle: String

    init(
        name: String,
        url: String,
        version: String,
        versionStyle: String
    ){ 
        self.name = name
        self.url = url
        self.version = version
        self.versionStyle = versionStyle
    }

    func toSwift() -> String {
            """
            PackageDependency(
                name: "\(name)",
                url: "\(url)",
                version: "\(version)",
                versionStyle: "\(versionStyle)"
                )
            """
    }
    
    var description: String {
        return "Package: (\(url), \(name), \(version)"
    }
    var debugDescription: String {
                 return "Package: (\(url), \(name), \(version)"
             }
 }
