//
//  PurchaseRequestTableViewController.swift
//  LibSearchSys
//
//  Created by yuto on 2019/03/11.
//

import UIKit

class PurchaseRequestTableViewController: UITableViewController {
    var odrlist:[(number:String,crick:String,Status:String,RequestLib:String,Requestdate:String,Biblioinfo:String,OrderID:String)] = []
    let LibData = Libdatafetch()
    func fetch_ordlst(){
        LibData.fetch_anylist(useURL_do:"odrlst.do",useCSS: "odridlist", createList:{useStateList,odridlist in
            if useStateList.count != 0 && odridlist.count != 0 && useStateList.count % 6 == 0 && useStateList.count/6 == odridlist.count{
                for i in stride(from:0,to:useStateList.count,by:8){
                    self.odrlist.append((useStateList[0+i],useStateList[1+i],useStateList[2+i],useStateList[3+i],useStateList[4+i],useStateList[5+i],odridlist[i/8]))
                }
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            print(self.odrlist)
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetch_ordlst()
        
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
        return odrlist.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        // Configure the cell...
        let cell = tableView.dequeueReusableCell(withIdentifier: "ordCell", for: indexPath)
        
        if !self.odrlist.isEmpty{
            let webdata = self.odrlist[indexPath.row]
            cell.textLabel?.text = webdata.Biblioinfo
            cell.detailTextLabel?.text = "状態:\(webdata.Status) 依頼日:\(webdata.Requestdate)"
        }
        
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "DetailBooksSegue"{
            if let indexPath = self.tableView.indexPathForSelectedRow{
                let webData = odrlist[indexPath.row]
                let newlist = (useID:webData.OrderID,Biblioinfo:webData.Biblioinfo,sortkey:"odrst/DESC",listpos:webData.number,useURL:"https://tmuopac.lib.tmu.ac.jp/webopac/odrdtl.do")
                (segue.destination as! DetailResultView).data_from_asklst = newlist
            }
        }
    }
}
