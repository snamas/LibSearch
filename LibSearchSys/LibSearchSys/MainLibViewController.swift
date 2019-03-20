//
//  MainLibViewController.swift
//  LibSearchSys
//
//  Created by yuto on 2019/02/10.
//

import UIKit

class MainLibViewController: UIViewController,UISearchBarDelegate {
    
    
    @IBOutlet weak var LibSearchBar: UISearchBar!
    var LibData = Libdatafetch()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        LibSearchBar.text = ""
        LibSearchBar.delegate = self//(https://daisa-n.com/blog/uisearchbar-search-sample/)ここ参照
        LibSearchBar.showsCancelButton = false
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        LibData.fetch_comidf()
        LibSearchBar.text = Libdatafetch.staticformDB["words"]
        //ここresultTableViewに転用(https://qiita.com/takabosoft/items/50683d32e04f7d30a410)
        var urlComponents = URLComponents(string: "http://hoge.jp/test_api")!
        var urls = URLComponents(string: "")!
        urls.queryItems = [
            URLQueryItem(name: "en", value: "english"),
            URLQueryItem(name: "jp", value: "日本語"),
            URLQueryItem(name: "other", value: "&=+"),
        ]
        urlComponents.queryItems = [
        URLQueryItem(name: "en", value: "english"),
        URLQueryItem(name: "jp", value: "日本語"),
        URLQueryItem(name: "other", value: String(urls.string!.dropFirst())),
        ]

    }
    //━━━━━━━[ここから検索画面の実装]━━━━━━━━━━━━━━━━…‥・
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let a = searchBar.text{
            Libdatafetch.staticformDB["words"] = a
        }
        LibSearchBar.endEditing(true)
        LibSearchBar.showsCancelButton = false
        performSegue(withIdentifier: "searchView", sender: self)
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        LibSearchBar.showsCancelButton = true
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        LibSearchBar.showsCancelButton = false
        searchBar.text = ""
        LibSearchBar.endEditing(true)
    }
}
