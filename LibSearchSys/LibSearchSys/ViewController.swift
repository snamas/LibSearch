//
//  ViewController.swift
//  LibSearchSys
//
//  Created by yuto on 2019/02/05.
//

import UIKit

class ViewController: UIViewController {

    @IBAction func Access(_ sender: Any) {
        let cookieStore = HTTPCookieStorage.shared
        for cookie in cookieStore.cookies ?? [] {
            cookieStore.deleteCookie(cookie)
        }

        var LibData = Libdatafetch()
        LibData.fetchong()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        var LibData = Libdatafetch()
        LibData.fetchong()
    }


}

