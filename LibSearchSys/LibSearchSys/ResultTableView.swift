//
//  ResultTableView.swift
//  LibSearchSys
//
//  Created by yuto on 2019/02/09.
//

import UIKit
import Kanna

class ResultTableView: UITableViewController,UISearchBarDelegate {
    //これでrefineviewで選択した項目が変化されているか検知する。変化されていたら更新する。
    var firstSelectedTag:[Int] = []
    
    @IBOutlet weak var resultserchbar: UISearchBar!
    @IBOutlet var tableview: UITableView!
    var refineView : RefineViewController? = nil
    private var loadstatus:String = "Ready"
    private var imagestatus : Bool = false//self.image_list[indexPath.row]でのindexoutofrangeのため画像を全部取得してからリロードさせる。
    private var page : Int = 1
    private var mysection = [""]
    let urlSessionGetClient = URLSessionGetClient()
    var LibData = Libdatafetch()
    var SearchResultList : [(BibliographyID:String,opacIcon:String,book_title:String,Author:String)] = []
    var image_list : [(UIImage)] = []
    func fetch_ctlsrh(exclosure:@escaping () -> Void = {}) -> () {
        LibData.ctlsrhformDB["startpos"] = "\(page)"
        print(LibData.ctlsrhformDB["words"])
        imagestatus = false
        loadstatus = "Loading"
        LibData.fetch_indexofsearch(createList: {book_title_List,book_Auther_List,BibliographyID_List,opacIcon_List in
            if book_title_List.count != 0 && book_Auther_List.count != 0 && BibliographyID_List.count != 0 && opacIcon_List.count != 0{
                for i in 0..<book_title_List.count {
                    self.SearchResultList.append((BibliographyID_List[i],opacIcon_List[i],book_title_List[i],book_Auther_List[i]))
                }
            }
            self.page += 50
            self.loadstatus = book_title_List.isEmpty ? "full":"Ready"//クライアントエラーが発生した場合、二度とその先が読み込めなくなる。
            for imagepart in opacIcon_List {
                self.urlSessionGetClient.get(url: imagepart, completion: { data in
                    self.image_list.append(UIImage(data: data) ?? UIImage(named: "book")!)
                    if self.image_list.count == self.SearchResultList.count{
                        self.imagestatus = true
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                })
            }
            exclosure()
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        //ここrefineviewのselectedlistを初期化するための行動
        self.fetch_ctlsrh(exclosure: {self.LibData.fetch_refineview()
            Libdatafetch.selectedlist = []})
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        tableview.delegate = self
        resultserchbar.delegate = self
        resultserchbar.showsCancelButton = false
        resultserchbar.text = Libdatafetch.staticformDB["words"]
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
        //ここいる？
        if !self.SearchResultList.isEmpty{
            let webdata = self.SearchResultList[indexPath.row]
            cell.textLabel?.text = webdata.book_title
            cell.detailTextLabel?.text = "\(webdata.Author)"
            if let imagedata = self.image_list[safe:indexPath.row]{
                cell.imageView?.image = imagedata
            }
            else{
                cell.imageView?.image = UIImage(named: "book")
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
        firstSelectedTag = Libdatafetch.selectedlist
    }
    func updateTableView() {
        //選んだものだけ抽出するよ。[[(資料種１),(資料種２)],[(所蔵館１)],[(著者)],[],[],[]]こんな感じ
        var a = Libdatafetch.RefineList.compactMap{
            $0.filter{i in
                Libdatafetch.selectedlist.contains(i.setTagnum)
            }
        }
        if !a.isEmpty{LibData = Libdatafetch()}
        //URLのパラメーターに追加。ここ著者や出版社にはあてはまらない。要検討
        _ = a.map{ refineList in
            if let paramkey = refineList.first?.kind{
                var paramvalue:[String] = []
                for i in refineList{
                    paramvalue += [i.paramkey]
                }
                LibData.ctlsrhformDB.updateValue((paramvalue), forKey: paramkey)
                print(LibData.ctlsrhformDB)
            }
        }
        if (self.firstSelectedTag != Libdatafetch.selectedlist){
            self.page = 1
            SearchResultList = []
            self.tableView.reloadData()
            self.fetch_ctlsrh()
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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
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
 
    //━━━━━━━[ここから検索画面の実装]━━━━━━━━━━━━━━━━…‥・
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        LibData = Libdatafetch()
        Libdatafetch.staticformDB["words"] = searchBar.text ?? ""
        resultserchbar.endEditing(true)
        resultserchbar.showsCancelButton = false
        self.page = 1
        SearchResultList = []
        self.tableView.reloadData()
        self.fetch_ctlsrh(exclosure: {self.LibData.fetch_refineview()
            //ここで選択した図書、図書館名だけ残す方針で行きたい。
            Libdatafetch.selectedlist = []
        })
        self.image_list = []
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
//https://qiita.com/shtnkgm/items/f02553cb6bb16a59d8fe<-ここ参照,indexoutofrangeを防ぐために使う a[safe: 0]->optional()
extension Array {
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
