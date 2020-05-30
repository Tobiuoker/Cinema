//
//  filmSearchCollectionViewController.swift
//  Cinema
//
//  Created by Khaled on 19.05.2020.
//  Copyright © 2020 Khaled. All rights reserved.
//

import UIKit
import CoreData

class filmSearchCollectionViewController: UICollectionViewController, UISearchControllerDelegate, UISearchBarDelegate, UISearchResultsUpdating, MyCellDelegate {
    
    var searchText: String = ""
    var idishka: Int = 0
    var storeItem = StoreItemController()
    var counterOfPages = 1
    var filmsItems: [StoreItem] = []
    var filtered:[String] = []
    var searchActive : Bool = false
    let searchController = UISearchController(searchResultsController: nil)
    var filmDetail = filmDetailViewController()
    var counterOfRows = 0
    var allCounterForRows = 0
    var counterBraka = 0
    var filmsFromDB: [NSManagedObject] = []
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let width = (view.frame.size.width - 10) / 2
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: width, height: width + 100)
        
        self.searchController.searchResultsUpdater = self
        self.searchController.delegate = self
        self.searchController.searchBar.delegate = self
        
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.automaticallyShowsCancelButton = false
        
        self.definesPresentationContext = true
//        self.searchController.dimsBackgroundDuringPresentation = true
        self.searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search for films"
        searchController.searchBar.sizeToFit()
        
        //searchController.searchBar.becomeFirstResponder()
        
        self.navigationItem.titleView = searchController.searchBar
        
    }
    
    func starTapped(cell: FilmCollectionViewCell) {
        let indexPath = self.collectionView.indexPath(for: cell)!
                
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
    
    
    func fetchItems(query: String){
        
        let query = [
                    "api_key":"1fc2dab4bce286017391d10ae5a2a0df",
                    "language": "en-US",
                    "page": "\(counterOfPages)",
                    "query": "\(query)"
                ]
                counterOfPages+=1
                
                    storeItem.searchMovie(matching: query) { (films) in
                    if let films = films{
                        DispatchQueue.main.async {
                            self.filmsItems.append(contentsOf: films)
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
    
    
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchString = searchController.searchBar.text
        if(searchString != ""){
            self.searchText = searchString!
        }
        
        self.filmsItems = []
        self.collectionView.reloadData()
        counterOfPages = 1
        fetchItems(query: searchText)
        show()
        
//        filtered = filmsItems.filter({ (item) -> Bool in
//            let countryText: NSString = item as NSString
//
//            return (countryText.range(of: searchString!, options: NSString.CompareOptions.caseInsensitive).location) != NSNotFound
//        })
//        print(searchString!)

        collectionView.reloadData()
    }
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
        self.dismiss(animated: true, completion: nil)
        self.filmsItems = []
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        searchActive = false
        self.dismiss(animated: true, completion: nil)
    }
    
//
//    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
//        searchActive = true
//        collectionView.reloadData()
//    }
//
//
//    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
//        if !searchActive {
//            searchActive = true
//            collectionView.reloadData()
//        }
//
//        searchController.searchBar.resignFirstResponder()
//    }

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
        
//        if searchActive {
//            return filtered.count
//        }
//        else
//        {
//        return filmsItems.count
//        }
        
        return filmsItems.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "filmCell", for: indexPath) as! FilmCollectionViewCell
        if(indexPath.row == filmsItems.count-10){
            fetchItems(query: searchText)
        }
        let item = filmsItems[indexPath.row]
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
