//
//  DetailResultView.swift
//  LibSearchSys
//
//  Created by yuto on 2019/02/09.
//

import UIKit
import Kanna
class DetailResultView: UITableViewController {
    var LibData = Libdatafetch()
    private var mysection = ["","配架場所"]
    var openDBjson:OpenBDResult? = nil
    var data:(BibliographyID:String,opacIcon:String,book_title:String,Author:String)?
    var data_from_asklst:(useID:String,Biblioinfo:String,sortkey:String,listpos:String,useURL:String)?
    var BookImage:UIImage?
    let urlSessionGetClient = URLSessionGetClient()
    var DetailResult : [(No:String, kango:String,haichiba:String,seikyu:String,MaterialID:String,Status:String,DueDate:String,yoyakukensu:String)] = []
    var yoyaku_list :[(startindex:Int,rangeindex:Int,orderRSV:String)]?
    var page:Int = 1//BB00283652で10以上の所蔵館かがあるとその先が表示されない。
    func fetch_catdbl(){
        Libdatafetch.detailurl["stposHol"] = String(self.page)
        if let safe_bibid = data?.BibliographyID{
            Libdatafetch.detaildataDB["bibid"] = safe_bibid
        }
        LibData.fetch_main_catdbl(createList:{detailnum in
            if !detailnum.fulldate_list.isEmpty{
                for i in 0..<detailnum.fulldate_list.count{
                self.DetailResult.append((detailnum.no_List[i],detailnum.kango_List[i],detailnum.haichiba_List[i],detailnum.seikyu_list[i],detailnum.MaterialID_List[i],detailnum.jyoutai_list[i],detailnum.fulldate_list[i],detailnum.kango_List[i]))
                }
            }
            self.yoyaku_list = detailnum.yoyaku_list//ここBB00283652で改良が必要
            if let isbn = detailnum.isbn,self.page == 1{
                self.fetch_openDBjson(isbn: String(isbn))
            }
            if let safe_bibid = detailnum.BibliographyID,let safe_icon = detailnum.opacIcon,let safe_title = detailnum.book_title,let safe_auther = detailnum.Auther,self.page == 1{
                self.data = (safe_bibid,safe_icon,safe_title,safe_auther)
            }
            self.page += 10
            if detailnum.fulldate_list.count == 10{
                self.fetch_catdbl()
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
    }//SB00057540ここ例外
    func fetch_image(fetchurl:String){
        urlSessionGetClient.get(url: fetchurl, completion: { data in
            self.BookImage = UIImage(data: data)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        })
    }
    func fetch_openDBjson(isbn:String){
        urlSessionGetClient.get(url: "https://api.openbd.jp/v1/get" ,queryItems: ["isbn":isbn], completion: { data in
            
            do{
                let decoder = JSONDecoder()
                let decodeResult  =  try decoder.decode([OpenBDResult].self, from: data)
                self.openDBjson = decodeResult.first
                if let imageURL:String = self.openDBjson?.onix.collateralDetail?.supportingResource?.first?.resourceVersion?.first?.resourceLink{
                    self.fetch_image(fetchurl: imageURL)
                }
            }catch{
                print("jsonの解析失敗:" + (String(data: data, encoding: String.Encoding.utf8) ?? ""))
            }
        })
    }
    @IBAction func showActionSheet(_ sender: Any) {
        let detailActionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet
        )
        detailActionSheet.addAction(UIAlertAction(title: "ブックマークする", style: .default, handler: {(action) in
                self.addBookmark()
            }))
        detailActionSheet.addAction(UIAlertAction(title: "safariで開く", style: .default, handler: {action in
            let url:String = self.urlSessionGetClient.buildUrl(base: "https://libportal.lib.tmu.ac.jp/index.php", namedValues: Libdatafetch.detaildataDB)
            UIApplication.shared.open(URL(string: url)!, completionHandler:{_ in
                print("safariで起動")
            })
        }))
        detailActionSheet.addAction(UIAlertAction(title: "キャンセル", style: .cancel, handler: nil
        ))
        self.present(detailActionSheet,animated: true,completion:{ print("Do!")})
    }
    func addBookmark(){
        if let safeBibID = data?.BibliographyID{
            LibData.fetch_bookmark(BibliographyID: safeBibID,tfclosure:{fetchResult in
                if fetchResult{
                    let successAlert = UIAlertController(title:nil,message:nil,preferredStyle:.alert)
                    successAlert.title = "ブックマークへの追加に成功しました。"
                    successAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(
                        successAlert,
                        animated:true,
                        completion:{print("success")}
                    )
                }
                else{
                    self.LibData.fetch_comidf(exceptionClosure:{exceptionNum in print(exceptionNum)})
                    let successAlert = UIAlertController(title:nil,message:nil,preferredStyle:.alert)
                    successAlert.title = "ブックマークへの追加に失敗しました"
                    successAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(
                        successAlert,
                        animated:true,
                        completion:{print("Fail to Bookmark")}
                    )
                }
            })
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if let safe_bibid = data?.BibliographyID{
            Libdatafetch.detaildataDB["bibid"] = safe_bibid
            fetch_catdbl()
        }
        else if let safe_asklst = data_from_asklst{
            //ここに利用状況一覧から入る特殊検索を実行する。
            LibData.fetch_usestate_detail(listpos: data_from_asklst?.listpos,sortkey: data_from_asklst?.sortkey,useURL: data_from_asklst?.useURL,createList: {
                BibliographyID,Biblioinfo in
                if let safe_bibid = BibliographyID{
                    Libdatafetch.detaildataDB["bibid"] = safe_bibid
                    self.fetch_catdbl()
                }
                
            })
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
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0{
            return 1
        }
        else if  section == 1{
            return DetailResult.count
        }
        else{
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return mysection[section]
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
            return CGFloat(200)
        }
        else{
            return CGFloat(70)
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailCell", for: indexPath)
        if indexPath.section == 0{
            cell.textLabel?.text = data?.book_title
            cell.detailTextLabel?.text = data?.Author
            cell.textLabel?.numberOfLines = 5
            cell.detailTextLabel?.numberOfLines = 2
            cell.imageView?.image = self.BookImage
        }
        if indexPath.section == 1{
            if !self.DetailResult.isEmpty{
                let webdata = self.DetailResult[indexPath.row]
                if (webdata.kango.isEmpty){
                    cell.textLabel?.text = webdata.haichiba
                }
                else{
                    cell.textLabel?.text = "巻号:" + webdata.kango + "　|　" + webdata.haichiba
                }
                if (webdata.Status.isEmpty){
                    cell.detailTextLabel?.text = webdata.seikyu
                }
                else{
                    cell.detailTextLabel?.text = "\(webdata.Status)(\(webdata.seikyu))"
                }
            }
            else{
                cell.textLabel?.text = "配架場所はありません"//下位図書が存在する可能性
                cell.detailTextLabel?.text = ""
            }
            cell.imageView?.image = nil
        }
        // Configure the cell...
        return cell
    }
}
/*
 bibbr: ハウスクロフト無機化学 / Catherine E. Housecroft, Alan G. Sharpe著 ; 上, 下. -- 東京化学同人, 2012.
 bibid: BB02152052
 cattp: BB
 holid: HL03351626
 vol1:
 vol2:
 holar:
 fvol:
 annul:
 reqType: _NEW
 loginType: once
 system:
 locale: ja
 ufisso_param: 64d4fdde232a8a077d7ae812c1cb5ff3|17e90616e6298235aa7ed83715af8586|nc2op
 bibbr: ハウスクロフト無機化学 / Catherine E. Housecroft, Alan G. Sharpe著 ; 上, 下. -- 東京化学同人, 2012.
 bibid: BB02152052
 cattp: BB
 holid: HL03351624
 vol1:
 vol2:
 holar:
 fvol:
 annul:
 reqType: _NEW
 loginType: once
 system:
 locale: ja
 ufisso_param: 64d4fdde232a8a077d7ae812c1cb5ff3|17e90616e62982358e3ad4e56444ca6a|nc2op

 lenupd.do post
 startpos: 1
 listpos: 1
 sortkey: lmtdt/ASC
 hitcnt: 9
 listcnt: 10
 lenidlist:
 */
public struct OpenBDResult: Codable {
    public let onix: Onix
    public let hanmoto: Hanmoto
    public let summary: Summary
    
    public struct Onix: Codable {
        public let recordReference: String?
        public let notificationType: String?
        public let DeletionText: String?
        public let productIdentifier: ProductIdentifier?
        public let descriptiveDetail: DescriptiveDetail?
        public let collateralDetail: CollateralDetail?
        public let publishingDetail: PublishingDetail?
        public let productSupply: ProductSupply?
        
        public struct ProductIdentifier: Codable {
            public let productIDType: String?
            public let iDValue: String?
            
            private enum CodingKeys: String, CodingKey {
                case productIDType = "ProductIDType"
                case iDValue = "IDValue"
            }
        }
        
        public struct DescriptiveDetail: Codable {
            public let productComposition: String?
            public let productForm: String?
            public let productFormDetail: String?
            public let measure: [Measure]?
            public let collection: Collection?
            public let titleDetail: TitleDetail?
            public let contributor: [Contributor]?
            public let language: [Language]?
            public let extent: [Extent]?
            public let subject: [Subject]?
            
            public struct Measure: Codable {
                public let measureType: String?
                public let measurement: String?
                public let measureUnitCode: String?
                
                private enum CodingKeys: String, CodingKey {
                    case measureType = "MeasureType"
                    case measurement = "Measurement"
                    case measureUnitCode = "MeasureUnitCode"
                }
            }
            
            public struct Collection: Codable {
                public let collectionType: String?
                public let titleDetail: TitleDetail?
                
                public struct TitleDetail: Codable {
                    public let titleType: String?
                    public let titleElement: [TitleElement]?
                    
                    public struct TitleElement: Codable {
                        public let titleElementLevel: String?
                        public let titleText: TitleText?
                        
                        public struct TitleText: Codable {
                            public let content: String?
                        }
                        
                        private enum CodingKeys: String, CodingKey {
                            case titleElementLevel = "TitleElementLevel"
                            case titleText = "TitleText"
                        }
                    }
                    
                    private enum CodingKeys: String, CodingKey {
                        case titleType = "TitleType"
                        case titleElement = "TitleElement"
                    }
                }
                
                private enum CodingKeys: String, CodingKey {
                    case collectionType = "CollectionType"
                    case titleDetail = "TitleDetail"
                }
            }

            public struct TitleDetail: Codable {
                public let titleType: String?
                public let titleElement: TitleElement?
                
                public struct TitleElement: Codable {
                    public let titleElementLevel: String?
                    public let PartNumber: String?
                    public let titleText: TitleText?
                    public let subtitle: Subtitle?
                    
                    public struct TitleText: Codable {
                        public let collationkey: String?
                        public let content: String?
                    }
                    
                    public struct Subtitle: Codable {
                        public let collationkey: String?
                        public let content: String?
                    }
                    
                    private enum CodingKeys: String, CodingKey {
                        case titleElementLevel = "TitleElementLevel"
                        case PartNumber = "PartNumber"
                        case titleText = "TitleText"
                        case subtitle = "Subtitle"
                    }
                }
                
                private enum CodingKeys: String, CodingKey {
                    case titleType = "TitleType"
                    case titleElement = "TitleElement"
                }
            }
            
            public struct Contributor: Codable {
                public let sequenceNumber: String?
                public let contributorRole: [String]?
                public let personName: PersonName?
                public let biographicalNote: String?
                
                public struct PersonName: Codable {
                    public let collationkey: String?
                    public let content: String?
                }
                
                private enum CodingKeys: String, CodingKey {
                    case sequenceNumber = "SequenceNumber"
                    case contributorRole = "ContributorRole"
                    case personName = "PersonName"
                    case biographicalNote = "BiographicalNote"
                }
            }
            
            public struct Language: Codable {
                public let languageRole: String?
                public let languageCode: String?
                public let countryCode: String?
                
                private enum CodingKeys: String, CodingKey {
                    case languageRole = "LanguageRole"
                    case languageCode = "LanguageCode"
                    case countryCode = "CountryCode"
                }
            }
            
            public struct Extent: Codable {
                public let extentType: String?
                public let extentValue: String?
                public let extentUnit: String?
                
                private enum CodingKeys: String, CodingKey {
                    case extentType = "ExtentType"
                    case extentValue = "ExtentValue"
                    case extentUnit = "ExtentUnit"
                }
            }
            
            public struct Subject: Codable {
                public let subjectSchemeIdentifier: String?
                public let subjectCode: String?
                
                private enum CodingKeys: String, CodingKey {
                    case subjectSchemeIdentifier = "SubjectSchemeIdentifier"
                    case subjectCode = "SubjectCode"
                }
            }
            
            private enum CodingKeys: String, CodingKey {
                case productComposition = "ProductComposition"
                case productForm = "ProductForm"
                case productFormDetail = "ProductFormDetail"
                case measure = "measure"
                case collection = "collection"
                case titleDetail = "TitleDetail"
                case contributor = "Contributor"
                case language = "Language"
                case extent = "Extent"
                case subject = "Subject"
            }
        }
        
        public struct CollateralDetail: Codable {
            public let textContent: [TextContent]?
            public let supportingResource: [SupportingResource]?
            
            public struct TextContent: Codable {
                public let textType: String?
                public let contentAudience: String?
                public let text: String?
                
                private enum CodingKeys: String, CodingKey {
                    case textType = "TextType"
                    case contentAudience = "ContentAudience"
                    case text = "Text"
                }
            }
            
            public struct SupportingResource: Codable {
                public let resourceContentType: String?
                public let contentAudience: String?
                public let resourceMode: String?
                public let resourceVersion: [ResourceVersion]?
                
                public struct ResourceVersion: Codable {
                    public let resourceForm: String?
                    public let resourceVersionFeature: [ResourceVersionFeature]?
                    public let resourceLink: String?
                    
                    public struct ResourceVersionFeature: Codable {
                        public let resourceVersionFeatureType: String?
                        public let featureValue: String?
                        
                        private enum CodingKeys: String, CodingKey {
                            case resourceVersionFeatureType = "ResourceVersionFeatureType"
                            case featureValue = "FeatureValue"
                        }
                    }
                    
                    private enum CodingKeys: String, CodingKey {
                        case resourceForm = "ResourceForm"
                        case resourceVersionFeature = "ResourceVersionFeature"
                        case resourceLink = "ResourceLink"
                    }
                }
                
                private enum CodingKeys: String, CodingKey {
                    case resourceContentType = "ResourceContentType"
                    case contentAudience = "ContentAudience"
                    case resourceMode = "ResourceMode"
                    case resourceVersion = "ResourceVersion"
                }
            }
            
            private enum CodingKeys: String, CodingKey {
                case textContent = "TextContent"
                case supportingResource = "SupportingResource"
            }
        }
        
        public struct PublishingDetail: Codable {
            public let imprint: Imprint?
            public let publisher: Publisher?
            public let publishingDate: [PublishingDate]?
            
            public struct Imprint: Codable {
                public let imprintIdentifier: [ImprintIdentifier]?
                public let imprintName: String?
                
                public struct ImprintIdentifier: Codable {
                    public let imprintIDType: String?
                    public let iDValue: String?
                    
                    private enum CodingKeys: String, CodingKey {
                        case imprintIDType = "ImprintIDType"
                        case iDValue = "IDValue"
                    }
                }
                
                private enum CodingKeys: String, CodingKey {
                    case imprintIdentifier = "ImprintIdentifier"
                    case imprintName = "ImprintName"
                }
            }
            
            public struct Publisher: Codable {
                public let publishingRole: String?
                public let publisherIdentifier: [PublisherIdentifier]?
                public let publisherName: String?
                
                public struct PublisherIdentifier: Codable {
                    public let publisherIDType: String?
                    public let iDValue: String?
                    
                    private enum CodingKeys: String, CodingKey {
                        case publisherIDType = "PublisherIDType"
                        case iDValue = "IDValue"
                    }
                }
                
                private enum CodingKeys: String, CodingKey {
                    case publishingRole = "PublishingRole"
                    case publisherIdentifier = "PublisherIdentifier"
                    case publisherName = "PublisherName"
                }
            }
            public struct PublishingDate: Codable {
                public let publishingDateRole: String?
                public let date: String?
                
                private enum CodingKeys: String, CodingKey {
                    case publishingDateRole = "PublishingDateRole"
                    case date = "Date"
                }
            }
            
            private enum CodingKeys: String, CodingKey {
                case imprint = "Imprint"
                case publisher = "publisher"
                case publishingDate = "PublishingDate"
            }
        }
        
        public struct ProductSupply: Codable {
            public let supplyDetail: SupplyDetail?
            
            public struct SupplyDetail: Codable {
                public let returnsConditions: ReturnsConditions?
                public let productAvailability: String?
                public let price: [Price]?
                
                public struct ReturnsConditions: Codable {
                    public let returnsCodeType: String?
                    public let returnsCode: String?
                    
                    private enum CodingKeys: String, CodingKey {
                        case returnsCodeType = "ReturnsCodeType"
                        case returnsCode = "ReturnsCode"
                    }
                }
                
                public struct Price: Codable {
                    public let priceType: String?
                    public let priceAmount: String?
                    public let currencyCode: String?
                    
                    private enum CodingKeys: String, CodingKey {
                        case priceType = "PriceType"
                        case priceAmount = "PriceAmount"
                        case currencyCode = "CurrencyCode"
                    }
                }
                
                private enum CodingKeys: String, CodingKey {
                    case returnsConditions = "ReturnsConditions"
                    case productAvailability = "ProductAvailability"
                    case price = "Price"
                }
            }
            
            private enum CodingKeys: String, CodingKey {
                case supplyDetail = "SupplyDetail"
            }
        }
        
        private enum CodingKeys: String, CodingKey {
            case recordReference = "RecordReference"
            case notificationType = "NotificationType"
            case DeletionText = "DeletionText"
            case productIdentifier = "ProductIdentifier"
            case descriptiveDetail = "DescriptiveDetail"
            case collateralDetail = "CollateralDetail"
            case publishingDetail = "PublishingDetail"
            case productSupply = "ProductSupply"
        }
    }
    
    public struct Hanmoto: Codable {
        public let toji: String?
        public let zaiko: Int?
        public let maegakinado: String?
        public let kaisetsu105w: String?
        public let tsuiki: String?
        public let genrecodetrc: Int?
        public let kankoukeitai: String?
        public let jyuhan: [Jyuhan]?
        public let hastameshiyomi: Bool?
        public let author: [Author]?
        public let datemodified: String?
        public let datecreated: String?
        public let reviews: [Reviews]?
        public let hanmotoinfo: Hanmotoinfo?
        public let dateshuppan: String?
        
        public struct Jyuhan: Codable {
            public let date: String?
            public let ctime: String?
            public let suri: Int?
            public let comment: String?
        }
        
        public struct Author: Codable {
            public let listseq: Int?
            public let dokujikubun: String?
        }
        
        public struct Reviews: Codable {
            public let postUser: String?
            public let reviewer: String?
            public let sourceId: Int?
            public let kubunId: Int?
            public let source: String?
            public let choyukan: String?
            public let han: String?
            public let link: String?
            public let appearance: String?
            public let gou: String?
            
            private enum CodingKeys: String, CodingKey {
                case postUser = "post_user"
                case reviewer
                case sourceId = "source_id"
                case kubunId = "kubun_id"
                case source
                case choyukan
                case han
                case link
                case appearance
                case gou
            }
        }
        
        public struct Hanmotoinfo: Codable {
            public let name: String?
            public let yomi: String?
            public let url: String?
            public let twitter: String?
            public let facebook: String?
        }
    }
    
    public struct Summary: Codable {
        public let isbn: String?
        public let title: String?
        public let volume: String?
        public let series: String?
        public let publisher: String?
        public let pubdate: String?
        public let cover: String?
        public let author: String?
    }
}
