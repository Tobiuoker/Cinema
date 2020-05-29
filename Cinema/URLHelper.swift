//
//  File.swift
//  Cinema
//
//  Created by Khaled on 12.04.2020.
//  Copyright © 2020 Khaled. All rights reserved.
//

import Foundation

extension URL {
//    func withQueries(queries:[String : String]) -> URL?{
//        var components = URLComponents(url: self, resolvingAgainstBaseURL: true)
//        components?.queryItems = queries.map{URLQueryItem(name: $0.0, value: $0.1)}
//        return components?.url
//    }
    func withQueries(_ queries: [String: String]) -> URL? {
            var components = URLComponents(url: self,
            resolvingAgainstBaseURL: true)
            components?.queryItems = queries.map
            { URLQueryItem(name: $0.0, value: $0.1) }
            return components?.url
        }
}
