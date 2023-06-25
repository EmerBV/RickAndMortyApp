//
//  APPRequest.swift
//  RickAndMortyApp
//
//  Created by Emerson Balahan Varona on 22/6/23.
//

import Foundation

///
final class APPRequest {
    ///
    private struct Constants {
        static let baseUrl = "https://rickandmortyapi.com/api"
    }

    /// 
    let endpoint: APPEndpoint

    ///
    private let pathComponents: [String]

    ///
    private let queryParameters: [URLQueryItem]

    ///
    private var urlString: String {
        var string = Constants.baseUrl
        string += "/"
        string += endpoint.rawValue

        if !pathComponents.isEmpty {
            pathComponents.forEach({
                string += "/\($0)"
            })
        }

        if !queryParameters.isEmpty {
            string += "?"
            let argumentString = queryParameters.compactMap({
                guard let value = $0.value else { return nil }
                return "\($0.name)=\(value)"
            }).joined(separator: "&")

            string += argumentString
        }

        return string
    }

    ///
    public var url: URL? {
        return URL(string: urlString)
    }

    ///
    public let httpMethod = "GET"

    // MARK: - Public

    ///
    public init(
        endpoint: APPEndpoint,
        pathComponents: [String] = [],
        queryParameters: [URLQueryItem] = []
    ) {
        self.endpoint = endpoint
        self.pathComponents = pathComponents
        self.queryParameters = queryParameters
    }

    ///
    convenience init?(url: URL) {
        let string = url.absoluteString
        if !string.contains(Constants.baseUrl) {
            return nil
        }
        let trimmed = string.replacingOccurrences(of: Constants.baseUrl+"/", with: "")
        if trimmed.contains("/") {
            let components = trimmed.components(separatedBy: "/")
            if !components.isEmpty {
                let endpointString = components[0]
                var pathComponents: [String] = []
                if components.count > 1 {
                    pathComponents = components
                    pathComponents.removeFirst()
                }
                if let appEndpoint = APPEndpoint(
                    rawValue: endpointString
                ) {
                    self.init(endpoint: appEndpoint, pathComponents: pathComponents)
                    return
                }
            }
        } else if trimmed.contains("?") {
            let components = trimmed.components(separatedBy: "?")
            if !components.isEmpty, components.count >= 2 {
                let endpointString = components[0]
                let queryItemsString = components[1]
                let queryItems: [URLQueryItem] = queryItemsString.components(separatedBy: "&").compactMap({
                    guard $0.contains("=") else {
                        return nil
                    }
                    let parts = $0.components(separatedBy: "=")

                    return URLQueryItem(
                        name: parts[0],
                        value: parts[1]
                    )
                })

                if let appEndpoint = APPEndpoint(rawValue: endpointString) {
                    self.init(endpoint: appEndpoint, queryParameters: queryItems)
                    return
                }
            }
        }

        return nil
    }
}

// MARK: - Request convenience

extension APPRequest {
    static let listCharactersRequests = APPRequest(endpoint: .character)
    static let listEpisodesRequest = APPRequest(endpoint: .episode)
    static let listLocationsRequest = APPRequest(endpoint: .location)
}
