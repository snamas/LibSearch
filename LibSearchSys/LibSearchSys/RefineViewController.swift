//
//  RefineViewController.swift
//  LibSearchSys
//
//  Created by yuto on 2019/02/11.
//

import UIKit

class RefineViewController: UIViewController {

    var postDismissionAction: (() -> Void)?
    @IBOutlet weak var Refinetags: UIView!
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Do any additional setup after loading the view.
        
        let menuPos = view.frame.size.width - self.Refinetags.layer.frame.size.width
        // 初期位置を画面の外側にするため、メニューの幅の分だけマイナスする
        self.Refinetags.frame.origin.x = view.frame.size.width
        print(view.frame.size.width)
        // 表示時のアニメーションを作成する
        UIView.animate(
            withDuration: 0.2,
            delay: 0,
            options: .curveEaseOut,
            animations: {
                self.Refinetags.frame.origin.x = menuPos
            },
            completion: { bool in
            })
        print("sen")

    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        for touch in touches {
            if touch.view?.tag == 1 {
                UIView.animate(
                    
                    withDuration: 0.2,
                    delay: 0,
                    options: .curveEaseIn,
                    animations: {
                        self.Refinetags.frame.origin.x = UIScreen.main.bounds.size.width
                    },
                    completion: { bool in
                        self.dismiss(animated: true, completion: {
                            print(self.postDismissionAction)
                            self.postDismissionAction?()
                        })
                    }
                )
            }
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
