//
//  FetchfromURL.swift
//  LibSearchSys
//
//  Created by yuto on 2019/02/05.
//

import Foundation
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
                print(String(data: data, encoding: String.Encoding.utf8) ?? "")
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
    func post(url urlString: String, parameters: [String: Any]) {
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
        request.setValue("Referer", forHTTPHeaderField: "https://www.opac.lib.tmu.ac.jp/webopac/asklst.do")
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
                //print(self.testfi!)
                var pattern = "/webopac/lenlst.do\\?system=(\\d+)"
                var id = self.testfi!.capture(pattern: pattern, group: 1)//ここ確率要素
                print(id)
                var parameters = [URLQueryItem(name:"system",value:"1")]
                if let systemid = id{
                    parameters = [URLQueryItem(name:"system",value: systemid)]
                }
                self.get(url: "https://www.opac.lib.tmu.ac.jp/webopac/lenlst.do",queryItems: parameters)
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
}
