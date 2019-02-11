//
//  FetchfromURL.swift
//  LibSearchSys
//
//  Created by yuto on 2019/02/05.
//

import Foundation
import Kanna
class URLSessionGetClient {
    func get(url urlString: String, queryItems: [URLQueryItem]? = nil,completion: @escaping (Data) -> Void) {
        var compnents = URLComponents(string: urlString)
        compnents?.queryItems = queryItems
        print(compnents!)
        let url = URL(string: compnents!.string ?? "")
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
    func post(url urlString: String, parameters: [String: Any],header : Dictionary<String,String>? = nil,completion: @escaping (Data) -> Void) {
        let url = URL(string: urlString)
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        let parametersString: String = parameters.enumerated().reduce("") {
            (input, tuple) -> String in
            switch tuple.element.value {
            case let int as Int: return input + tuple.element.key + "=" + String(int) + (parameters.count - 1 > tuple.offset ? "&" : "")
            case let string as String: return input + tuple.element.key + "=" + string + (parameters.count - 1 > tuple.offset ? "&" : "")
            default: return input
            }
        }
        print(parametersString)
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
                
                completion(data)
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
}
