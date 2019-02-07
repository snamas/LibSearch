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
    var ctlsrhformDB = ["fromDsp": "catsrd",
    "searchDsp": "catsrd",
    "initFlg": "_RESULT_SET",
    "gcattp_flag": "all",//ｂｋ＝図書、ｓｒ＝雑誌、av＝視聴覚、eb＝電子ブック、ej＝電子ジャーナル
    "holar_flag": "all",//１０＝本館、２０＝日野館、３０＝荒川館、１１＝人文社会、１２＝法学、１３＝経済経営、１４＝地理環境、１５＝数理科学、１６＝丸の内SC、１＝南大沢
    "words": "sake",//検索ワード
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
    "sortkey": "syear,sauth",
    "sorttype": "DESC",
    "listcnt": "20",
    "maxcnt": "5000",
    "startpos": "1"
    ]
    var formdataDB = [
        "title": "sake",
        "auth": "",
        "pub": "",
        "year": "",
        "year2": "",
        "gcattp": "",
        "sh": "",
        "cls": "",
        "code_type": "",
        "code": "",
        "isbn_issn": "",
        "cntry": "",
        "lang": "",
        "ncid": "",
        "bibid": "",
        "togid": "",
        "rgtn": "",
        "lenid": "",
        "cln": "",
        "holar": "",
        "holsc": "",
        "hollc": "",
        "holph": "",
        "words": "",
        "fvol": "",
        "fannul": "",
        "akey": "",
        "sdi": "",
        "body": "",
        "cont": "",
        "niitype": "",
        "restype": "",
        "format": "",
        "rights": "",
        "source": "",
        "cover": "",
        "hasbody": "",
        "sortkey": "syear,sauth",
        "sorttype": "DESC",
        "sortkey2": "",
        "sorttype2": "",
        "listcnt": "20",
        "maxcnt": "5000",
        "startpos": "1",
        "hitcnt": "18",
        "pkey": "BB02353011",
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
        "title_work": "sake",
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
    let urlSessionGetClient = URLSessionGetClient()
    func fetch_askidf(){
        urlSessionGetClient.post(url: libserchURL+"askidf.do",parameters: loginDB,header: ["referer":"https://www.opac.lib.tmu.ac.jp/webopac/asklst.do"],completion: {data in
            var testfi = String(data: data, encoding: String.Encoding.utf8) ?? ""
            //print(self.testfi!)
            var pattern = "/webopac/lenlst.do\\?system=(\\d+)"
            Libdatafetch.lenlstid = testfi.capture(pattern: pattern, group: 1)//ここ確率要素
            print(Libdatafetch.lenlstid)
        })
    }
    func fetch_ctlsrh() -> () {
        urlSessionGetClient.post(url: libserchURL+"ctlsrh.do", parameters: ctlsrhformDB, header: nil, completion: { Data in
            var testfi = String(data: Data, encoding: String.Encoding.utf8) ?? ""
            let testscr = try? HTML(html: testfi, encoding: .utf8)
            var templist:[String] = []
            for link in testscr!.css(".lst_value,.hdl_sub_l,strong"){
                if let a = link["value"]{
                print(a)
                }
                print(link.text?.trimmingCharacters(in: .whitespacesAndNewlines))
                //print(link.innerHTML)
            }
        })
    }
}
