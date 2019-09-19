//
//  MainLibViewController.swift
//  LibSearchSys
//
//  Created by yuto on 2019/02/10.
//

import UIKit
import KeychainAccess


class MainLibViewController: UIViewController,UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource {
    
    
    let libfunction:[(text:String,bookCount:Int)] = [
        ("貸出中",0),
        ("貸出履歴",0),
        ("予約",0),
        ("購入履歴",0),
        ("ブックマーク",0),
        ("設定",0)
    ]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return libfunction.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        // セルに表示する値を設定する
        cell.textLabel!.text = libfunction[indexPath.row].text
        cell.textLabel!.font = UIFont.systemFont(ofSize: 25.0)
        let viewWidth = self.view.frame.width
        let detailtextLabel = UILabel(frame: CGRect(x: viewWidth-150,y: 60,width: 44,height: 14.5))
        detailtextLabel.text = "tes"
        detailtextLabel.font = UIFont.systemFont(ofSize: 15)
        cell.addSubview(detailtextLabel)
        let imagerect = CGRect(x:viewWidth-171.0,y:0,width:171,height:80)
        let imageView = UIImageView(frame: imagerect)
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: libfunction[indexPath.row].text)
        cell.contentView.addSubview(imageView)
        return cell
    }
    
    
    
    @IBOutlet weak var LibSearchBar: UISearchBar!
    var LibData = Libdatafetch()
    let savedData = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        LibSearchBar.text = ""
        LibSearchBar.delegate = self//(https://daisa-n.com/blog/uisearchbar-search-sample/)ここ参照
        LibSearchBar.showsCancelButton = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if savedData.bool(forKey: "isUseUserId"){
            LibData.fetch_comidf(exceptionClosure:{exceptStr in
                print("exceptStr:\(exceptStr)")
                let accountView = self.storyboard?.instantiateViewController(withIdentifier: "AccountView") as? AccountViewController
                accountView?.modalTransitionStyle = .coverVertical
                self.present(accountView!, animated: true, completion: nil)
            },successClosure: {
                //何件予約件数などがあるかを取得し、反映させる。
                self.LibData.fetch_asklst(complete: {dataarr in
                    let intarr = dataarr.map{
                        ($0.components(separatedBy: NSCharacterSet.decimalDigits.inverted)).joined()
                    }
                    print(intarr)
                    })
            })
        }
        else{
            print("アラートは出現せず(isUseUserIdはfalse)")
        }
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
class searchbarSegue: UIStoryboardSegue{
    override func perform(){
        UIView.transition(
            with: (source.navigationController?.view)!,
            duration: 0.5,
            options: .transitionCrossDissolve,
            animations: {
                () -> Void in
                self.source.navigationController?.pushViewController(self.destination, animated: false)
        },
            completion: nil)
    }
}
