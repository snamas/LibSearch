//
//  Libdatafetch.swift
//  LibSearchSys
//
//  Created by yuto on 2019/02/05.
//

import Foundation
class Libdatafetch{
    var libserchURL = "https://www.opac.lib.tmu.ac.jp/webopac/"
    var formdata = ["fromDsp": "catsrd",
    "searchDsp": "catsrd",
    "initFlg": "_RESULT_SET",
    "gcattp_flag": "all",
    "holar_flag": "all",
    "words": "sake",
    "title": "",
    "auth": "",
    "pub": "",
    "year": "",
    "year2": "",
    "sh": "",
    "cls": "",
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
        "display": "catsrd",
        "x": "44",
        "userid": "u8144838",
        "password": "kmnm_1984",
        "y": "9"
    ]
    var header = {
        
    }
    let urlSessionGetClient = URLSessionGetClient()
    func fetchong(){
        urlSessionGetClient.post(url: libserchURL+"askidf.do",parameters: loginDB,header: ["referer":"https://www.opac.lib.tmu.ac.jp/webopac/asklst.do"])
    }
}
