//
//  AccountTableViewController.swift
//  LibSearchSys
//
//  Created by yuto on 2019/04/16.
//

import UIKit
import KeychainAccess

class AccountViewController: UIViewController {
    var LibData = Libdatafetch()
    let keychain = Keychain()
    let savedData = UserDefaults.standard
    var UserIdText:String?
    var userIdTextField = UITextField()
    var passwordTextFiled = UITextField()
    //http://appleharikyu.jp/iphone/?p=1347・ここヒントになりそう
    @IBAction func retrunAct(_ sender: Any) {
        self.savedData.set(false, forKey: "isUseUserId")
        self.savedData.synchronize()
        self.dismiss(animated: true, completion: nil)
        
    }
    @IBAction func Actis(_ sender: Any) {
        
        print("Login:\(userIdTextField.text ?? "null")")
        print("Pass:\(passwordTextFiled.text ?? "null")")
        do{
            try keychain.set(userIdTextField.text ?? "", key: "UserID")
            try keychain.set(passwordTextFiled.text ?? "", key: "Password")
        }
        catch let error{
            print(error)
        }
        self.LibData.fetch_comidf(exceptionClosure:{exceptStr in
            let culledStr = exceptStr.replacingOccurrences(of: "\t", with: "")
            print(culledStr)
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
            alert.title = culledStr
            alert.addAction(
                UIAlertAction(
                    title:"OK",
                    style: .default,
                    handler: nil))
            self.present(
                alert,
                animated: true,
                completion: {
                    print("アラートが実行された")
                    
            })
        },successClosure: {
            self.dismiss(animated: true, completion: nil)
        })
        self.savedData.set(true, forKey: "isUseUserId")
        self.savedData.synchronize()
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        var mainTextLabel = UITextView()
        mainTextLabel.text = "利用者ID(教育研究用情報システムと同じID)とパスワードを入力してください。この情報は端末内部にのみ保存されます。"
        mainTextLabel.frame = CGRect(x: 10, y: 80, width: 400, height: 60)
        self.view.addSubview(mainTextLabel)
        var userTextLabel = UILabel()
        userTextLabel.text = "利用者ID:"
        userTextLabel.frame = CGRect(x: 10, y: 130, width: 300, height: 30)
        self.view.addSubview(userTextLabel)
        userIdTextField.placeholder = "利用者ID"
        userIdTextField.textContentType = .username
        userIdTextField.frame = CGRect(x: 20, y: 150, width: 300, height: 30)
        
        var passTextLabel = UILabel()
        passTextLabel.text = "利用者ID:"
        passTextLabel.frame = CGRect(x: 10, y: 190, width: 300, height: 30)
        self.view.addSubview(passTextLabel)
        passwordTextFiled.placeholder = "パスワード"
        passwordTextFiled.textContentType = .password
        passwordTextFiled.isSecureTextEntry = true
        passwordTextFiled.frame = CGRect(x: 20, y: 210, width: 300, height: 30)
        self.view.addSubview(userIdTextField)
        self.view.addSubview(passwordTextFiled)
    }
}
