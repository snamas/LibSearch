//
//  AccountTableViewController.swift
//  LibSearchSys
//
//  Created by yuto on 2019/04/16.
//

import UIKit
import KeychainAccess

class AccountViewController: UIViewController {
    var UserIdText:String?
    var userIdTextField = UITextField()
    var passwordTextFiled = UITextField()
    //http://appleharikyu.jp/iphone/?p=1347・ここヒントになりそう
    override func viewDidLoad() {
        super.viewDidLoad()
        userIdTextField.placeholder = "`riyousha"
        userIdTextField.textContentType = .username
        userIdTextField.borderStyle = .bezel
        passwordTextFiled.placeholder = "Password"
        passwordTextFiled.textContentType = .password
        passwordTextFiled.isSecureTextEntry = true
        userIdTextField.frame = CGRect(x: 10, y: 50, width: 300, height: 30)

        var buttonheight = 10
        self.view.addSubview(userIdTextField)
    }
}
