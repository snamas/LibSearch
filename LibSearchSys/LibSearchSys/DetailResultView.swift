//
//  DetailResultView.swift
//  LibSearchSys
//
//  Created by yuto on 2019/02/09.
//

import UIKit
import Kanna
class DetailResultView: UITableViewController {
    private let mysection = ["","配架場所"]
    var data:(BibliographyID:String,brank:String,CatalogueType:String,Biblioinfo:String,brank2:String,Author:String)?
    private var SearchPartResult:[(BibliographyID:String,brank:String,CatalogueType:String,Biblioinfo:String,brank2:String,Author:String)] = []
    let urlSessionGetClient = URLSessionGetClient()
    var DetailResult : [(No:String, Volumes:String,HoldingLibrary:String,HoldingsLocation:String,MaterialID:String,CaallNo:String,InLibonly:String,Status:String,DueDate:String,RsVNNum:String)] = []
    var svcrsvformList :[(No:String,systemvalue:String,orderRSV:String?)] = []
    func fetch_catdbl(fetchurl:String = "https://www.opac.lib.tmu.ac.jp/webopac/catdbl.do"){
        var templist:[String] = []
        urlSessionGetClient.post(url: fetchurl,parameters: Libdatafetch.formdataDB,header:nil,completion: {data in
            let testfi = String(data: data, encoding: String.Encoding.utf8) ?? ""
            let testscr = try? HTML(html: testfi, encoding: .utf8)
            self.SearchPartResult = Libdatafetch.lendtl_Oneviewparse(testscr)
            var num:Int = 1
            for link in testscr!.css(".flst_frame .lst_value,.flst_frame .btn"){
                if let a:String = link["href"]?.capture(pattern: "system.value='(\\d+)'", group: 1){
                    print(a)
                    if let b:String = link["href"]?.capture(pattern: "\\('(\\w+)'\\)", group: 1){
                        self.svcrsvformList.append((No: String(num), systemvalue: a, orderRSV: b))
                    }
                    else{
                        self.svcrsvformList.append((No: String(num), systemvalue: a, orderRSV: nil))
                    }
                    templist.removeLast()
                }
                else if let i = Int(link.text!.trimmingCharacters(in: .whitespacesAndNewlines)),i<10000{
                    num = i
                    templist += [String(i)]
                }
                else{
                    templist += [link.text!.trimmingCharacters(in: .whitespacesAndNewlines)]
                }
                //print(link.text!.trimmingCharacters(in: .whitespacesAndNewlines))
            }
            for i in stride(from:0,to:templist.count,by:10){
                self.DetailResult.append((templist[0+i],templist[1+i],templist[2+i],templist[3+i],templist[4+i],templist[5+i],templist[6+i],templist[7+i],templist[8+i],templist[9+i]))
            }
            print(self.DetailResult)
            print(self.svcrsvformList)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if let bibbrank = data?.BibliographyID,bibbrank.isEmpty{
            print("throw")
            Libdatafetch.formdataDB["rgtn"] = data?.brank
            Libdatafetch.formdataDB["pkey"] = ""
            fetch_catdbl(fetchurl: "https://www.opac.lib.tmu.ac.jp/webopac/ctlsrh.do")
        }
        else{
            Libdatafetch.formdataDB["pkey"] = data?.BibliographyID
            Libdatafetch.formdataDB["rgtn"] = ""
            fetch_catdbl()
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0{
            return 1
        }
        else if  section == 1{
            return DetailResult.count
        }
        else{
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return mysection[section]
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
            return CGFloat(200)
        }
        else{
            return CGFloat(70)
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailCell", for: indexPath)
        if indexPath.section == 0{
            if !self.SearchPartResult.isEmpty{
                let webdata = self.SearchPartResult[indexPath.row]
                cell.textLabel?.text = webdata.Biblioinfo
                cell.detailTextLabel?.text = webdata.Author
            }
            cell.textLabel?.numberOfLines = 5
            cell.detailTextLabel?.numberOfLines = 2
        }
        if indexPath.section == 1{
            if !self.DetailResult.isEmpty{
                let webdata = self.DetailResult[indexPath.row]
                cell.textLabel?.text = webdata.HoldingLibrary
                cell.detailTextLabel?.text = webdata.HoldingsLocation
            }
        }
        // Configure the cell...
        return cell
    }
}
