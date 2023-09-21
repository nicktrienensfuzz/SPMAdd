//
//  DependencyRewriter.swift
//  
//
//  Created by Nicholas Trienens on 9/20/23.
//

import Foundation
import SwiftSyntax
import SwiftSyntaxParser
import Foundation

final class DependencyRewriter: SyntaxRewriter {
    
    var dependencyName: String
    var productName: String
    var url: String
    var version: String
    
    init(dependencyName: String, url: String, version: String) {
        self.dependencyName = dependencyName
        self.productName = dependencyName
        self.url = url
        self.version = version
    }
    
    override func visit(_ node: TupleTypeElementSyntax) -> TupleTypeElementSyntax {
        
        print("TupleTypeElementSyntax: \(node)" )
        return super.visit(node)
    }
    override func visit(_ node: IdentifierPatternSyntax) -> PatternSyntax {
        print("IdentifierPatternSyntax: \(node)" )
        return super.visit(node)
    }
    override func visit(_ node: ExpressionPatternSyntax) -> PatternSyntax {
        print("ExpressionPatternSyntax: \(node)" )
        
        return super.visit(node)
    }
    override func visit(_ node: ExpressionStmtSyntax) -> StmtSyntax {
        print("ExpressionStmtSyntax: \(node)" )
        return super.visit(node)
    }

    override func visit(_ node: FunctionCallExprSyntax) -> ExprSyntax {
        // Only rewrite function calls that are on "dependencies"
        if node.calledExpression.withoutTrivia().description == ".executableTarget" {
            let argumentList: [TupleExprElementListSyntax.Element] = node.argumentList.map { dependencies -> TupleExprElementListSyntax.Element in
                guard dependencies.label?.withoutTrivia().description == .some("dependencies") else {
                    return dependencies
                }
                if var array = ArrayExprSyntax(dependencies.expression) {
                    let funcSyntax = FunctionCallExprSyntax(stringLiteral: #".product(name: "\#(productName)", package: "\#(dependencyName)")"#)
                    array = array.addElement(.init(leadingTrivia: .newline, expression: funcSyntax, trailingComma: .comma))

                    print(array.description)
                    var dependencies = dependencies
                    dependencies.expression = array.as(ExprSyntax.self)!
                    return dependencies
                }
                return dependencies
            }

            let newArgumentList = TupleExprElementListSyntax(argumentList)
            let newNode = node.withArgumentList(newArgumentList)
            return super.visit(newNode)
        }
//        print("functionName: \(node.calledExpression.withoutTrivia().description)" )

        if node.calledExpression.withoutTrivia().description == "Package" {
            //print("code: `\(node.description)`")
            print("functionName: \(node.calledExpression.withoutTrivia())" )
//            print( node.argumentList.map({ $0.label?.withoutTrivia() }) )
            
            let argumentList: [TupleExprElementListSyntax.Element] = node.argumentList.map { dependencies -> TupleExprElementListSyntax.Element in
                if dependencies.label?.withoutTrivia().description == .some("dependencies")  {
                    if var array = ArrayExprSyntax(dependencies.expression) {
                        let funcSyntax = FunctionCallExprSyntax(stringLiteral: #".package(url: "\#(url)", from: "\#(version)")"#)
                        array = array.addElement(.init(leadingTrivia: .newline, expression: funcSyntax, trailingComma: .comma))
                        
                        //print(array.description)
                        var dependencies = dependencies
                        dependencies.expression = array.as(ExprSyntax.self)!
                        return dependencies
                    }
                }
                if dependencies.label?.withoutTrivia().description == .some("targets")  {
                    if var array = ArrayExprSyntax(dependencies.expression) {
                        //dump(array)
                        let funcSyntax = FunctionCallExprSyntax(stringLiteral: #".package(url: "\#(url)", from: "\#(version)")"#)
                        array = array.addElement(.init(leadingTrivia: .newline, expression: funcSyntax, trailingComma: .comma))
                        
                        print(array.description)
                        var dependencies = dependencies
                        dependencies.expression = array.as(ExprSyntax.self)!
                        return dependencies
                    }
                }
                return dependencies
            }
            
            let newArgumentList = TupleExprElementListSyntax(argumentList)
//            var node = node
//            node.argumentList = newArgumentList
            let newNode = node.withArgumentList(newArgumentList)

            return super.visit(newNode)

        }
        
        
        return super.visit(node)
    }
}

