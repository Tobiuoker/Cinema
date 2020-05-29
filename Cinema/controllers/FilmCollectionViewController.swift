//
//  FilmCollectionViewController.swift
//  Cinema
//
//  Created by Khaled on 14.04.2020.
//  Copyright © 2020 Khaled. All rights reserved.
//

import UIKit
import CoreData

protocol getID{
    func getID(id: Int)
}

private let reuseIdentifier = "Cell"

class FilmCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, MyCellDelegate {
    
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    var delegate: getID?
    var idishka: Int = 0
    var filmDetail = filmDetailViewController()
    var storeItem = StoreItemController()
    var filmsItems: [StoreItem] = []
    var counterOfPages = 1
    var counterOfRows = 0
    var allCounterForRows = 0
    var counterBraka = 0
    var options = ["popular", "top_rated", "Favourite"]
    
    var filmsFromDB: [NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        let width = (view.frame.size.width - 10) / 2
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: width, height: width + 100)
        // Do any additional setup after loading the view.
        
        fetchItems()
        show()
        
        
//        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
//        print(paths[0])
    }
    
    func starTapped(cell: FilmCollectionViewCell) {
        let indexPath = self.collectionView.indexPath(for: cell)!
//        print(filmsItems[indexPath.row].title)
        
        if cell.isFavourite{
            cell.isFavourite = true
            cell.starButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
            save(id: filmsItems[indexPath.row].id, overview: filmsItems[indexPath.row].overview, popularity: filmsItems[indexPath.row].popularity, posterPath: filmsItems[indexPath.row].posterPath ?? "", title: filmsItems[indexPath.row].title)
            print("saved")
        } else{
            cell.isFavourite = false
            cell.starButton.setImage(UIImage(systemName: "star"), for: .normal)
            guard let appDelegate =
              UIApplication.shared.delegate as? AppDelegate else {
                return
            }
            
            let managedContext =
              appDelegate.persistentContainer.viewContext
            
            for i in filmsFromDB{
                if i.value(forKey: "id") as! Int == filmsItems[indexPath.row].id{
                    managedContext.delete(i as NSManagedObject)
                    do{
                        try managedContext.save()
                    } catch let error as NSError {
                      print("Error in deleting")
                    }
                    
                }
            }
            print("deleted")
        }
        
    }

    
    func show(){
        
        
        guard let appDelegate =
           UIApplication.shared.delegate as? AppDelegate else {
             return
         }
         
         let managedContext =
           appDelegate.persistentContainer.viewContext
         
         //2
         let fetchRequest =
           NSFetchRequest<NSManagedObject>(entityName: "Favourite")

        let managedContextt = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

        
         //3
         do {
           var qwe = try managedContext.fetch(fetchRequest)
            filmsFromDB.append(contentsOf: qwe)

         } catch let error as NSError {
           print("Could not fetch. \(error), \(error.userInfo)")
         }
    }
    
    
    func save(id: Int, overview: String, popularity: Double, posterPath: String, title: String){
        
        guard let appDelegate =
          UIApplication.shared.delegate as? AppDelegate else {
          return
        }
        
        
        // 1
        let managedContext =
          appDelegate.persistentContainer.viewContext
        
        // 2
        let entity =
          NSEntityDescription.entity(forEntityName: "Favourite",
                                     in: managedContext)!
        
        let film = NSManagedObject(entity: entity,
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
    
    
    func fetchFromSaved(){
        for i in filmsFromDB{
            
            let title = i.value(forKeyPath: "title") as! String
            let popularity = i.value(forKeyPath: "popularity") as! Double
            let posterPath = i.value(forKeyPath: "posterPath") as! String
            let overview = i.value(forKeyPath: "overview") as! String
            let id = i.value(forKeyPath: "id") as! Int
            let item = StoreItem(title: title, popularity: popularity, posterPath: posterPath, id: id, overview: overview)
            self.filmsItems.append(item)
            
        }
        print(filmsFromDB.count)
        self.collectionView.reloadData()
    }
    
    
    @IBAction func segmentedControlChanged(_ sender: Any) {
        self.filmsItems = []
        self.filmsFromDB = []
        self.collectionView.reloadData()
        counterOfPages = 1
        let mediaType = options[segmentedControl.selectedSegmentIndex]
        show()
        if mediaType == "Favourite"{
            fetchFromSaved()
        } else {
            fetchItems()
        }
        
    }
    func fetchItems(){
        
        let mediaType = options[segmentedControl.selectedSegmentIndex]
        
        let query = [
                    "api_key":"1fc2dab4bce286017391d10ae5a2a0df",
                    "language": "en-US",
                    "page": "\(counterOfPages)"
                ]
                counterOfPages+=1
                
        //        print(query)
        //        print(query["page"] = "3")
        //        print(query)
                    storeItem.fetchItems(type: mediaType, matching: query) { (films) in
                    if let films = films{
                        DispatchQueue.main.async {
                            self.filmsItems.append(contentsOf: films)
                            print("v itoge vsego", self.filmsItems.count)
                            self.collectionView.reloadData()
        //                    self.tableView.beginUpdates()
        //                    self.tableView.endUpdates()
                        }
                    }
        //            else {
        //                print("vozvrat i na straince ", self.counterOfPages-1)
        ////                self.counterOfPages+=1
        //                self.fetchItems()
        //            }
                }
    }
    
//    func prepare(segue: UIStoryboardSegue){
//        if segue.identifier == "filmDetail"{
//            let destination = segue.destination as? filmDetailViewController
//            let index = collectionView.indexPathsForSelectedItems!.first
////            collectionView.cellForItem(at: index!).
//        }
//    }
//
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let indexPath = collectionView.indexPathsForSelectedItems?.first,
            let cell = collectionView.cellForItem(at: indexPath) as? FilmCollectionViewCell,
            let id = cell.id{
            self.idishka = id
            performSegue(withIdentifier: "filmDetail", sender: nil)
            
            }
        }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("zad=shel")
        if segue.identifier == "filmDetail"{
            let destin = segue.destination as? filmDetailViewController
            destin?.id = idishka
        }
    }
    
    
    
    
    

    /*
     
     
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
//        let mediaType = options[segmentedControl.selectedSegmentIndex]
//        if mediaType == "Favourite"{
//            return filmsFromDB.count
//        } else {
            return filmsItems.count
//        }
        
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "filmCell", for: indexPath) as! FilmCollectionViewCell
        
//        let mediaType = options[segmentedControl.selectedSegmentIndex]
//        if mediaType == "Favourite"{
//            let item = filmsFromDB[indexPath.row]
//        } else {
            if(indexPath.row == filmsItems.count-10){
                fetchItems()
            }
            let item = filmsItems[indexPath.row]
//        }
        
        
        
        var newImage:UIImage = UIImage(named: "Solid_gray")!
        
        if let imgURL = item.posterPath{
            storeItem.fetchImage(url: imgURL) { (image) in
                if let image = image{
                    DispatchQueue.main.async {
                        newImage = image
                        cell.update(title: item.title, popularity: "\(Double(round(10*item.popularity)/10))", image: newImage)
                        cell.id = item.id
                    }
                }
            }
        } else {
            cell.update(title: item.title, popularity: "\(Double(round(10*item.popularity)/10))", image: newImage)
            cell.id = item.id
        }
        
        cell.delegate = self
        cell.starButton.setImage(UIImage(systemName: "star"), for: .normal)
        cell.isFavourite = false
        for i in filmsFromDB{
            if(i.value(forKey: "id") as! Int == item.id){
                print(item.title)
                cell.starButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
                cell.isFavourite = true
            }
        }
        
//        for i in filmsFromDB{
//                        if(i.value(forKeyPath: "popularity") as? Double == 997){
//                            let temp = i as NSManagedObject
//                            managedContext.delete(temp)
//                            try managedContext.save()
//
//                        }
//                    }
        
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
