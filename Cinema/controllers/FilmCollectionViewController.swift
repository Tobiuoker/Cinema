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
    var manipulation = Manipulation()
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
    
    var mediaType = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mediaType = options[segmentedControl.selectedSegmentIndex]
        
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
            manipulation.save(id: filmsItems[indexPath.row].id, overview: filmsItems[indexPath.row].overview, popularity: filmsItems[indexPath.row].popularity, posterPath: filmsItems[indexPath.row].posterPath ?? "", title: filmsItems[indexPath.row].title, type: "Favourite")
            print("saved")
        } else{
            cell.isFavourite = false
            cell.starButton.setImage(UIImage(systemName: "star"), for: .normal)
            
            manipulation.delete(id: filmsItems[indexPath.row].id)
            
//            self.collectionView.reloadData()
            print("deleted")
        }
        if mediaType == "Favourite"{
//            collectionView.reloadData()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        //dodelat update favourite (obnovlenie pri smene tab)
        if mediaType == "Favourite"{
            filmsFromDBFav = []
            filmsItems = []
            show()
            fetchFromSaved(filmsFromDB: filmsFromDBFav)
            collectionView.reloadData()
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
        var fetchRequest: NSFetchRequest<NSManagedObject>?
        if mediaType == "Popular"{
            
            fetchRequest =
                NSFetchRequest<NSManagedObject>(entityName: "Popular")
            
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
        mediaType = options[segmentedControl.selectedSegmentIndex]
        self.filmsItems = []
        self.filmsFromDB = []
        self.filmsFromDBFav = []
        
        self.collectionView.reloadData()
        counterOfPages = 1

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
                                self.manipulation.save(id: i.id, overview: i.overview, popularity: i.popularity, posterPath: i.posterPath ?? "", title: i.title, type: self.mediaType)
                            }
                            print("v itoge vsego", self.filmsItems.count)
                            self.collectionView.reloadData()
                        }
                    }
        
                }
    }

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
    
    
    
    
    



    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return filmsItems.count

    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "filmCell", for: indexPath) as! FilmCollectionViewCell
        
        if mediaType != "Favourite"{
            if(indexPath.row == filmsItems.count-10){
                fetchItems()
            }
        }
        
            
        let item = filmsItems[indexPath.row]
            
        
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
    

}
