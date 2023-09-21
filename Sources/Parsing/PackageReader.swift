import SwiftSyntax
import Foundation
import SwiftSyntaxParser
import SwiftSyntaxBuilder

extension TupleExprElementListSyntax {
    func valueForArgument(_ name: String) -> String? {
        for arg in self {
            if let argName = arg.label?.text, argName == name,
               let nameValue = arg.expression.as(StringLiteralExpr.self) {
                return nameValue.withoutTrivia().description.replacingOccurrences(of: "\"", with: "")
            }
        }
        return nil
    }
}
class PackageReader: SyntaxRewriter {
    
    var products: [ProductDependency] = []
    var packages: [PackageDependency] = []
    override init() {
    }
    
    
    
    override func visit(_ node: FunctionCallExprSyntax) -> ExprSyntax {
        // Only rewrite function calls that are on "dependencies"
        print( node.calledExpression.withoutTrivia().description)
        if node.calledExpression.withoutTrivia().description == ".product" {
            print(node.argumentList)
            if let nameValue = node.argumentList.valueForArgument("name"),
               let packageValue = node.argumentList.valueForArgument("package") {
                
                ///print(packageValue.withoutTrivia().description.replacingOccurrences(of: "\"", with: ""))
                self.products.append(.init(name: nameValue,
                                           package: packageValue))
            }
            
        }
        if node.calledExpression.withoutTrivia().description == ".package" {
            print(node.argumentList)
            if let urlValue = node.argumentList.valueForArgument("url") {
                let packageValue = node.argumentList.valueForArgument("from")
                self.packages.append(.init(
                    name: (URL(string: urlValue)?.lastPathComponent.description ?? "unknown").replacingOccurrences(of: ".git", with: ""),
                    url: urlValue,
                    version: packageValue ?? "unknown",
                    versionStyle: "from"))
            }
        }
        return super.visit(node)
    }
}
