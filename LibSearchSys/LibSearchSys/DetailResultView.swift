//
//  DetailResultView.swift
//  LibSearchSys
//
//  Created by yuto on 2019/02/09.
//

import UIKit

class DetailResultView: UIViewController {
    
    var data:(BibliographyID:String,brank:String,CatalogueType:String,Biblioinfo:String,brank2:String,Author:String)?
    
    @IBOutlet weak var Biblioname: UILabel!
    @IBOutlet weak var Auther: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
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
