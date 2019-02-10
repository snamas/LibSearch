//
//  DetailResultView.swift
//  LibSearchSys
//
//  Created by yuto on 2019/02/09.
//

import UIKit
import Kanna
class DetailResultView: UIViewController {
    
    var data:(BibliographyID:String,brank:String,CatalogueType:String,Biblioinfo:String,brank2:String,Author:String)?
    let urlSessionGetClient = URLSessionGetClient()
    @IBOutlet weak var Biblioname: UILabel!
    @IBOutlet weak var Auther: UILabel!
    
    func fetch_catdbl(fetchurl:String = "https://www.opac.lib.tmu.ac.jp/webopac/catdbl.do"){
        var templist:[String] = []
        var PlacePartResult : [(No:String, Volumes:String,HoldingLibrary:String,HoldingsLocation:String,MaterialID:String,CaallNo:String,InLibonly:String,Status:String,DueDate:String,RsVNNum:String)] = []
        var svcrsvformList :[(No:String,systemvalue:String,orderRSV:String?)] = []
        urlSessionGetClient.post(url: fetchurl,parameters: Libdatafetch.formdataDB,header:nil,completion: {data in
            let testfi = String(data: data, encoding: String.Encoding.utf8) ?? ""
            let testscr = try? HTML(html: testfi, encoding: .utf8)
            var SearchPartResult = Libdatafetch.lendtl_Oneviewparse(testscr)
            var num:Int = 1
            for link in testscr!.css(".flst_frame .lst_value,.flst_frame .btn"){
                if let a:String = link["href"]?.capture(pattern: "system.value='(\\d+)'", group: 1){
                    print(a)
                    if let b:String = link["href"]?.capture(pattern: "\\('(\\w+)'\\)", group: 1){
                        svcrsvformList.append((No: String(num), systemvalue: a, orderRSV: b))
                    }
                    else{
                        svcrsvformList.append((No: String(num), systemvalue: a, orderRSV: nil))
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
                PlacePartResult.append((templist[0+i],templist[1+i],templist[2+i],templist[3+i],templist[4+i],templist[5+i],templist[6+i],templist[7+i],templist[8+i],templist[9+i]))
            }
            print(PlacePartResult)
            print(svcrsvformList)
            DispatchQueue.main.async {
                self.Biblioname.text = SearchPartResult[0].Biblioinfo
                self.Auther.text = SearchPartResult[0].Author
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
        self.Biblioname.text = data?.Biblioinfo
        self.Auther.text = data?.Author
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
