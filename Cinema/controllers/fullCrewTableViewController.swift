//
//  fullCrewTableViewController.swift
//  Cinema
//
//  Created by Khaled on 19.04.2020.
//  Copyright © 2020 Khaled. All rights reserved.
//

import UIKit

class fullCrewTableViewController: UITableViewController {
    
    var storeItem = StoreItemController()
    var cast: [CastMembers] = []
    var nameOfTheFilm = "test"
    var imageOfTheFilm: UIImage?
    var counter = 0

    @IBOutlet weak var nameFilm: UILabel!
    @IBOutlet weak var imageFilm: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
//        tableView.separatorColor = UIColor.black
//        tableView.sectionIndexColor = UIColor.black
//        tableView.sectionIndexBackgroundColor = UIColor.black
//        tableView.sectionIndexTrackingBackgroundColor = UIColor.black
//        tableView.sec
        nameFilm.text = nameOfTheFilm
        imageFilm.image = imageOfTheFilm
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
{
    let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 30))
    headerView.backgroundColor = UIColor.lightGray
    
    return headerView
}
    

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return cast.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "crewCell", for: indexPath)
        
        cell.imageView?.image = UIImage(named: "1200px-Question_mark_grey.svg")
        
        if(cast[indexPath.section].profilePath != nil){
        storeItem.fetchImage(url: cast[indexPath.section].profilePath!) { (image) in
            if let image = image{
                DispatchQueue.main.async {
                    cell.imageView?.image = image
                }
            }
         }
        }
        
        
        
    
        cell.textLabel?.text = cast[indexPath.section].name
        cell.detailTextLabel?.text = "as \(cast[indexPath.section].character)"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    

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
