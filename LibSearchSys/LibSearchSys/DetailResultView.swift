//
//  DetailResultView.swift
//  LibSearchSys
//
//  Created by yuto on 2019/02/09.
//

import UIKit
import Kanna
class DetailResultView: UITableViewController {
    var LibData = Libdatafetch()
    private var mysection = ["","配架場所"]
    var data:(BibliographyID:String,opacIcon:String,book_title:String,Author:String)?
    var data_from_asklst:(useID:String,Biblioinfo:String,sortkey:String,listpos:String,useURL:String)?
    var BookImage:UIImage?
    let urlSessionGetClient = URLSessionGetClient()
    var DetailResult : [(No:String, kango:String,haichiba:String,seikyu:String,MaterialID:String,Status:String,DueDate:String,yoyakukensu:String)] = []
    var yoyaku_list :[(startindex:Int,rangeindex:Int,orderRSV:String)]?
    var page:Int = 1//BB00283652で10以上の所蔵館かがあるとその先が表示されない。
    func fetch_catdbl(){
        Libdatafetch.detailurl["stposHol"] = String(self.page)
        if let safe_bibid = data?.BibliographyID{
            Libdatafetch.detaildataDB["bibid"] = safe_bibid
        }
        LibData.fetch_main_catdbl(createList:{detailnum in
            if detailnum.fulldate_list.count != 0{
                for i in 0..<detailnum.fulldate_list.count{
                self.DetailResult.append((detailnum.no_List[i],detailnum.kango_List[i],detailnum.haichiba_List[i],detailnum.seikyu_list[i],detailnum.MaterialID_List[i],detailnum.jyoutai_list[i],detailnum.fulldate_list[i],detailnum.kango_List[i]))
                }
            }
            self.yoyaku_list = detailnum.yoyaku_list//ここBB00283652で改良が必要
            if let isbn = detailnum.isbn,self.page == 1{
                self.fetch_image(fetchurl: "https://www.hanmoto.com/bd/img/\(isbn).jpg")
            }
            if let safe_bibid = detailnum.BibliographyID,let safe_icon = detailnum.opacIcon,let safe_title = detailnum.book_title,let safe_auther = detailnum.Auther,self.page == 1{
                self.data = (safe_bibid,safe_icon,safe_title,safe_auther)
            }
            self.page += 10
            if detailnum.fulldate_list.count == 10{
                self.fetch_catdbl()
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
    }//SB00057540ここ例外
    func fetch_image(fetchurl:String){
        urlSessionGetClient.get(url: fetchurl, completion: { data in
            self.BookImage = UIImage(data: data)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            })
    }
    
    @IBAction func showActionSheet(_ sender: Any) {
        let detailActionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet
        )
        detailActionSheet.addAction(UIAlertAction(title: "ブックマークする", style: .default, handler: {(action) in
                self.addBookmark()
            }))
        detailActionSheet.addAction(UIAlertAction(title: "キャンセル", style: .cancel, handler: nil
        ))
        self.present(detailActionSheet,animated: true,completion:{ print("Do!")})
    }
    func addBookmark(){
        if let safeBibID = data?.BibliographyID{
            LibData.fetch_bookmark(BibliographyID: safeBibID,tfclosure:{fetchResult in
                if fetchResult{
                    let successAlert = UIAlertController(title:nil,message:nil,preferredStyle:.alert)
                    successAlert.title = "ブックマーク追加成功"
                    successAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(
                        successAlert,
                        animated:true,
                        completion:{print("success")}
                    )
                }
                else{
                    self.LibData.fetch_comidf(exceptionClosure:{exceptionNum in print(exceptionNum)})
                    let successAlert = UIAlertController(title:nil,message:nil,preferredStyle:.alert)
                    successAlert.title = "ブックマーク追加失敗"
                    successAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(
                        successAlert,
                        animated:true,
                        completion:{print("Fail to Bookmark")}
                    )
                }
            })
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if let safe_bibid = data?.BibliographyID{
            Libdatafetch.detaildataDB["bibid"] = safe_bibid
            fetch_catdbl()
        }
        else if let safe_asklst = data_from_asklst{
            //ここに利用状況一覧から入る特殊検索を実行する。
            LibData.fetch_usestate_detail(listpos: data_from_asklst?.listpos,sortkey: data_from_asklst?.sortkey,useURL: data_from_asklst?.useURL,createList: {
                BibliographyID,Biblioinfo in
                if let safe_bibid = BibliographyID{
                    Libdatafetch.detaildataDB["bibid"] = safe_bibid
                    self.fetch_catdbl()
                }
                
            })
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
            cell.textLabel?.text = data?.book_title
            cell.detailTextLabel?.text = data?.Author
            cell.textLabel?.numberOfLines = 5
            cell.detailTextLabel?.numberOfLines = 2
            cell.imageView?.image = self.BookImage
        }
        if indexPath.section == 1{
            if !self.DetailResult.isEmpty{
                let webdata = self.DetailResult[indexPath.row]
                if (webdata.kango.isEmpty){
                    cell.textLabel?.text = webdata.haichiba
                }
                else{
                    cell.textLabel?.text = "巻号:" + webdata.kango + "　|　" + webdata.haichiba
                }
                if (webdata.Status.isEmpty){
                    cell.detailTextLabel?.text = webdata.seikyu
                }
                else{
                    cell.detailTextLabel?.text = "\(webdata.Status)(\(webdata.seikyu))"
                }
            }
            else{
                cell.textLabel?.text = "配架場所はありません"//下位図書が存在する可能性
                cell.detailTextLabel?.text = ""
            }
            cell.imageView?.image = nil
        }
        // Configure the cell...
        return cell
    }
}
/*
 bibbr: ハウスクロフト無機化学 / Catherine E. Housecroft, Alan G. Sharpe著 ; 上, 下. -- 東京化学同人, 2012.
 bibid: BB02152052
 cattp: BB
 holid: HL03351626
 vol1:
 vol2:
 holar:
 fvol:
 annul:
 reqType: _NEW
 loginType: once
 system:
 locale: ja
 ufisso_param: 64d4fdde232a8a077d7ae812c1cb5ff3|17e90616e6298235aa7ed83715af8586|nc2op
 bibbr: ハウスクロフト無機化学 / Catherine E. Housecroft, Alan G. Sharpe著 ; 上, 下. -- 東京化学同人, 2012.
 bibid: BB02152052
 cattp: BB
 holid: HL03351624
 vol1:
 vol2:
 holar:
 fvol:
 annul:
 reqType: _NEW
 loginType: once
 system:
 locale: ja
 ufisso_param: 64d4fdde232a8a077d7ae812c1cb5ff3|17e90616e62982358e3ad4e56444ca6a|nc2op

 lenupd.do post
 startpos: 1
 listpos: 1
 sortkey: lmtdt/ASC
 hitcnt: 9
 listcnt: 10
 lenidlist:
 */
