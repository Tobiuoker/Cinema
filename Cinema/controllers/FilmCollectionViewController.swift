//
//  FilmCollectionViewController.swift
//  Cinema
//
//  Created by Khaled on 14.04.2020.
//  Copyright © 2020 Khaled. All rights reserved.
//

import UIKit
import CoreData
import  Network

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
    var options = ["Popular", "TopRated", "Favourite"]
    
    var filmsFromDB: [NSManagedObject] = []
    var filmsFromDBFav: [NSManagedObject] = []
    
    let monitor = NWPathMonitor()
    let queue = DispatchQueue(label: "InternetConnectionMonitor")
    
    var hasInternet = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        monitor.pathUpdateHandler = { pathUpdateHandler in
                if pathUpdateHandler.status == .satisfied {
                    print("Internet connection is on.")
                    DispatchQueue.main.async {
                        self.deleting(type: "Popular")
                    }
                    print("opa")
                } else {
                    print("There's no internet connection.")
                    self.hasInternet = false
                }
            }

            monitor.start(queue: queue)
        
        
        
//        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        let width = (view.frame.size.width - 10) / 2
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: width, height: width + 100)
        // Do any additional setup after loading the view.
        
        
        show()
        if hasInternet{
            fetchItems()
        } else {
            fetchFromSaved(filmsFromDB: filmsFromDB)
        }
        
        
//        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
//        print(paths[0])
    }
    
    func starTapped(cell: FilmCollectionViewCell) {
        let indexPath = self.collectionView.indexPath(for: cell)!
//        print(filmsItems[indexPath.row].title)
        
        if cell.isFavourite{
            cell.isFavourite = true
            cell.starButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
            save(id: filmsItems[indexPath.row].id, overview: filmsItems[indexPath.row].overview, popularity: filmsItems[indexPath.row].popularity, posterPath: filmsItems[indexPath.row].posterPath ?? "", title: filmsItems[indexPath.row].title, type: "Favourite")
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
            
            for i in filmsFromDBFav{
                if i.value(forKey: "id") as! Int == filmsItems[indexPath.row].id{
                    managedContext.delete(i as NSManagedObject)
                    do{
                        try managedContext.save()
                        print("rilUdalil")
                    } catch let error as NSError {
                      print("Error in deleting")
                    }
                    
                }
            }
            print("deleted")
        }
        
    }

    
    func show(){
        let mediaType = options[segmentedControl.selectedSegmentIndex]
        
        guard let appDelegate =
           UIApplication.shared.delegate as? AppDelegate else {
             return
         }
         
         let managedContext =
           appDelegate.persistentContainer.viewContext
         
         //2
        var fetchRequest: NSFetchRequest<NSManagedObject>?
        if mediaType == "Popular"{
            
            fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "Popular")
            let managedContextt = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            do {
                let qwe = try managedContext.fetch(fetchRequest!)
               filmsFromDB.append(contentsOf: qwe)
                print(filmsFromDB.count)
            } catch let error as NSError {
              print("Could not fetch. \(error), \(error.userInfo)")
            }
            
        } else if mediaType == "TopRated"{
            
            fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "TopRated")
            do {
               let qwe = try managedContext.fetch(fetchRequest!)
               filmsFromDB.append(contentsOf: qwe)
                print(filmsFromDB.count)
            } catch let error as NSError {
              print("Could not fetch. \(error), \(error.userInfo)")
            }
        }
         
        fetchRequest =
        NSFetchRequest<NSManagedObject>(entityName: "Favourite")
        let managedContextt = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

        
         //3
         do {
            let qwe = try managedContext.fetch(fetchRequest!)
            filmsFromDBFav.append(contentsOf: qwe)
         } catch let error as NSError {
           print("Could not fetch. \(error), \(error.userInfo)")
         }
    }
    
    
    func save(id: Int, overview: String, popularity: Double, posterPath: String, title: String, type: String){
        
        
        let mediaType = options[segmentedControl.selectedSegmentIndex]
        guard let appDelegate =
          UIApplication.shared.delegate as? AppDelegate else {
          return
        }
        
        
        // 1
        let managedContext =
          appDelegate.persistentContainer.viewContext
        
        // 2
//        var entity =
//          NSEntityDescription.entity(forEntityName: "Favourite",
//                                     in: managedContext)!
        var entity: NSEntityDescription?
        
//        if mediaType == "Favourite"{
        if type != "Favourite"{
//            let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: type)
//            let request = NSBatchDeleteRequest(fetchRequest: fetch)
//
//            do {
//                let result = try managedContext.execute(request)
//            } catch let error as NSError {
//                // TODO: handle the error
//            }
            
        }
            
            entity =
            NSEntityDescription.entity(forEntityName: type,
                                       in: managedContext)!
//            print("chetam")
            
            
//        } else if mediaType == "popular"{
//            let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Popular")
//            let request = NSBatchDeleteRequest(fetchRequest: fetch)
//
//            do {
//                let result = try managedContext.execute(request)
//            } catch let error as NSError {
//                // TODO: handle the error
//            }
//
//
//            entity =
//            NSEntityDescription.entity(forEntityName: "Favourite",
//                                       in: managedContext)!
//
//        } else if mediaType == "top_rated"{
//
//            entity =
//            NSEntityDescription.entity(forEntityName: "Favourite",
//                                       in: managedContext)!
//
//        }
        
        
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
    
//    func savePopular(){
//        var cell = self.collectionView.cellForItem(at: IndexPath(row: 0, section: 0)) as! FilmCollectionViewCell
//        print(cell.cellFilmImage.image!)
//
//    }
//
//    func saveTopRated(){
//
//    }
    
    func fetchFromSaved(filmsFromDB: [NSManagedObject]){
        
        for i in filmsFromDB{
            
            let title = i.value(forKeyPath: "title") as! String
            let popularity = i.value(forKeyPath: "popularity") as! Double
            let posterPath = i.value(forKeyPath: "posterPath") as! String
            let overview = i.value(forKeyPath: "overview") as! String
            let id = i.value(forKeyPath: "id") as! Int
            let item = StoreItem(title: title, popularity: popularity, posterPath: posterPath, id: id, overview: overview)
            self.filmsItems.append(item)
            
        }
        
        self.collectionView.reloadData()
    }
    
    func deleting(type: String){
        
        guard let appDelegate =
          UIApplication.shared.delegate as? AppDelegate else {
          return
        }
        
        
        // 1
        let managedContext =
          appDelegate.persistentContainer.viewContext
        
        
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: type)
        let request = NSBatchDeleteRequest(fetchRequest: fetch)

        do {
            let result = try managedContext.execute(request)
        } catch let error as NSError {
            // TODO: handle the error
        }
        
    }
    
    @IBAction func segmentedControlChanged(_ sender: Any) {
        self.filmsItems = []
        self.filmsFromDB = []
        self.filmsFromDBFav = []
        
        self.collectionView.reloadData()
        counterOfPages = 1
        let mediaType = options[segmentedControl.selectedSegmentIndex]

        if mediaType != "Favourite", hasInternet{
            deleting(type: mediaType)
        }
        
        show()
        if hasInternet{
            if mediaType == "Favourite"{
                fetchFromSaved(filmsFromDB: filmsFromDBFav)
            } else {
                fetchItems()
            }
        } else {
            if mediaType == "Favourite"{
                fetchFromSaved(filmsFromDB: filmsFromDBFav)
            } else {
                fetchFromSaved(filmsFromDB: filmsFromDB)
            }
        }
        
        
    }
    func fetchItems(){
        
        let mediaType = options[segmentedControl.selectedSegmentIndex]
        var type = ""
        if mediaType == "Popular"{
            type = "popular"
        } else if mediaType == "TopRated"{
            type = "top_rated"
        }
        
        let query = [
                    "api_key":"1fc2dab4bce286017391d10ae5a2a0df",
                    "language": "en-US",
                    "page": "\(counterOfPages)"
                ]
                counterOfPages+=1
                
                    storeItem.fetchItems(type: type, matching: query) { (films) in
                    if let films = films{
                        DispatchQueue.main.async {
                            self.filmsItems.append(contentsOf: films)
                            for i in self.filmsItems{
                                self.save(id: i.id, overview: i.overview, popularity: i.popularity, posterPath: i.posterPath ?? "", title: i.title, type: mediaType)
                            }
                            print("v itoge vsego", self.filmsItems.count)
                            self.collectionView.reloadData()
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
        
        let mediaType = options[segmentedControl.selectedSegmentIndex]
        if mediaType != "Favourite"{
            if(indexPath.row == filmsItems.count-10){
                fetchItems()
            }
        }
        
            
            let item = filmsItems[indexPath.row]
            
            
        //print(filmsItems.count)
        
        
        var newImage:UIImage = UIImage(named: "Solid_gray")!
        
        if let imgURL = item.posterPath, hasInternet{
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
        for i in filmsFromDBFav{
            if(i.value(forKey: "id") as! Int == item.id){
                print(item.title)
                cell.starButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
                cell.isFavourite = true
            }
            
        }
    
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
