//
//  FetchfromURL.swift
//  LibSearchSys
//
//  Created by yuto on 2019/02/05.
//

import Foundation
import Kanna
class URLSessionGetClient {
    func buildUrl(base: String, namedValues: [String : String]) -> String {
        guard var urlComponents = URLComponents(string: base) else { return "" }
        urlComponents.queryItems = namedValues.map { URLQueryItem(name: $0.key, value: $0.value)}
        return urlComponents.string ?? ""
    }
    func get(url urlString: String, queryItems: [String : String]? = nil,completion: @escaping (Data) -> Void) {
        let url = URL(string: self.buildUrl(base: urlString, namedValues: queryItems ?? [:]))
        let request = URLRequest(url: url!)
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
