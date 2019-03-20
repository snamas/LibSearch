//
//  FetchfromURL.swift
//  LibSearchSys
//
//  Created by yuto on 2019/02/05.
//

import Foundation
import Kanna
class URLSessionGetClient {
    func buildUrl(base: String, namedValues: [String : Any]) -> String {
        guard var urlComponents = URLComponents(string: base) else { return "" }
        var tempvalue:[URLQueryItem] = []
        namedValues.forEach({namedValues -> Void in
            if let stringvalue = namedValues.value as? String{
                tempvalue.append(URLQueryItem(name: namedValues.key, value: stringvalue))
            }
                //同名のキーをたくさん持たせるための工夫。
            else if let listvalue = namedValues.value as? [String]{
                _ = listvalue.map{
                    tempvalue.append(URLQueryItem(name: namedValues.key, value: $0))
                }
            }
        })
        urlComponents.queryItems = tempvalue
        return urlComponents.string ?? ""
    }
    func buildUrlfromTuple(base: String, namedValues: [(name:String,value:String)]) -> String {
        guard var urlComponents = URLComponents(string: base) else { return "" }
        urlComponents.queryItems = namedValues.map { URLQueryItem(name: $0.name, value: $0.value)}
        return urlComponents.string ?? ""
    }
    func get(url urlString: String, queryItems: [String : String]? = nil,header : Dictionary<String,String>? = nil,completion: @escaping (Data) -> Void) {
        let url = URL(string: self.buildUrl(base: urlString, namedValues: queryItems ?? [:]))
        var request = URLRequest(url: url!)
        if let headerdic = header{
            for dic in headerdic{
                request.addValue(dic.value, forHTTPHeaderField: dic.key)
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
                completion(data)
            } else {
                // レスポンスのステータスコードが200でない場合などはサーバサイドエラー
                print("サーバエラー ステータスコード: \(response.statusCode)\n")
            }
        }
        task.resume()
        
    }
    func post(url urlString: String, parameters: [String: String],header : Dictionary<String,String>? = nil,completion: @escaping (Data) -> Void) {
        let url = URL(string: urlString)
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.httpBody = String(self.buildUrl(base: "", namedValues: parameters).dropFirst()).data(using: String.Encoding.utf8)
        print(String(self.buildUrl(base: "", namedValues: parameters).dropFirst()))
        if let headerdic = header{
            for dic in headerdic{
                request.addValue(dic.value, forHTTPHeaderField: dic.key)
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
                
                completion(data)
                /*
                if let cookies = HTTPCookieStorage.shared.cookies(for: url!) {
                    for cookie in cookies {
                        print(cookie)
                    }
                }
                 */
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
