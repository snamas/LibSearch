//
//  LibserchTableView.swift
//  LibSearchSys
//
//  Created by yuto on 2019/02/07.
//

import UIKit

class LibserchTableView: UITableViewController,UISearchBarDelegate {
    let weblist = [
        (name:"rei",url : "func"),
        (name:"rei2",url : "func2")
    ]
    @IBOutlet weak var Libsearchbar: UISearchBar!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        var LibData = Libdatafetch()
        //LibData.fetch_askidf()
        Libsearchbar.delegate = self//(https://daisa-n.com/blog/uisearchbar-search-sample/)ここ参照
        Libsearchbar.showsCancelButton = false
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return weblist.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let webdata = weblist[indexPath.row]
        cell.textLabel?.text = webdata.name
        cell.detailTextLabel?.text = webdata.url
        // Configure the cell...

        return cell
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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showlendlist"{
            if let indexPath = self.tableView.indexPathForSelectedRow{
                let webData = weblist[indexPath.row]
                (segue.destination as! LendTableViewController).data = webData
            }
        }
    }
    //━━━━━━━[ここから検索画面の実装]━━━━━━━━━━━━━━━━…‥・
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let a = searchBar.text{
            Libdatafetch.ctlsrhformDB["words"] = a
        }
        Libsearchbar.endEditing(true)
        Libsearchbar.showsCancelButton = false
        performSegue(withIdentifier: "searchView", sender: self)
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        Libsearchbar.showsCancelButton = true
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        Libsearchbar.showsCancelButton = false
        searchBar.text = ""
        Libsearchbar.endEditing(true)
    }

}
