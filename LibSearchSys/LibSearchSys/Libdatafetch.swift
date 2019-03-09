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
    "lenid": "",
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
    static var formdataDB = [
        "rgtn": "",//資料ID
        "sortkey": "syear,sauth",
        "sorttype": "DESC",
        "sortkey2": "",
        "sorttype2": "",
        "listcnt": "20",
        "maxcnt": "5000",
        "startpos": "1",
        "hitcnt": "18",
        "pkey": "BB02166022",//ここにBibliographyIDを入れる
        "togflg": "",
        "stposHol": "1",
        "hitcntHol": "",
        "pkeyHol": "",
        "dsptypeHol": "",
        "stposTog": "1",
        "hitcntTog": "",
        "pkeyTog": "",
        "stposCld": "1",
        "hitcntCld": "",
        "pkeyCld": "",
        "stposAty": "1",
        "hitcntAty": "",
        "pkeyAty": "",
        "stposBescls":"1",
        "hitcntBescls": "",
        "fromDsp": "catlsl",
        "searchDsp": "catsrd",
        "other":"",
        "initFlg": "_RESULT_SET_NOTBIB",
        "arg1": "",
        "arg2": "",
        "arg3": "",
        "arg4": "",
        "arg5": "",
        "loginType": "",
        "ajaxFlg": "",
        "facetFlg": "",
        "mailcharset": "",
        "detailFlg": "",
        "searchsql": "",
        "searchhis": "",
        "srhkeyOrder": "",
        "srhLogFlg": "false",
        "stposRev": "",
        "pkeyRev": "",
        "pkeyVol": "",
        "pkeyIsbn": "",
        "pkeyRevid": "",
        "sortkeyRev": "",
        "sorttypeRev": "",
        "stposRevlsa": "",
        "sortkeyRevlsa": "",
        "sorttypeRevlsa": "",
        "stposCmt": "",
        "stposCtx": "",
        "sltfunc_work": "defaultSelect",
        "funcflg_work": ["defaultSelect",
                         "addBookmark",
                         "searchnii",
                         "caswinfocus",
                         "searchporta",
                         "addHistory",
                         "addMyfolderbkm",
                         "addMyfolderhst",
                         "download",
                         "sendmail"],
        "gcattp_flag_2work": "all",
        "gcattp_flag_work": "all",
        "holar_flag_work": "all",
        "title_work": "",
        "auth_work": "",
        "words_work": "",
        "pub_work": "",
        "year_work": "",
        "year2_work": "",
        "hollc_work": "",
        "sortkey_work": "syear,sauth",
        "sorttype_work": "DESC",
        "listcnt_work": "20",
        "dlcharset": "UTF-8",
        "mailcharset_work": "UTF-8"
        ] as [String : Any]
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
    func fetch_lenlst(createList: @escaping ([String],[String]) -> Void){
        urlSessionGetClient.get(url: "https://tmuopac.lib.tmu.ac.jp/webopac/lenlst.do",completion: {data in
            var useStateList:[String] = []
            var lenidlist:[String] = []
            let testfi = String(data: data, encoding: String.Encoding.utf8) ?? ""
            let testscr = try? HTML(html: testfi, encoding: .utf8)
            for link in testscr!.css(".opac_data_list_ex td"){
                useStateList += [link.text!.trimmingCharacters(in: .whitespacesAndNewlines)]
            }
            for link in testscr!.css("[name='lenidlist']"){
                lenidlist += [link["value"]!.trimmingCharacters(in: .whitespacesAndNewlines)]
            }
            print(useStateList)
            createList(useStateList,lenidlist)
        })
    }
    func fetch_indexofsearch(createList: @escaping ([String],[String],[String],[String]) -> Void){
        Libdatafetch.searchdataDB["op_param"] = Libdatafetch.op_param(Libdatafetch.ctlsrhformDB)
        urlSessionGetClient.post(url: "https://libportal.lib.tmu.ac.jp/index.php", parameters: Libdatafetch.searchdataDB,header : ["Referer":"https://libportal.lib.tmu.ac.jp/index.php"],completion: {data in
            var book_title_List:[String] = []
            var book_Auther_List:[String] = []
            var Biblio_Id_List:[String] = []
            var Biblio_image_List:[String] = []
            let testfi = String(data: data, encoding: String.Encoding.utf8) ?? ""
            let testscr = try? HTML(html: testfi, encoding: .utf8)
            for link in testscr!.css(".opac_book_title"){
                book_title_List += [link.text!.trimmingCharacters(in: .whitespacesAndNewlines)]
            }
            for link in testscr!.css(".opac_book_bibliograph"){
                book_Auther_List += [link.text!.trimmingCharacters(in: .whitespacesAndNewlines)]
            }
            for link in testscr!.css(".opac_list [name='bibid']"){
                Biblio_Id_List += [link["value"]!.trimmingCharacters(in: .whitespacesAndNewlines)]
            }
            for link in testscr!.css(".opac_icon_bookind"){
                Biblio_image_List += [link["src"]?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""]
            }
            createList(book_title_List,book_Auther_List,Biblio_Id_List,Biblio_image_List)
        })
    }
    func fetch_main_catdbl(){
        urlSessionGetClient.get(url: "https://libportal.lib.tmu.ac.jp/index.php", queryItems: Libdatafetch.detaildataDB,completion: {data in
            var no_List:[String] = []
            var kango_List:[String] = []
            var haichiba_List:[String] = []
            var siryoid_List:[String] = []
            var seikyu_list:[String] = []
            var jyoutai_list:[String] = []
            var fulldate_list:[String] = []
            var kensu_list:[String] = []
            var opacCatdhl_list:[String] = []
            var opac_reserv_list:[(startindex:Int,rangeindex:String)] = []
            var no_num :Int = 0
            var yoyaku_list:[(startindex:String,rangeindex:String,idindex:String)] = []
            let haichiba_JS = "\n<!--\n.haichiba{\nwidth:200px !important;\n}\n-->"
            let kango_JS = "<!--\n.haichiba{\nwidth:50px !important;\n}\n-->"
            let testfi = String(data: data, encoding: String.Encoding.utf8) ?? ""
            let testscr = try? HTML(html: testfi, encoding: .utf8)
            for link in testscr!.css(".no"){
                if !(link.toXML?.contains("/th") ?? false){
                    no_List += [link.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""]
                    opacCatdhl_list += [link.css("a").first?["onclick"]?.capture(pattern: "(HL\\d{8,})", group: 1) ?? ""]
                }
            }
            for link in testscr!.css(".kango"){
                if var kangoStr = link.text?.trimmingCharacters(in: .whitespacesAndNewlines){
                    if let range = kangoStr.range(of: kango_JS) {
                        kangoStr.removeSubrange(range)
                        print(kangoStr)     // 青い花
                        kango_List += [kangoStr.trimmingCharacters(in: .whitespacesAndNewlines)]
                    }
                }
            }
            for link in testscr!.css("[style='text-align: left !important;']"){
                if var haichibaStr = link.text?.trimmingCharacters(in: .whitespacesAndNewlines){
                    if let range = haichibaStr.range(of: haichiba_JS) {
                        haichibaStr.removeSubrange(range)
                        print(haichibaStr)
                        haichiba_List += [haichibaStr.trimmingCharacters(in: .whitespacesAndNewlines)]
                    }
                }
            }
            for link in testscr!.css(".siryoid"){
                if !(link.toXML?.contains("/th") ?? false){
                    siryoid_List += [link.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""]
                }
            }
            for link in testscr!.css(".seikyu"){
                if !(link.toXML?.contains("/th") ?? false){
                    seikyu_list += [link.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""]
                }
            }
            for link in testscr!.css(".jyoutai"){
                if !(link.toXML?.contains("/th") ?? false){
                    jyoutai_list += [link.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""]
                }
            }
            for link in testscr!.css(".fulldate"){
                if !(link.toXML?.contains("/th") ?? false){
                    fulldate_list += [link.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""]
                }
            }
            for link in testscr!.css(".kensu"){
                if let opac_reserv_range = link["rowspan"]?.first{
                    opac_reserv_list.append((no_num,String(opac_reserv_range)))
                }
                else if !(link.toXML?.contains("/th") ?? false){
                    kensu_list += [link.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""]
                    no_num += 1
                }
            }
            print(no_List)
            print(kango_List)
            print(haichiba_List)
            print(siryoid_List)
            print(seikyu_list)
            print(jyoutai_list)
            print(fulldate_list)
            print(kensu_list)
            print(opacCatdhl_list)
            print(opac_reserv_list)
            print(no_List.count)
            print(kango_List.count)
            print(haichiba_List.count)
            print(siryoid_List.count)
            print(seikyu_list.count)
            print(jyoutai_list.count)
            print(fulldate_list.count)
            print(kensu_list.count)
        })
    }
    static var lendtl_Oneviewparse = {(testscr:HTMLDocument?) -> [(BibliographyID:String,brank:String,CatalogueType:String,Biblioinfo:String,brank2:String,Author:String)] in
        var templist:[String] = []
        var SearchPartResult : [(BibliographyID:String,brank:String,CatalogueType:String,Biblioinfo:String,brank2:String,Author:String)] = []
        for link in testscr!.css(".nobr .info,.flst_frame .lst_value,.fdtl_hdl_frame .hdl_main,.fdtl_hdl_frame .hdl_sub"){
            var c = link.text!
            if let a = c.capture(pattern: "<(\\w+)>", group: 1){//ここ確率要素
                templist += [a.trimmingCharacters(in: .whitespacesAndNewlines)]
                if let b = c.range(of:"<\(a)>"){
                    c.removeSubrange(b)
                    templist += [c.trimmingCharacters(in: .whitespacesAndNewlines)]
                }
            }
            else{
                templist += [link.text!.trimmingCharacters(in: .whitespacesAndNewlines)]
            }
        }
        SearchPartResult.append((templist[2],templist[3],templist[0],templist[1],templist[3],templist[3]))

        return SearchPartResult
    }
}
