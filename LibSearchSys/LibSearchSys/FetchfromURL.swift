//
//  FetchfromURL.swift
//  LibSearchSys
//
//  Created by yuto on 2019/02/05.
//

import Foundation
import Kanna
class URLSessionGetClient {
    var testfi:String? = nil
    func get(url urlString: String, queryItems: [URLQueryItem]? = nil) {
        var compnents = URLComponents(string: urlString)
        compnents?.queryItems = queryItems
        print(compnents!)
        let url = URL(string: compnents!.string ?? "")
        var request = URLRequest(url: url!)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("クライアントエラー: \(error.localizedDescription) \n")
                return
            }
            
            guard let data = data, let response = response as? HTTPURLResponse else {
                print("no data or no response")
                return
            }
            
            if response.statusCode == 200 {
                
                //print(String(data: data, encoding: String.Encoding.utf8) ?? "")
                self.lenlstparse(data: data)
                if let cookies = HTTPCookieStorage.shared.cookies(for: url!) {
                    for cookie in cookies {
                        print(cookie)
                    }
                }
            } else {
                // レスポンスのステータスコードが200でない場合などはサーバサイドエラー
                print("サーバエラー ステータスコード: \(response.statusCode)\n")
            }
        }
        task.resume()
        
    }
    func post(url urlString: String, parameters: [String: Any],header : Dictionary<String,String>? = nil) {
        let url = URL(string: urlString)
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        let parametersString: String = parameters.enumerated().reduce("?") {
            (input, tuple) -> String in
            switch tuple.element.value {
            case let int as Int: return input + tuple.element.key + "=" + String(int) + (parameters.count - 1 > tuple.offset ? "&" : "")
            case let string as String: return input + tuple.element.key + "=" + string + (parameters.count - 1 > tuple.offset ? "&" : "")
            default: return input
            }
        }
        request.httpBody = parametersString.data(using: String.Encoding.utf8)
        if let headerdic = header{
            for dic in headerdic{
                request.setValue(dic.key, forHTTPHeaderField: dic.value)
            }
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("クライアントエラー: \(error.localizedDescription) \n")
                return
            }
            
            guard let data = data, let response = response as? HTTPURLResponse else {
                print("no data or no response")
                return
            }
            
            if response.statusCode == 200 {
                //print(String(data: data, encoding: String.Encoding.utf8) ?? "")
                self.testfi = String(data: data, encoding: String.Encoding.utf8) ?? ""
                print(self.testfi!)
                var pattern = "/webopac/lenlst.do\\?system=(\\d+)"
                var id = self.testfi!.capture(pattern: pattern, group: 1)//ここ確率要素
                print(id)
                var parameters = [URLQueryItem(name:"system",value:"1")]
                if let systemid = id{
                    parameters = [URLQueryItem(name:"system",value: systemid)]
                }
                self.get(url: "https://www.opac.lib.tmu.ac.jp/webopac/lenlst.do",queryItems: parameters)
                /*
                if let cookies = HTTPCookieStorage.shared.cookies(for: url!) {
                    for cookie in cookies {
                        print(cookie)
                    }
                }
                */
            } else {
                // レスポンスのステータスコードが200でない場合などはサーバサイドエラー
                print("サーバエラー ステータスコード: \(response.statusCode)\n")
            }
        }
        task.resume()
    }
    func lenlstparse(data:Data) -> [[String]]{
        let html = String(data: data, encoding: String.Encoding.utf8) ?? ""
        let testscr = try? HTML(html: html, encoding: .utf8)
        var templist:[String] = []
        var lenlist:[[String]] = []
        for link in testscr!.css("span.lst_value,[name='lenidlist']"){
            /*span.lst_value
            if let a = link["href"],link["href"]!.contains("lenDtl"){
                print(link.text)
                print(link["href"])
            }
             */
            if let a = link["value"]{
                templist += [a]
            }
            templist += [link.text!.trimmingCharacters(in: .whitespacesAndNewlines)]
        }
        for i in stride(from:0,to:templist.count,by:9){
            lenlist += [[templist[0+i],templist[1+i],templist[2+i],templist[3+i],templist[4+i],templist[5+i],templist[6+i],templist[7+i],templist[8+i]]]
        }
        return lenlist
    }
}
