//
//  RefineViewController.swift
//  LibSearchSys
//
//  Created by yuto on 2019/02/11.
//

import UIKit

class RefineViewController: UIViewController {

    var postDismissionAction: (() -> Void)?
    var getNavigationBar : (() -> CGFloat)?
    let offimage = UIImage(named: "offswitch")
    let onimage = UIImage(named: "onswitch")
    @IBOutlet weak var Refinetags: UIView!
    @IBOutlet weak var AllPlace: UIButton!
    @IBOutlet weak var AllDocs: UIButton!
    
    @IBOutlet var EachDocs: [UIButton]!
    @IBOutlet var EachPlace: [UIButton]!
    @IBAction func AllPlaceAction(_ sender: Any) {
        if let button = sender as? UIButton{
            if button.tag == 0{
                EachPlace.map({$0.isSelected = false})
                AllPlace.isSelected = true
            }
            else{
                for i in EachPlace{
                    if button.tag == i.tag{
                        i.isSelected = !i.isSelected
                        print(i.tag)
                    }
                }
                AllPlace.isSelected = false
            }
        }
    }
    @IBAction func AllDocsAction(_ sender: Any) {
        if let button = sender as? UIButton{
            if button.tag == 10{
                EachDocs.map({$0.isSelected = false})
                AllDocs.isSelected = true
            }
            else{
                for i in EachDocs{
                    if button.tag == i.tag{
                        i.isSelected = !i.isSelected
                        print(i.tag)
                    }
                }
                AllDocs.isSelected = false
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for i in EachPlace{
            i.setImage(offimage, for: .normal)
            i.setImage(onimage, for: .selected)
        }
        AllPlace.setImage(offimage, for: .normal)
        AllPlace.setImage(onimage, for: .selected)
        AllPlace.isSelected = true
        for i in EachDocs{
            i.setImage(offimage, for: .normal)
            i.setImage(onimage, for: .selected)
        }
        AllDocs.setImage(offimage, for: .normal)
        AllDocs.setImage(onimage, for: .selected)
        AllDocs.isSelected = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Do any additional setup after loading the view.
        let menuPos = view.frame.size.width - self.Refinetags.layer.frame.size.width
        // 初期位置を画面の外側にするため、メニューの幅の分だけマイナスする
        self.Refinetags.frame.origin.x = view.frame.size.width
        self.Refinetags.frame.origin.y =
            self.getNavigationBar?() ?? 0
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
        Refinetags.layer.borderColor = UIColor.gray.cgColor
        Refinetags.layer.borderWidth = 1.0
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
