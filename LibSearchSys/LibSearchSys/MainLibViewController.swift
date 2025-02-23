//
//  MainLibViewController.swift
//  LibSearchSys
//
//  Created by yuto on 2019/02/10.
//

import UIKit
import KeychainAccess
struct  Libstruct{
    let text:String
    var bookCount:Int
    let direction:String
    func movetodirect(view:UIViewController){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier:direction)
        view.navigationController?.pushViewController(vc, animated: true)
    }
}

class MainLibViewController: UIViewController,UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource {
    
    
    let libfunctions:[Libstruct] = [
        Libstruct(text:"貸出中",bookCount:0,direction:"LenlistView"),
        Libstruct(text:"貸出履歴",bookCount:0,direction:"borrowView"),
        Libstruct(text:"予約",bookCount:0,direction:"ReservationView"),
        Libstruct(text:"購入履歴",bookCount:0,direction:"PurchaseView"),
        Libstruct(text:"ブックマーク",bookCount:0,direction:"BookmarkView"),
        Libstruct(text:"設定",bookCount:0,direction:"settingView")
    ]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return libfunctions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        // セルに表示する値を設定する
        cell.textLabel!.text = libfunctions[indexPath.row].text
        cell.textLabel!.font = UIFont.systemFont(ofSize: 25.0)
        let viewWidth = self.view.frame.width
        let detailtextLabel = UILabel(frame: CGRect(x: viewWidth-150,y: 60,width: 44,height: 14.5))
        detailtextLabel.text = ""//ここ何件か入れる予定
        detailtextLabel.font = UIFont.systemFont(ofSize: 15)
        cell.addSubview(detailtextLabel)
        let imagerect = CGRect(x:viewWidth-171.0,y:0,width:171,height:80)
        let imageView = UIImageView(frame: imagerect)
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: libfunctions[indexPath.row].text)
        cell.contentView.addSubview(imageView)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        libfunctions[indexPath.row].movetodirect(view: self)
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
