//
//  StoreItem.swift
//  Cinema
//
//  Created by Khaled on 12.04.2020.
//  Copyright © 2020 Khaled. All rights reserved.
//

import Foundation

struct Temp: Codable{
    var results: [StoreItem]
}

struct VideoResults: Codable {
    let details: [VideoKey]
    enum CodingKeys: String, CodingKey {
        case details = "results"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.details = try values.decode([VideoKey].self, forKey: CodingKeys.details)
    }
}

struct VideoKey: Codable {
    let key: String
}


struct StoreItem: Codable{
    var title: String
//    var originalTitle: String
//    var originalLanguage:String
    var popularity: Double
    var posterPath: String?
    var id: Int
//    var backdropPath: URL
    var overview: String
    
    enum CodingKeys: String, CodingKey{
//        case originalTitle = "original_title"
        case title
//        case originalLanguage = "original_language"
        case popularity
        case posterPath = "poster_path"
//        case backdropPath = "backdrop_path"
        case overview
        case id
    }
    
    init(title: String, popularity: Double, posterPath: String?, id: Int, overview: String){
        self.id = id
        self.posterPath = posterPath
        self.overview = overview
        self.popularity = popularity
        self.title = title
    }
    
    
    init(from decoder: Decoder) throws{
        let values = try decoder.container(keyedBy: CodingKeys.self)
//        self.originalTitle = try values.decode(String.self, forKey: CodingKeys.originalTitle)
        self.title = try values.decode(String.self, forKey: CodingKeys.title)
//        self.originalLanguage = try values.decode(String.self, forKey: CodingKeys.originalLanguage)
        self.popularity = try values.decode(Double.self, forKey: CodingKeys.popularity)
        self.posterPath = try values.decode(String?.self, forKey: CodingKeys.posterPath)
//        self.backdropPath = try values.decode(URL.self, forKey: CodingKeys.backdropPath)
        self.overview = try values.decode(String.self, forKey: CodingKeys.overview)
        self.id = try values.decode(Int.self, forKey: CodingKeys.id)
    }
}


struct Genres: Codable{
    var name: String
}

struct FilmDetails: Codable{
    var posterPath: String? //poster_path
    var genres: [Genres]
    var popularity: Double
    var title: String //original_title
    var description: String
    var releaseDate: String //release_date
    var votes: Double //vote_average
    var runtime: Int
    
    enum CodingKeys: String, CodingKey{
        case posterPath = "poster_path"
        case genres
        case popularity
        case title = "original_title"
        case description = "overview"
        case releaseDate = "release_date"
        case votes = "vote_average"
        case runtime
    }
    
    init(from decoder: Decoder) throws{
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.runtime = try values.decode(Int.self, forKey: CodingKeys.runtime)
        self.popularity = try values.decode(Double.self, forKey: CodingKeys.popularity)
        self.posterPath = try values.decode(String?.self, forKey: CodingKeys.posterPath)
        self.genres = try values.decode([Genres].self, forKey: CodingKeys.genres)
        self.title = try values.decode(String.self, forKey: CodingKeys.title)
        self.description = try values.decode(String.self, forKey: CodingKeys.description)
        self.releaseDate = try values.decode(String.self, forKey: CodingKeys.releaseDate)
        self.votes = try values.decode(Double.self, forKey: CodingKeys.votes)
    }
}

struct Cast: Codable{
    var cast: [CastMembers]
    var crew: [CrewMembers]
}

struct CastMembers: Codable{
    var character: String
    var creditID: String
    var name: String
    var profilePath: String?
    var id: Int
    
    enum CodingKeys: String, CodingKey{
        case character
        case creditID = "credit_id"
        case name
        case profilePath = "profile_path"
        case id
    }
    
    init(from decoder: Decoder) throws{
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.character = try values.decode(String.self, forKey: CodingKeys.character)
        self.creditID = try values.decode(String.self, forKey: CodingKeys.creditID)
        self.name = try values.decode(String.self, forKey: CodingKeys.name)
        self.profilePath = try values.decode(String?.self, forKey: CodingKeys.profilePath)
        self.id = try values.decode(Int.self, forKey: CodingKeys.id)
    }
}

struct CrewMembers: Codable{
    var creditID: String
    var department: String
    var id: Int
    var job: String
    var name: String
    var profilePath: String?
    
    enum CodingKeys: String, CodingKey{
        case creditID = "credit_id"
        case department
        case id
        case job
        case name
        case profilePath = "profile_path"
    }
    
    init(from decoder: Decoder) throws{
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.creditID = try values.decode(String.self, forKey: CodingKeys.creditID)
        self.department = try values.decode(String.self, forKey: CodingKeys.department)
        self.id = try values.decode(Int.self, forKey: CodingKeys.id)
        self.job = try values.decode(String.self, forKey: CodingKeys.job)
        self.name = try values.decode(String.self, forKey: CodingKeys.name)
        self.profilePath = try values.decode(String?.self, forKey: CodingKeys.profilePath)
    }
}
