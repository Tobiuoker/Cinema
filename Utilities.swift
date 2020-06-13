//
//  Utilities.swift
//  Cinema
//
//  Created by Khaled on 13.06.2020.
//  Copyright © 2020 Khaled. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class Manipulation{
    
    func save(id: Int, overview: String, popularity: Double, posterPath: String, title: String, type: String){
        
        guard let appDelegate =
          UIApplication.shared.delegate as? AppDelegate else {
          return
        }
        
        
        
        let managedContext =
         appDelegate.persistentContainer.viewContext
        

        var entity: NSEntityDescription?
        
            entity =
            NSEntityDescription.entity(forEntityName: type,
                                       in: managedContext)!
        let film = NSManagedObject(entity: entity!,
                                     insertInto: managedContext)
        
        // 3
    
        film.setValue(id, forKeyPath: "id")
        film.setValue(overview, forKeyPath: "overview")
        film.setValue(popularity, forKeyPath: "popularity")
        film.setValue(posterPath, forKeyPath: "posterPath")
        film.setValue(title, forKeyPath: "title")
        
        // 4
        do {
          try managedContext.save()
        } catch let error as NSError {
          print("Could not save. \(error), \(error.userInfo)")
        }
        
    }
    
    func delete(id: Int){
        guard let appDelegate =
          UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let context = appDelegate.persistentContainer.viewContext
        let entityDescription = NSEntityDescription.entity(forEntityName: "Favourite", in: context)
        
        let request = NSFetchRequest<NSFetchRequestResult>()
        request.predicate = NSPredicate(format: "id == \(id)")
        request.entity = entityDescription
        
        do {
            let objects = try context.fetch(request)
            if objects.count > 0 {
                for i in objects{
                    context.delete(i as! NSManagedObject)
                }
            }
        } catch {
            fatalError("\(error)")
        }
    }
}
