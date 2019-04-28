//
//  MainLibViewController.swift
//  LibSearchSys
//
//  Created by yuto on 2019/02/10.
//

import UIKit
import KeychainAccess

class MainLibViewController: UIViewController,UISearchBarDelegate {
    
    
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
    

    /*
     これ適当な文字を打った
     <div class="opac_block_body_big">
     <p class="opac_description_area">
     <strong>OP-0404-E&nbsp;<br><br></strong>
     Incorrect user ID (registered name) or password.<br>
     </p>
     <br><br><hr width="97%"><br>
     <div align="center">
     <a href="JavaScript:top.history.back()"><img src="/webopac/image/default/en/btn_dg_login-back_off_100-20.png" class="nolinkline" title="Back" alt="Back"></a></div>
     </div>
     <script>
     
     これ何も入れなかった時
     
     <div class="opac_block_body_big">
     <p class="opac_description_area">
     <strong>OP-2010-E&nbsp;<br><br></strong>
     No user ID (or registered name)<br>
     </p>
     <br><br><hr width="97%"><br>
     <div align="center">
     <a href="JavaScript:top.history.back()"><img src="/webopac/image/default/en/btn_dg_login-back_off_100-20.png" class="nolinkline" title="Back" alt="Back"></a></div>
     </div>
     
     <script>u81u
     
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    //以下のコードはアラートを出すために必要だった。
    /*
    func showAlartAndForum(title:String = "首都大学東京図書館の利用者IDを入力してください。"){
        let keychain = Keychain()
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        alert.title = title
        alert.addTextField(configurationHandler: {(UserID) -> Void in
            UserID.placeholder = "利用者ID (u914.........)"
            UserID.textContentType = .username
        })
        alert.addTextField(configurationHandler: {(pass) -> Void in
            pass.placeholder = "パスワード"
            pass.isSecureTextEntry = true
            pass.textContentType = .password
        })
        alert.addAction(
            UIAlertAction(
                title:"OK",
                style: .default,
                handler: {action -> Void in
                    if let UserID = alert.textFields?[0],let password = alert.textFields?[1]{
                        print("Login:\(UserID.text ?? "null")")
                        print("Pass:\(password.text ?? "null")")
                        do{
                            try keychain.set(UserID.text ?? "", key: "UserID")
                            try keychain.set(password.text ?? "", key: "Password")
                        }
                        catch let error{
                            print(error)
                        }
                        self.LibData.fetch_comidf(exceptionClosure:{exceptStr in
                            print(exceptStr)
                            self.showAlartAndForum(title: exceptStr)
                        })
                    }
                    self.savedData.set(true, forKey: "isUseUserId")
                    self.savedData.synchronize()
            })
        )
        alert.addAction(
            UIAlertAction(
                title:"キャンセル",
                style: .cancel,
                handler: {action -> Void in
                    print("Cancel")
                    self.savedData.set(false, forKey: "isUseUserId")
                    self.savedData.synchronize()
            })
        )
        self.present(
            alert,
            animated: true,
            completion: {
                print("アラートが実行された")
                
        })

    }
 */
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if savedData.bool(forKey: "isUseUserId"){
            LibData.fetch_comidf(exceptionClosure:{exceptStr in
                print(exceptStr)
                let accountView = self.storyboard?.instantiateViewController(withIdentifier: "AccountView") as? AccountViewController
                accountView?.modalTransitionStyle = .coverVertical
                self.present(accountView!, animated: true, completion: nil)
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
