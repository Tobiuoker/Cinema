//
//  CinemaTableViewController.swift
//  Cinema
//
//  Created by Khaled on 12.04.2020.
//  Copyright © 2020 Khaled. All rights reserved.
//

import UIKit

class CinemaTableViewController: UITableViewController {
    
    @IBOutlet weak var cegmentedControl: UISegmentedControl!
    
    let queryOptions = ["top_rated", "popular"]
    
    //AaaaaaaaAaaaaaaaAaaaaaaaAaaaaaaaAaaaaaaaAaaaaaaaAaaaaaaa
    var storeItem = StoreItemController()
    var filmsItems: [StoreItem] = []
    var counterOfPages = 1
    var counterOfRows = 0
    var allCounterForRows = 0
    var counterBraka = 0
    override func viewDidLoad() {
        super.viewDidLoad()

        fetchItems()
        
    }
    
    @IBAction func cegmentedControlUpdated(_ sender: Any) {
        fetchItems()
        allCounterForRows = 0
        filmsItems = []
        counterOfPages = 0
        tableView.reloadData()
    }
    
    
    func fetchItems(){
        if(counterOfPages<=357){
            
        
        
            let type = queryOptions[cegmentedControl.selectedSegmentIndex]
        let query = [
            "api_key":"1fc2dab4bce286017391d10ae5a2a0df",
            "language": "en-US",
            "page": "\(counterOfPages)"
        ]
        counterOfPages+=1
        
//        print(query)
//        print(query["page"] = "3")
//        print(query)
            storeItem.fetchItems(type: type, matching: query) { (films) in
            if let films = films{
                DispatchQueue.main.async {
                    self.filmsItems.append(contentsOf: films)
                    print("v itoge vsego", self.filmsItems.count)
                    self.tableView.reloadData()
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
        print("sdelal")
        }
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "showFilm"{
//            let destination = segue.destination as? filmDetailViewController
//            let index = tableView.indexPathForSelectedRow!.row
//            print(index, "vot")
//            print(filmsItems[index].title, "tut")
//            destination?.filmTitleString = filmsItems[index].title
//            destination?.filmDescString = filmsItems[index].overview
//            
//            DispatchQueue.main.async {
//                self.storeItem.fetchImage(url: self.filmsItems[index].posterPath) { (image) in
//                    print("ZASHLOOOOO")
//                    destination?.filmImage.image = image
//                }
//            }
//        }
//    }

    // MARK: - Table view data source
//    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let height = scrollView.frame.size.height
//        let contentYoffset = scrollView.contentOffset.y
//        let distanceFromBottom = scrollView.contentSize.height - contentYoffset
//        if distanceFromBottom < height {
//            fetchItems()
//        }
//    }
    
//    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let offset = scrollView.contentOffset
//        let bounds = scrollView.bounds
//        let size = scrollView.contentSize
//        let inset = scrollView.contentInset
//        let y = offset.y + bounds.size.height - inset.bottom
//        let h = size.height
//        let reload_distance:CGFloat = 10.0
//        if y > (h + reload_distance) {
//            print(filmsItems.count, "scrolldoconca")
////            if(filmsItems.count>1){
//                fetchItems()
////            }
//        }
//    }
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.section == tableView.numberOfSections - 1 &&
            indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 2 {
            print("chetambrat")
//            fetchItems()
        }
    }
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if(filmsItems.isEmpty){
            return 0
        }
        print("sho")
        print(filmsItems.count)
        print(filmsItems.count)
        allCounterForRows+=filmsItems.count
        return allCounterForRows
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cinemaCell", for: indexPath)
        counterOfRows+=1
        print("items", filmsItems.count)
        print("counterofrows", counterOfRows)
        if(indexPath.row == filmsItems.count-10){
            fetchItems()
            fetchItems()
        }
        print("stolkoROW", indexPath.row)
        let item = filmsItems[indexPath.row]
        
        cell.textLabel?.text = item.title
        cell.detailTextLabel?.text = item.overview
        cell.imageView?.image = UIImage(named: "Solid_gray")

//        storeItem.fetchImage(url: item.posterPath) { (image) in
//            if let image = image{
//                DispatchQueue.main.async {
//                    cell.imageView?.image = image
//                }
//            }
//        }
        cell.imageView?.clipsToBounds = true
//        cell.imageView?.frame = CGRect(x:0.0,y:0.0,width:40.0,height:40.0)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        tableView.deselectRow(at: indexPath, animated: true)
    }
//

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
