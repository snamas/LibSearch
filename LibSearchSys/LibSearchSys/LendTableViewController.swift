//
//  LendTableViewController.swift
//  LibSearchSys
//
//  Created by yuto on 2019/02/07.
//
import UIKit

class LendTableViewController: UITableViewController {
    
    var lendlist:[(number:String,crick:String,Status:String,LendLib:String,LendDD:String,Lendingdate:String,Status:String,Biblioinfo:String,MaterialID:String)] = []
    let LibData = Libdatafetch()
    func fetch_lenlst(){
        LibData.fetch_lenlst(createList:{useStateList,lenidlist in
            if useStateList.count != 0 && lenidlist.count != 0 && useStateList.count % 8 == 0 && useStateList.count % lenidlist.count == 0{
                for i in stride(from:0,to:useStateList.count,by:8){
                self.lendlist.append((useStateList[0+i],useStateList[1+i],useStateList[2+i],useStateList[3+i],useStateList[4+i],useStateList[5+i],useStateList[6+i],useStateList[7+i],lenidlist[i/8]))
                }
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            print(self.lendlist)
    })
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetch_lenlst()

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
        return lendlist.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "lendCell", for: indexPath)
        
        if !self.lendlist.isEmpty{
            let webdata = self.lendlist[indexPath.row]
            cell.textLabel?.text = webdata.Biblioinfo
            cell.detailTextLabel?.text = "\(webdata.Lendingdate)->\(webdata.LendDD)"
        }

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
        if segue.identifier == "DetailBooksSegue"{
            /*ここdetailが決まらないと遷移できない。
            if let indexPath = self.tableView.indexPathForSelectedRow{
                let webData = lendlist[indexPath.row]
                let newlist = (BibliographyID:webData.brank,brank:webData.MaterialID,CatalogueType:webData.brank,Biblioinfo:webData.Biblioinfo,brank2:webData.brank,Author:webData.brank)
                (segue.destination as! DetailResultView).data = newlist
            }
 */
        }
    }
 
}
