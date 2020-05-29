//
//  File.swift
//  Cinema
//
//  Created by Khaled on 12.04.2020.
//  Copyright © 2020 Khaled. All rights reserved.
//

import Foundation
import UIKit
class StoreItemController{
    func fetchItems(type:String, matching query:[String:String], completion: @escaping ([StoreItem]?) -> Void){
        var url = URL(string: "https://api.themoviedb.org/3/movie/")!
        url.appendPathComponent(type)
        guard let newUrl = url.withQueries(query) else {return}
        print(newUrl)
        let task = URLSession.shared.dataTask(with: newUrl){
            (data, response, error) in
            let decoder = JSONDecoder()
            if let data = data,
                let decoded = try? decoder.decode(Temp.self, from: data){
//                DispatchQueue.main.async {
                    completion(decoded.results)
//                }
            } else {
                print("Error")
                completion(nil)
            }
        }
        task.resume()
    }
    
    func fetchImage(url: String, completion: @escaping (UIImage?) -> Void){
        let baseURL = URL(string: "https://image.tmdb.org/t/p/w500")!
        let newURL = baseURL.appendingPathComponent(url)
        let task = URLSession.shared.dataTask(with: newURL) { (data, response, error) in
            if let data = data,
                let image = UIImage(data: data){
                completion(image)
            } else {
                completion(nil)
            }
        }
        task.resume()
    }
    
    func fetchVideo(id:Int, matching query:[String:String], completion: @escaping ([VideoKey]?) -> Void){
        var testURL = URL(string: "https://api.themoviedb.org/3/movie/")
        testURL = testURL?.appendingPathComponent(String(id), isDirectory: false)
        testURL = testURL?.appendingPathComponent("videos", isDirectory: false)
        guard let newURL = testURL?.withQueries(query) else {return}
        let task = URLSession.shared.dataTask(with: newURL){
            (data, response, error) in
            let decoder = JSONDecoder()
            if let data = data,
                let decoded = try? decoder.decode(VideoResults.self, from: data){
                completion(decoded.details)
            } else {
                print("ErrorHm")
                completion(nil)
            }
        }
        task.resume()
    }
    
    func fetchFilmDetails(id: Int, matching query:[String:String], completion: @escaping (FilmDetails?) -> Void){
        var testURL = URL(string: "https://api.themoviedb.org/3/movie/")!
        testURL.appendPathComponent(String(id))
        guard let newURL = testURL.withQueries(query) else {return}
        let task = URLSession.shared.dataTask(with: newURL) { (data, response, error) in
            let decoder = JSONDecoder()
            if let data = data,
                let decoded = try? decoder.decode(FilmDetails.self, from: data){
                completion(decoded)
            } else {
                completion(nil)
                print("EHHHHHH")
            }
        }
        task.resume()
    }
    
    
    func fetchCrewAndCast(id: Int, matching query:[String:String], completion: @escaping (Cast?) -> Void){
        var testURL = URL(string: "https://api.themoviedb.org/3/movie/")!
        testURL.appendPathComponent(String(id))
        testURL.appendPathComponent("credits")
        guard let newURL = testURL.withQueries(query) else {return}
        let task = URLSession.shared.dataTask(with: newURL) { (data, response, error) in
            let decoder = JSONDecoder()
            if let data = data,
                let decoded = try? decoder.decode(Cast.self, from: data){
                completion(decoded)
            } else {
                completion(nil)
                print("EHHHHHH")
            }
        }
        task.resume()
    }
    
    func searchMovie(matching query:[String:String], completion: @escaping ([StoreItem]?) -> Void){
        
        let testURL = URL(string: "https://api.themoviedb.org/3/search/movie")!
        guard let newURL = testURL.withQueries(query) else {return}
        print(newURL)
        let task = URLSession.shared.dataTask(with: newURL){
            (data, response, error) in
            let decoder = JSONDecoder()
            if let data = data,
                let decoded = try? decoder.decode(Temp.self, from: data){
                completion(decoded.results)
            } else {
                completion(nil)
                print("EHHHHHH")
            }
        }
        task.resume()
    }
    
}
