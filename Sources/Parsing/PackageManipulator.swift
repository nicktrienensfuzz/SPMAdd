import SwiftSyntax
import SwiftSyntaxParser
import Foundation


class PackageManipulator {
    private var sourceURL: URL
    init(packageURL: URL) {
        self.sourceURL = packageURL
    }

    func retrieve() throws -> SourceFileSyntax {
        
        let sourceFile = try SyntaxParser.parse(sourceURL)
        return sourceFile
    }
    func write(source: SourceFileSyntax) throws {
        print(source)
    //    try source.description.write(to: sourceURL, atomically: true, encoding: .utf8)
    }
      
    func addDependency(packageName: String, url: String, version: String) throws {
        let source = try retrieve()
        
        let productReader = PackageReader()
        _ = productReader.visit(source)
        print( productReader.products.map({ $0.description }).joined(separator: "\n"))
        print( productReader.packages.joined(separator: "\n"))
        
        let rewriter = DependencyRewriter(dependencyName: packageName, url: url, version: version)
        let updatedSource = rewriter.visit(source)
        
        
        try write( source: updatedSource)
    }

}

