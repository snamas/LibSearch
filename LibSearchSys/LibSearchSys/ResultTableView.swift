//
//  ResultTableView.swift
//  LibSearchSys
//
//  Created by yuto on 2019/02/09.
//

import UIKit
import Kanna

class ResultTableView: UITableViewController,UISearchBarDelegate {
    
    
    @IBOutlet weak var resultserchbar: UISearchBar!
    @IBOutlet var tableview: UITableView!
    var refineView : RefineViewController? = nil
    private var loadstatus:String = "Ready"
    private var page : Int = 1
    private var mysection = [""]
    let urlSessionGetClient = URLSessionGetClient()
    var SearchResultList : [(BibliographyID:String,brank:String,CatalogueType:String,Biblioinfo:String,brank2:String,Author:String)] = []
    
    func fetch_ctlsrh() -> () {
        Libdatafetch.ctlsrhformDB["startpos"] = "\(page)"
        print(Libdatafetch.ctlsrhformDB["words"])
        loadstatus = "Loading"
        urlSessionGetClient.post(url: "https://www.opac.lib.tmu.ac.jp/webopac/ctlsrh.do", parameters: Libdatafetch.ctlsrhformDB, header: nil, completion: { Data in
            let testfi = String(data: Data, encoding: String.Encoding.utf8) ?? ""
            var templist:[String] = []
            var SearchPartResult : [(BibliographyID:String,brank:String,CatalogueType:String,Biblioinfo:String,brank2:String,Author:String)] = []
            let testscr = try? HTML(html: testfi, encoding: .utf8)
            
            if let link = testscr!.css(".comment").first{
                self.mysection[0] = link.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            }
            if testfi.contains("書誌詳細") || testfi.contains("Bibliography Details"){
                self.loadstatus = "full"
                SearchPartResult = Libdatafetch.lendtl_Oneviewparse(testscr)
                
                self.SearchResultList += SearchPartResult
                print(SearchPartResult)
            }
            else{
                for link in testscr!.css(".lst_value strong,[nowrap] .lst_value,.hdl_sub_l,[name='bookmark']"){
                    if let a = link["value"]{
                        templist += [a]
                    }
                    templist += [link.text!.trimmingCharacters(in: .whitespacesAndNewlines)]
                    //print(link.innerHTML)
                }
                for i in stride(from:0,to:templist.count,by:6){
                SearchPartResult.append((templist[0+i],templist[1+i],templist[2+i],templist[3+i],templist[4+i],templist[5+i]))
                }
                self.SearchResultList += SearchPartResult
                if SearchPartResult.isEmpty{
                    self.loadstatus = "full"
                }
                else{
                    self.loadstatus = "Ready"
                }
                self.page += 50
                print(SearchPartResult)
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        tableview.delegate = self
        resultserchbar.delegate = self
        resultserchbar.showsCancelButton = false
        resultserchbar.text = Libdatafetch.ctlsrhformDB["words"]
        refineView = storyboard?.instantiateViewController(withIdentifier: "RefineView") as! RefineViewController
        self.refineView!.postDismissionAction = { self.updateTableView() }
        self.refineView!.getNavigationBar = {
            let navigationBarHeight = self.navigationController?.navigationBar.frame.size.height ?? 0
            let navigationBary = self.navigationController?.navigationBar.frame.origin.y ?? 0
            let menuPosy = navigationBarHeight + navigationBary
            print(menuPosy)
            return menuPosy
        }
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath)
        if !self.SearchResultList.isEmpty{
            let webdata = self.SearchResultList[indexPath.row]
            cell.textLabel?.text = webdata.Biblioinfo
            cell.detailTextLabel?.text = "\(webdata.Author)"
            if webdata.CatalogueType == "図書"{
                cell.imageView?.image = UIImage(named: "book")
            }
            else{
                cell.imageView?.image = UIImage(named: "cd")
            }
        }
        // Configure the cell...

        return cell
    }
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentOffsetY = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.height
        let distanceToBottom = maximumOffset - currentOffsetY
        //print("currentOffsetY: \(currentOffsetY)")
        //print("maximumOffset: \(maximumOffset)")
        //print("distanceToBottom: \(distanceToBottom)")
        if (distanceToBottom < 500)&&(self.loadstatus == "Ready"){
            self.fetch_ctlsrh()
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return mysection[section]
    }
    @IBAction func refineAction(_ sender: Any) {
        self.present(refineView!, animated: false, completion: nil)
    }
    func updateTableView() {
        print("ter")
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
            if let indexPath = self.tableView.indexPathForSelectedRow{
                let webData = SearchResultList[indexPath.row]
                (segue.destination as! DetailResultView).data = webData
            }
        }
    }
 
    //━━━━━━━[ここから検索画面の実装]━━━━━━━━━━━━━━━━…‥・
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        Libdatafetch.ctlsrhformDB["words"] = searchBar.text
        resultserchbar.endEditing(true)
        resultserchbar.showsCancelButton = false
        self.page = 1
        SearchResultList = []
        self.tableView.reloadData()
        self.fetch_ctlsrh()
        
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        resultserchbar.showsCancelButton = true
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        resultserchbar.showsCancelButton = false
        searchBar.text = ""
        resultserchbar.endEditing(true)
    }
}
