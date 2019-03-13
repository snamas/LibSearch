//
//  BorrowinghistoryTableViewController.swift
//  LibSearchSys
//
//  Created by yuto on 2019/03/13.
//

import UIKit

class BorrowinghistoryTableViewController: UITableViewController {
    var borhistorylist:[(number:String,crick:String,Lendingdate:String,kango:String,Biblioinfo:String,histID:String)] = []
    let LibData = Libdatafetch()
    var page:Int = 1
    private var loadstatus:String = "Ready"
    func fetch_lenlst(){
        loadstatus = "Loading"
        LibData.fetch_anylist(useQuery:
            ["startpos": String(page),"sortkey": "crtdt/DESC","listcnt": "20"],useURL_do:"hislst.do",useCSS: "sjridlist",createList:{useStateList,sjridlist in
            if useStateList.count != 0 && sjridlist.count != 0 && useStateList.count % 5 == 0 && useStateList.count/5 == sjridlist.count{
                for i in stride(from:0,to:useStateList.count,by:5){
                    self.borhistorylist.append((useStateList[0+i],useStateList[1+i],useStateList[2+i],useStateList[3+i],useStateList[4+i],sjridlist[i/5]))
                }
            }
            self.page += 20
            self.loadstatus = useStateList.isEmpty ? "full":"Ready"
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            print(self.borhistorylist)
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
        return borhistorylist.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BorhisCell", for: indexPath)
        let webdata = self.borhistorylist[indexPath.row]
        cell.textLabel?.text = webdata.Biblioinfo
        cell.detailTextLabel?.text = "\(webdata.kango)->\(webdata.Lendingdate)"
        
        // Configure the cell...

        return cell
    }
 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "DetailBooksSegue"{
            if let indexPath = self.tableView.indexPathForSelectedRow{
                let webData = borhistorylist[indexPath.row]
                let newlist = (useID:webData.histID,Biblioinfo:webData.Biblioinfo,sortkey:"crtdt/DESC",listpos:webData.number,useURL:"https://tmuopac.lib.tmu.ac.jp/webopac/hisdtl.do")
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
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentOffsetY = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.height
        let distanceToBottom = maximumOffset - currentOffsetY
        //print("currentOffsetY: \(currentOffsetY)")
        //print("maximumOffset: \(maximumOffset)")
        //print("distanceToBottom: \(distanceToBottom)")
        if (distanceToBottom < 500)&&(self.loadstatus == "Ready"){
            self.fetch_lenlst()
        }
    }
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
