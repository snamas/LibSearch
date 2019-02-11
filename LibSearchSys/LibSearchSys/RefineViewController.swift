//
//  RefineViewController.swift
//  LibSearchSys
//
//  Created by yuto on 2019/02/11.
//

import UIKit

class RefineViewController: UIViewController {

    
    @IBOutlet weak var Refinetags: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let menuPos = self.Refinetags.layer.position
        // 初期位置を画面の外側にするため、メニューの幅の分だけマイナスする
        self.Refinetags.layer.position.x = self.view.frame.width+self.Refinetags.layer.position.x
        // 表示時のアニメーションを作成する
        UIView.animate(
            withDuration: 0.2,
            delay: 0,
            options: .curveEaseOut,
            animations: {
                self.Refinetags.layer.position.x = menuPos.x
            },
            completion: { bool in
            })

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
                        self.Refinetags.layer.position.x = self.view.frame.width+self.Refinetags.layer.position.x
                    },
                    completion: { bool in
                    self.dismiss(animated: true, completion: nil)
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
