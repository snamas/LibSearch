//
//  ReservationTableViewController.swift
//  LibSearchSys
//
//  Created by yuto on 2019/03/12.
//

import UIKit

class ReservationTableViewController: UITableViewController {
    var svclist:[(number:String,crick:String,Status:String,AppliedLib:String,OrderGroupNo:String,ReservationseqNo:String,RecvDate_Due:String,Biblioinfo:String)] = []
    var SurviceIDList : [Int:String] = [:]
    var partIDList: [String] = []
    let LibData = Libdatafetch()
    func fetch_svclst(){
        LibData.fetch_anylist(useURL_do:"rsvlst.do",useCSS: "svcidlist",createList:{useStateList,svcidlist in
            if useStateList.count != 0 && useStateList.count % 8 == 0{
                for i in stride(from:0,to:useStateList.count,by:8){
                    self.svclist.append((useStateList[0+i],useStateList[1+i],useStateList[2+i],useStateList[3+i],useStateList[4+i],useStateList[5+i],useStateList[6+i],useStateList[7+i]))
                }
            }
            self.partIDList = svcidlist
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            print(useStateList,svcidlist)
        },exDelegate:{checkbox_list in
            if !(self.partIDList.isEmpty || checkbox_list.isEmpty) && self.partIDList.count == checkbox_list.count{
                for i in 0..<checkbox_list.count{
                    self.SurviceIDList.updateValue(self.partIDList[i], forKey: checkbox_list[i])
                }
            }
        })
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        fetch_svclst()

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
        return svclist.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "rvcCell", for: indexPath)
        
        if !self.svclist.isEmpty{
            let webdata = self.svclist[indexPath.row]
            cell.textLabel?.text = webdata.Biblioinfo
            cell.detailTextLabel?.text = "\(webdata.Status)->\(webdata.AppliedLib)"
        }
        
        // Configure the cell...rvcCell
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "DetailBooksSegue"{
            if let indexPath = self.tableView.indexPathForSelectedRow{
                let webData = svclist[indexPath.row]
                let newlist = (useID:LibData.use_ID_when_checkbox_isdisappear(SurviceIDList,indexPath.row),Biblioinfo:webData.Biblioinfo,sortkey:"grpnm/DESC",listpos:webData.number,useURL:"https://tmuopac.lib.tmu.ac.jp/webopac/rsvdtl.do")
                (segue.destination as! DetailResultView).data_from_asklst = newlist
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
