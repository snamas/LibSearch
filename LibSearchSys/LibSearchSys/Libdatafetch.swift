//
//  Libdatafetch.swift
//  LibSearchSys
//
//  Created by yuto on 2019/02/05.
//
import Kanna
import Foundation
class Libdatafetch{
    var libserchURL = "https://www.opac.lib.tmu.ac.jp/webopac/"
    let urlSessionGetClient = URLSessionGetClient()
    static var ctlsrhformDB = [
    "fromDsp": "catsrd",
    "searchDsp": "catsrd",
    "initFlg": "_RESULT_SET_NOTBIB",//_RESULT_SET_NOTBIB　に設定すると2項目目以降も取得できる。
    "gcattp_flag": "all",//ｂｋ＝図書、ｓｒ＝雑誌、av＝視聴覚、eb＝電子ブック、ej＝電子ジャーナル
    "holar_flag": "all",//１０＝本館、２０＝日野館、３０＝荒川館、１１＝人文社会、１２＝法学、１３＝経済経営、１４＝地理環境、１５＝数理科学、１６＝丸の内SC、１＝南大沢
    "words": "論文の",//検索ワード,9784478105344
    "title": "",//タイトル
    "auth": "",//著者名
    "pub": "",//出版社
    "year": "",//出版年月日この年から
    "year2": "",//この年まで
    "sh": "",
    "cls": "",//分類
    "isbn_issn": "",
    "code_type": "",
    "code": "",
    "cntry": "",
    "lang": "",
    "bibid": "",
    "rgtn": "",
    "lenid": "",//MaterialID
    "cln": "",
    "holph": "",
    "hollc": "",
    "fvol": "",
    "fannul": "",
    "x": "36",
    "y": "6",
    "sortkey": "syear,sauth",//stitle,sauthでタイトル名順、sauth,stitleで著者名順、syear,sauthで出版年月日順、scircle,sauthで利用度順
    "sorttype": "DESC",//ASCで昇順、DESCで降順、デフォルトではDESC
    "listcnt": "50",//ここに最大何件取得するか入れる
    "maxcnt": "5000",
    "startpos": "1"//ここに先頭に来るNo.の値を入れる。二項目目なら５１、3項目目なら１０１など
    ]
    static var op_param = {([String:String]) -> String in
        let urlSessionGetClient = URLSessionGetClient()
        return String(urlSessionGetClient.buildUrl(base: "", namedValues: Libdatafetch.ctlsrhformDB).dropFirst())
    }
    static var searchdataDB : [String:String] = [
        "tab_num":"0",
        "action":"v3search_action_main_opac",
        "search_mode":"null",
        "op_param":op_param(Libdatafetch.ctlsrhformDB),
        "block_id":"296",
        "page_id": "15",
        "module_id": "61"
    ]
    static var detaildataDB : [String:String] = [
        "tab_num":"0",
        "action":"v3search_view_main_catdbl",
        "bibid": "BB02152052",
        "block_id":"296",
        "page_id": "15",
        "module_id": "61"
    ]
    static var bookmarkDB : [String:String] = [
        "target": "opac",
        "action":"v3search_view_main_popup",
        "url": "https://tmuopac.lib.tmu.ac.jp/webopac/fbmexe.do?mode=reg&loginType=&locale=ja&bookmark=BB02152052",
        "block_id":"296",
        "prefix_id_name": "usepopup",
        "page_id": "15",
        "module_id": "61"
    ]
    static var asklstDB : [String:String] = ["listpos": "2","sortkey": "lmtdt/ASC"]
    static var yoyakuDB : [String:String] = [
        "bibid": "",
        "cattp": "BB",
        "holid": "HL03351626",
        "block_id":"296",
        "prefix_id_name": "usepopup",
        "page_id": "15",
        "module_id": "61"
        //不完全
    ]
    /*
    ━━━━━━━━━━━━━━━━━━━━━━━━…‥・
    catsrd.do ━━━> 検索入力画面
    ctlsrh.do ━━━> 検索結果
    catdbl.do ━━━> 個別の本の欄
    asklst.do ━━━> ログイン画面
    newsrh.do ━━━> 新着画面
    lenlst.do ━━━> 貸し出し一覧
    fbmref.do ━━━>ブックマーク一覧
    hislst.do ━━━> 貸し出し履歴一覧
    lendtl.do ━━━> 貸出詳細(post)
    fbmexe.do ━━━> マイフォルダに登録（mode=regbibを指定）
    fbmdel.do ━━━> マイフォルダから削除(POST)
    ━━━━━━━━━━━━━━━━━━━━━━━━…‥・
    comidf.do ━━━> ログイン認証
    BibliographyID <- BB02166022とか
    MaterialID <- 10003899330とか
    orderRSV <- HL03351626とか
    Biblioinfo <- 本のタイトルと著者名が合わさったやつ
    */
    
    var loginDB = [
        "userid": "u8144838",
        "display": "topmnu",
        "password": "kmnm_1984",
    ]
    var header = {
        
    }
    static var lenlstid:String? = nil
    static var myfolderid:String? = nil
    
    func fetch_comidf(){
        urlSessionGetClient.post(url: "https://tmuopac.lib.tmu.ac.jp/webopac/comidf.do",parameters: self.loginDB,completion: {data in
            var useStateList:[String] = []
            let testfi = String(data: data, encoding: String.Encoding.utf8) ?? ""
            print(testfi)
            //self.fetch_asklst()
            
        })
        
    }
    func fetch_asklst(){
        urlSessionGetClient.get(url: "https://tmuopac.lib.tmu.ac.jp/webopac/asklst.do",completion: {data in
            var useStateList:[String] = []
            let testfi = String(data: data, encoding: String.Encoding.utf8) ?? ""
             let testscr = try? HTML(html: testfi, encoding: .utf8)
             for link in testscr!.css(".opac_description_area"){
                useStateList += [link.text!.trimmingCharacters(in: .whitespacesAndNewlines)]
             }
             print(useStateList)
        })
        
    }
    //ここ利用状況一覧の各項目に適用
    func fetch_anylist(useURL_do:String,useCSS:String,createList: @escaping ([String],[String]) -> Void,exDelegate: @escaping ([Int]) -> Void = {checkbox_list in print(checkbox_list)}){
        urlSessionGetClient.get(url: "https://tmuopac.lib.tmu.ac.jp/webopac/\(useURL_do)",completion: {data in
            var useStateList:[String] = []
            var anyidlist:[String] = []
            let testfi = String(data: data, encoding: String.Encoding.utf8) ?? ""
            let testscr = try? HTML(html: testfi, encoding: .utf8)
            var no = 0
            var checkbox_list:[Int] = []
            for link in testscr!.css(".opac_data_list_ex td"){
                useStateList += [link.text!.trimmingCharacters(in: .whitespacesAndNewlines)]
                if link.toHTML?.contains("mark") ?? false{
                    if link.toHTML?.contains("checkbox") ?? false{
                        checkbox_list += [no]
                    }
                    no += 1
                }
            }
            for link in testscr!.css("[name='\(useCSS)']"){
                anyidlist += [link["value"]!.trimmingCharacters(in: .whitespacesAndNewlines)]
            }
            createList(useStateList,anyidlist)
            exDelegate(checkbox_list)
        })
    }
    var use_ID_when_checkbox_isdisappear:([Int:String],Int) -> String = {
        SurviceIDList,selectnum in
        if SurviceIDList.isEmpty {return ""}
        let filterd = SurviceIDList.filter {$0.key >= selectnum}
        return filterd.first?.value ?? ""
    }
    //通常検索
    func fetch_indexofsearch(createList: @escaping ([String],[String],[String],[String]) -> Void){
        Libdatafetch.searchdataDB["op_param"] = Libdatafetch.op_param(Libdatafetch.ctlsrhformDB)
        urlSessionGetClient.post(url: "https://libportal.lib.tmu.ac.jp/index.php", parameters: Libdatafetch.searchdataDB,header : ["Referer":"https://libportal.lib.tmu.ac.jp/index.php"],completion: {data in
            var book_title_List:[String] = []
            var book_Auther_List:[String] = []
            var BibliographyID_List:[String] = []
            var Biblio_image_List:[String] = []
            let testfi = String(data: data, encoding: String.Encoding.utf8) ?? ""
            let testscr = try? HTML(html: testfi, encoding: .utf8)
            if testfi.contains("書誌詳細") || testfi.contains("Bibliography Details"){
                let detailstruct = self.Detailparser(testscr)
                createList([detailstruct.book_title ?? ""],[detailstruct.Auther ?? ""],[detailstruct.BibliographyID ?? ""],[detailstruct.opacIcon ?? ""])
            }
            else{
                for link in testscr!.css(".opac_book_title"){
                    book_title_List += [link.text!.trimmingCharacters(in: .whitespacesAndNewlines)]
                }
                for link in testscr!.css(".opac_book_bibliograph"){
                    book_Auther_List += [link.text!.trimmingCharacters(in: .whitespacesAndNewlines)]
                }
                for link in testscr!.css(".opac_list [name='bibid']"){
                    BibliographyID_List += [link["value"]!.trimmingCharacters(in: .whitespacesAndNewlines)]
                }
                for link in testscr!.css(".opac_icon_bookind"){
                    Biblio_image_List += [link["src"]?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""]
                }
            }
            createList(book_title_List,book_Auther_List,BibliographyID_List,Biblio_image_List)
        })
    }
    
    struct Detailstruct {
        var no_List:[String] = []
        var kango_List:[String] = []
        var haichiba_List:[String] = []
        var MaterialID_List:[String] = []
        var seikyu_list:[String] = []
        var jyoutai_list:[String] = []
        var fulldate_list:[String] = []
        var kensu_list:[String] = []
        var orderRSV:[String] = []
        var yoyaku_list:[(startindex:Int,rangeindex:Int,orderRSV:String)] = []
        var isbn:Int?
        var BibliographyID:String?
        var book_title:String?
        var Auther:String?
        var opacIcon:String?
    }
    func fetch_main_catdbl(createList: @escaping (Detailstruct) -> Void){
        urlSessionGetClient.get(url: "https://libportal.lib.tmu.ac.jp/index.php", queryItems: Libdatafetch.detaildataDB,completion: {data in
            let testfi = String(data: data, encoding: String.Encoding.utf8) ?? ""
            let testscr = try? HTML(html: testfi, encoding: .utf8)
            createList(self.Detailparser(testscr))
        })
    }
    //利用状況から入った場合の詳細画面
    func fetch_usestate_detail(listpos:String? = nil,sortkey:String? = nil,useURL:String? = nil,createList: @escaping (String?,String?) -> Void){
        if let safe_listpos = listpos,let safe_sortkey = sortkey,let safe_URL = useURL{
            urlSessionGetClient.post(url: safe_URL, parameters:[
                "listpos": safe_listpos,
                "sortkey": safe_sortkey,
                "startpos": "0",//そのページが何件目からか入るか
                "hitcnt": "0",//ここに件数が入る。ex)借りたものが9冊あったら９になる
                "listcnt": "0"//読み込み最大件数
                ],completion: {data in
                    var BibliographyID:String? = nil
                    var Biblioinfo:String? = nil
                    let testfi = String(data: data, encoding: String.Encoding.utf8) ?? ""
                    let testscr = try? HTML(html: testfi, encoding: .utf8)
                    if let bibDtl = testscr!.css("[href^='JavaScript:bibDtl']").first{
                        Biblioinfo = bibDtl.text
                        BibliographyID = bibDtl["href"]?.capture(pattern: "(BB\\d+)", group: 1)
                    }
                    print(Biblioinfo)
                    print(BibliographyID)
                    createList(BibliographyID,Biblioinfo)
            })
        }
    }
    var Detailparser = {(testscr:HTMLDocument?) -> Detailstruct in
        var detailnum =  Detailstruct()
        var opac_reserv_list:[Int:Int] = [:]
        var no_num :Int = 0
        let haichiba_JS = "\n<!--\n.haichiba{\nwidth:200px !important;\n}\n-->"
        let kango_JS = "<!--\n.haichiba{\nwidth:50px !important;\n}\n-->"
        for link in testscr!.css(".no"){
            if !(link.toXML?.contains("/th") ?? false){
                detailnum.no_List += [link.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""]
                detailnum.orderRSV += [link.css("a").first?["onclick"]?.capture(pattern: "(HL\\d{8,})", group: 1) ?? ""]
            }
        }
        for link in testscr!.css(".kango"){
            if var kangoStr = link.text?.trimmingCharacters(in: .whitespacesAndNewlines){
                if let range = kangoStr.range(of: kango_JS) {
                    kangoStr.removeSubrange(range)
                    detailnum.kango_List += [kangoStr.trimmingCharacters(in: .whitespacesAndNewlines)]
                }
                else if kangoStr.contains("haichiba"){
                    detailnum.kango_List += [""]
                }
            }
        }
        for link in testscr!.css("[style='text-align: left !important;']"){
            if var haichibaStr = link.text?.trimmingCharacters(in: .whitespacesAndNewlines){
                if let range = haichibaStr.range(of: haichiba_JS) {
                    haichibaStr.removeSubrange(range)//ここ正規表現したい
                    detailnum.haichiba_List += [haichibaStr.trimmingCharacters(in: .whitespacesAndNewlines)]
                }
                else if haichibaStr.contains("haichiba"){
                    detailnum.haichiba_List += [""]
                }
            }
        }
        for link in testscr!.css(".siryoid"){
            if !(link.toXML?.contains("/th") ?? false){
                detailnum.MaterialID_List += [link.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""]
            }
        }
        for link in testscr!.css(".seikyu"){
            if !(link.toXML?.contains("/th") ?? false){
                detailnum.seikyu_list += [link.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""]
            }
        }
        for link in testscr!.css(".jyoutai"){
            if !(link.toXML?.contains("/th") ?? false){
                detailnum.jyoutai_list += [link.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""]
            }
        }
        for link in testscr!.css(".fulldate"){
            if !(link.toXML?.contains("/th") ?? false){
                detailnum.fulldate_list += [link.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""]
            }
        }
        for link in testscr!.css(".kensu"){
            if let opac_reserv_range = link["rowspan"]?.first, let int_range = Int(String(opac_reserv_range)){
                opac_reserv_list.updateValue(int_range, forKey: no_num)
                print(opac_reserv_list)
            }
            else if !(link.toXML?.contains("/th") ?? false){
                detailnum.kensu_list += [link.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""]
                no_num += 1
            }
        }
        if !(opac_reserv_list.isEmpty){
            for list in opac_reserv_list{
                detailnum.yoyaku_list += [(startindex:list.key,rangeindex:list.value,orderRSV:detailnum.orderRSV[list.key - 1])]
            }
        }
        if let isbnstr = testscr!.css("[name=isbn_issn]").first?["value"]?.trimmingCharacters(in: .whitespacesAndNewlines){
            detailnum.isbn = Int(isbnstr)
        }
        detailnum.book_title = testscr!.css(".opac_book_title").first?.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        detailnum.Auther = testscr!.css(".opac_book_bibliograph").first?.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        detailnum.BibliographyID = testscr!.css("#orderRSV_Form_296catdbl [name=bibid]").first?["value"]
        detailnum.opacIcon = testscr!.css(".opac_icon_bookind").first?["src"]
        print("no_List:\(detailnum.no_List)")
        print("kango_List:\(detailnum.kango_List)")
        print("haichiba_List:\(detailnum.haichiba_List)")
        print("MaterialID_List:\(detailnum.MaterialID_List)")
        print("seikyu_list:\(detailnum.seikyu_list)")
        print("jyoutai_list:\(detailnum.jyoutai_list)")
        print("fulldate_list:\(detailnum.fulldate_list)")
        print("kensu_list:\(detailnum.kensu_list)")
        print("orderRSV:\(detailnum.orderRSV)")
        print("opac_reserv_list:\(opac_reserv_list)")
        print("yoyaku_list:\(detailnum.yoyaku_list)")
        print("isbn:\(detailnum.isbn)")
        print("BibliographyID:\(detailnum.BibliographyID)")
        print(detailnum.no_List.count)
        print(detailnum.kango_List.count)
        print(detailnum.haichiba_List.count)
        print(detailnum.MaterialID_List.count)
        print(detailnum.seikyu_list.count)
        print(detailnum.jyoutai_list.count)
        print(detailnum.fulldate_list.count)
        print(detailnum.kensu_list.count)
        return detailnum
    }
}
