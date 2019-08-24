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
    var RefineTagtoKind:[Int:String] = [:]//これには10001以降は含まれていない
    let refineAllDict:[Int:String] = [
        10001:"gcattp",
        10002:"holar",
        10003:"auth",
        10004:"pub",
        10005:"range_year",
        10006:"cls",
        10007:"sh",
        10008:"lang"
    ]
    @IBOutlet weak var Refinetags: UIScrollView!
    @IBOutlet weak var AllPlace: UIButton!
    @IBOutlet weak var AllDocs: UIButton!
    @objc func buttonpressd(_ sender:UIButton){
        sender.isSelected = !sender.isSelected
        //個別のボタンが選択されたとき（日野館、図書etc..）「全ての」をfalseにする
        if sender.isSelected,let a = RefineTagtoKind[sender.tag],let safeAllTagnum = refineAllDict.filter({ $0.value == a}).first{
            if let v = self.Refinetags.viewWithTag(safeAllTagnum.key) as? UIButton{
                v.isSelected = false
            }
        }
        //「全ての」のボタンが選択されたとき個別のボタンをfalseにする
        if sender.isSelected,let safeAllDict = refineAllDict[sender.tag]{
            for v in self.Refinetags.subviews {
                // オブジェクトの型がUIButton型で、タグ番号が属性一致のオブジェクトを取得する
                if let v = v as? UIButton, RefineTagtoKind.filter({ $0.value == safeAllDict}).contains(where: { (key, value) -> Bool in
                     v.tag == key
                }){
                    v.isSelected = false
                }
            }
        }
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
            }
        )
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
            refineallButton.isSelected = true
            switch refinePartList[0].kind {
            case "gcattp":
                refineallButton.tag = 10001
                refineallButton.setTitle("全ての資料種", for: .normal)
            case "holar":
                refineallButton.tag = 10002
                refineallButton.setTitle("全ての所蔵館", for: .normal)
            case "auth":
                continue
                refineallButton.tag = 10003
                refineallButton.setTitle("全ての著者", for: .normal)
            case "pub":
                continue
                refineallButton.tag = 10004
                refineallButton.setTitle("全ての出版社", for: .normal)
            case "range_year":
                continue
                refineallButton.tag = 10005
                refineallButton.setTitle("全ての出版年", for: .normal)
            case "cls":
                continue
                refineallButton.tag = 10006
                refineallButton.setTitle("全ての分類", for: .normal)
            case "sh":
                continue
                refineallButton.tag = 10007
                refineallButton.setTitle("全ての件名", for: .normal)
            case "lang":
                continue
                refineallButton.tag = 10008
                refineallButton.setTitle("全ての言語", for: .normal)
            default:break
            }
            refineallButton.addTarget(self, action: #selector(buttonpressd(_:)), for: UIControl.Event.touchUpInside)
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
                RefineTagtoKind.updateValue(i.kind, forKey: i.setTagnum)
                if Libdatafetch.selectedlist.contains(i.setTagnum){
                    refineButton.isSelected = true
                    //ここでselectかけられていたら「全ての」がfalseになるように
                    refineallButton.isSelected = false
                }
                Refinetags.addSubview(refineButton)
                buttonheight += 30
            }
            //あえてここに配置
            Refinetags.addSubview(refineallButton)
            buttonheight += 5
        }
        
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
                        var selectedTagPart:[Int] = []
                        for v in self.Refinetags.subviews {
                            if let v = v as? UIButton,v.isSelected == true{
                                selectedTagPart += [v.tag]
                            }
                            // オブジェクトの型がUIImageView型で、UIButtonのオブジェクトを取得する
                            if let v = v as? UIButton{
                                // そのオブジェクトを親のviewから取り除く
                                v.removeFromSuperview()
                            }
                        }
                        Libdatafetch.selectedlist = selectedTagPart
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
