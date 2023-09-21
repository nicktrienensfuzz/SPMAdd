// The Swift Programming Language
// https://docs.swift.org/swift-book
// 
// Swift Argument Parser
// https://swiftpackageindex.com/apple/swift-argument-parser/documentation

import ArgumentParser
import Foundation
import PathKit
import SwiftSyntax

@main
struct SPMAdd: AsyncParsableCommand {
    @Argument(help: "A Package url to add")
    var repoURL: String
    
    @Argument(
        help: "A Package.swift file to edit",
        completion: .file(),
        transform: URL.init(fileURLWithPath:))
    var inputFile: URL? = nil


    mutating func run() async throws {
        let cwd = Path.current
        if let inputFile {
            let runner = PackageManipulator(packageURL: inputFile)
            try runner.addDependency(packageName: "test", url: "https://github.com/kylef/PathKit.git", version: "1.0.1")
            return
        }
        let localPackage = cwd + "Package.swift"
        if localPackage.exists {
            print(localPackage)
            let runner = PackageManipulator(packageURL: localPackage.url)
            try runner.addDependency(packageName: "test", url: "https://github.com/kylef/PathKit.git", version: "1.0.1")
            
            return
        } else {
            print("no package found.")
            
        }
    }
}
