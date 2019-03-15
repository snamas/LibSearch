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
    var selectedTag:[Int] = []
    @IBOutlet weak var Refinetags: UIScrollView!
    @IBOutlet weak var AllPlace: UIButton!
    @IBOutlet weak var AllDocs: UIButton!
    @objc func buttonpressd(_ sender:UIButton){
        sender.isSelected = !sender.isSelected
        var selectedtmp:[(title:String,value:String,kind:String,paramkey:String,setTagnum:Int)] = []
        var selectedTagPart:[Int] = []
        for v in self.Refinetags.subviews {
            if let v = v as? UIButton,v.isSelected == true{
                selectedTagPart += [v.tag]
            }
        }
        Libdatafetch.selectedlist = selectedTagPart
        print(Libdatafetch.selectedlist)
    }
    /*
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
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*
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
 */
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Do any additional setup after loading the view.
        let menuPos = view.frame.size.width - self.Refinetags.layer.frame.size.width
        // 初期位置を画面の外側にするため、メニューの初期位置を右上に。
        self.Refinetags.frame.origin.x = view.frame.size.width
        self.Refinetags.frame.origin.y = self.getNavigationBar?() ?? 0
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
        
        var buttonheight = 10
        for refinePartList in Libdatafetch.RefineList{
            let refineallButton = UIButton()
            refineallButton.setTitleColor(UIColor.black, for: UIControl.State.normal)
            refineallButton.frame = CGRect(x: 10, y: buttonheight, width: 300, height: 30)
            refineallButton.setImage(offimage, for: .normal)
            refineallButton.setImage(onimage, for: .selected)
            refineallButton.contentHorizontalAlignment = .left
            switch refinePartList[0].kind {
            case "gcattp":
                refineallButton.tag = 10001
                refineallButton.setTitle("全ての資料種", for: .normal)
            case "holar":
                refineallButton.tag = 10002
                refineallButton.setTitle("全ての所蔵館", for: .normal)
            case "auth":
                refineallButton.tag = 10003
                refineallButton.setTitle("全ての著者", for: .normal)
            case "pub":
                refineallButton.tag = 10004
                refineallButton.setTitle("全ての出版社", for: .normal)
            case "range_year":
                refineallButton.tag = 10005
                refineallButton.setTitle("全ての出版年", for: .normal)
            case "cls":
                refineallButton.tag = 10006
                refineallButton.setTitle("全ての分類", for: .normal)
            case "sh":
                refineallButton.tag = 10007
                refineallButton.setTitle("全ての件名", for: .normal)
            case "lang":
                refineallButton.tag = 10008
                refineallButton.setTitle("全ての言語", for: .normal)
            default:break
            }
            refineallButton.addTarget(self, action: #selector(buttonpressd(_:)), for: UIControl.Event.touchUpInside)
            Refinetags.addSubview(refineallButton)
            buttonheight += 30
            refinePartList.forEach { (i) in
                print(i)
                let refineButton = UIButton()
                refineButton.setTitleColor(UIColor.black, for: UIControl.State.normal)
                refineButton.frame = CGRect(x: 30, y: buttonheight, width: 300, height: 30)
                refineButton.setImage(offimage, for: .normal)
                refineButton.setImage(onimage, for: .selected)
                refineButton.setTitle(i.title, for: .normal)
                refineButton.contentHorizontalAlignment = .left
                refineButton.tag = i.setTagnum
                refineButton.addTarget(self, action: #selector(buttonpressd(_:)), for: UIControl.Event.touchUpInside)
                _ = Libdatafetch.selectedlist.map({if $0 == i.setTagnum{
                    refineButton.isSelected = true
                    }
                })
                Refinetags.addSubview(refineButton)
                buttonheight += 30
            }
            buttonheight += 5
        }
        print(selectedTag)
        
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
                        for v in self.Refinetags.subviews {
                            // オブジェクトの型がUIImageView型で、タグ番号が1〜5番のオブジェクトを取得する
                            if let v = v as? UIButton{
                                // そのオブジェクトを親のviewから取り除く
                                v.removeFromSuperview()
                            }
                        }
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
