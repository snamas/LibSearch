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
    static var ctlsrhformDB = ["fromDsp": "catsrd",
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
    */
    
    var loginDB = [
        "userid": "u8144838",
        "display": "catsrd",
        "x": "44",
        "password": "kmnm_1984",
        "y": "9"
    ]
    var header = {
        
    }
    static var lenlstid:String? = nil
    static var myfolderid:String? = nil
    
    let urlSessionGetClient = URLSessionGetClient()
    func fetch_askidf(){
        urlSessionGetClient.post(url: libserchURL+"askidf.do",parameters: loginDB,header: ["referer":"https://www.opac.lib.tmu.ac.jp/webopac/asklst.do"],completion: {data in
            var useStateList:[String] = []
            var testfi = String(data: data, encoding: String.Encoding.utf8) ?? ""
            //print(self.testfi!)
            Libdatafetch.lenlstid = testfi.capture(pattern: "/webopac/lenlst.do\\?system=(\\d+)", group: 1)//ここ確率要素
            Libdatafetch.myfolderid = testfi.capture(pattern: "follstform.system.value='(\\d+)'", group: 1)
            print(Libdatafetch.lenlstid)
            print(Libdatafetch.myfolderid)
            let testscr = try? HTML(html: testfi, encoding: .utf8)
            for link in testscr!.css(".lnk_ask,.notlnk_ask"){
                if let number = link.text?.capture(pattern: "(\\d+)", group: 1){
                    useStateList += [number]
                }
            }
            print(useStateList)
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
