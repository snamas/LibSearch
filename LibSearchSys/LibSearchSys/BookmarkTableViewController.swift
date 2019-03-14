//
//  BookmarkTableViewController.swift
//  LibSearchSys
//
//  Created by yuto on 2019/03/14.
//

import UIKit

class BookmarkTableViewController: UITableViewController {
    var LibData = Libdatafetch()
    let urlSessionGetClient = URLSessionGetClient()
    var SearchResultList : [(BibliographyID:String,opacIcon:String,book_title:String,Author:String)] = []
    var image_list : [(UIImage)] = []
    private var imagestatus : Bool = false
    func fetch_bookmarklst(){
        imagestatus = false
        LibData.fetch_bookmark(createList:{book_title_List,book_Auther_List,BibliographyID_List,opacIcon_List in
            if book_title_List.count != 0 && book_Auther_List.count != 0 && BibliographyID_List.count != 0 && opacIcon_List.count != 0{
                for i in 0..<book_title_List.count {
                    self.SearchResultList.append((BibliographyID_List[i],opacIcon_List[i],book_title_List[i],book_Auther_List[i]))
                }
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            for imagepart in opacIcon_List {
                self.urlSessionGetClient.get(url: "https://tmuopac.lib.tmu.ac.jp" + imagepart, completion: { data in
                    self.image_list.append(UIImage(data: data) ?? UIImage(named: "book")!)
                    if self.image_list.count == self.SearchResultList.count{
                        self.imagestatus = true
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                })
            }
            print(book_title_List,book_Auther_List,BibliographyID_List,opacIcon_List)
        })
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        fetch_bookmarklst()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return SearchResultList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "bookmarkCell", for: indexPath)
        let webdata = self.SearchResultList[indexPath.row]
        cell.textLabel?.text = webdata.book_title
        cell.detailTextLabel?.text = "\(webdata.Author)"
        if !self.image_list.isEmpty && imagestatus{
            let imagedata = self.image_list[indexPath.row]
            cell.imageView?.image = imagedata
        }
        // Configure the cell...

        return cell
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "DetailBooksSegue"{
            if let indexPath = self.tableView.indexPathForSelectedRow{
                let webData = SearchResultList[indexPath.row]
                let imagedata = image_list[indexPath.row]
                (segue.destination as! DetailResultView).data = webData
                (segue.destination as! DetailResultView).BookImage = imagedata
            }
        }
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
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
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
