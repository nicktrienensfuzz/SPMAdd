//
//  File.swift
//  
//
//  Created by Nicholas Trienens on 5/17/23.
//

import Foundation

public class GithubAPI {
    private let requester: Requester
    private let token: String
    
    public init(requester: Requester = RequestMaker(), token: String  = "") {
        self.requester = requester
        self.token = token
    }
    
    func fetchReleases(repo: String) async throws -> [ReleaseElement] {
        var extractedRepo = repo
        if repo.hasPrefix("https://github.com/") {
            extractedRepo = extractedRepo.replacingOccurrences(of: "https://github.com/", with: "")
        }
        let headers: [String: String] = [
            "Accept": "application/vnd.github+json",
            "Authorization": "Bearer \(token)",
            "X-GitHub-Api-Version": "2022-11-28"
        ]
        // "https://raw.githubusercontent.com/\(extractedRepo)/main/Package.swift"
        let request = Endpoint(method: .GET,
                               path: "https://api.github.com/repos/\(extractedRepo)/releases",
                               headers: headers)
        
        print(request.cURLRepresentation())
        
        let data = try await requester.makeRequest(request)
        // let response = String(data: data, encoding: .utf8)!
        // print(response)

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        do {
            return try decoder.decode([ReleaseElement].self, from: data)
        } catch {
            print(#function)
            print(error)
            return []
        }
        
    }
    
    func fetchContent(repo: String, filename: String) async throws -> FileResponse {
        var extractedRepo = repo
        if repo.hasPrefix("https://github.com/") {
            extractedRepo = extractedRepo.replacingOccurrences(of: "https://github.com/", with: "")
        }
        let headers: [String: String] = [
            "Accept": "application/vnd.github+json",
            "Authorization": "Bearer \(token)",
            "X-GitHub-Api-Version": "2022-11-28"
        ]
        
        let request = Endpoint(method: .GET,
                               path: "https://api.github.com/repos/\(extractedRepo)/contents/\(filename)",
                               headers: headers)
        
        // print(request.cURLRepresentation())
        
        let data = try await requester.makeRequest(request)
        let response = String(data: data, encoding: .utf8)!
        print(response)

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        do {
            return try decoder.decode(FileResponse.self, from: data)
        } catch {
            print(#function)
            throw error
        }
    }
    
}
