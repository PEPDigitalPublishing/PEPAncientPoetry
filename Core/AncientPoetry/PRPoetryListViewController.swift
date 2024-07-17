//
//  PRPoetryListViewController.swift
//  PEPRead
//
//  Created by sunShine on 2023/8/29.
//  Copyright © 2023 PEP. All rights reserved.
//

import Foundation
import SwiftyJSON
import Kingfisher

class PRPoetryListViewController : BaseAncientPoetryViewController {
    @objc public var bookID = ""
    
    var tableView = UITableView.init(frame: CGRect.zero, style: .grouped)
    var dataArray: Array = Array<PRPoetryModelData>() {
        didSet{
            
            self.tableView.reloadData()
        }
    }
    var headerViewDic: [Int: PRPoetryListHeaderView] = [:]
    var searchBar = PRPoetrySearchBarView.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.init(hexString: "#F8F9FD")
        self.removeScrollView = true
        setupSubViews()
        tableViewSetting()
        requestData()
        self.networkErrorViewClicked = {[weak self] in
            self?.requestData()
        }
        self.navigationBar.title.text = "古诗词"
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }


    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
//        searchBar.textField.resignFirstResponder()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
       
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }

}
extension PRPoetryListViewController{

}
extension PRPoetryListViewController{
    override func requestData() {
        self.showLoadingView()
        let userID: String = "10007"
        let accessToken: String = "50661973646216912935778635787400147124579783140712229186815754033346448149325236218026021333123962836531945824971428778499370287811918318414898169176601023703095285223482243312236950515642253917795184098155600085699604300029445321788186995986545139173035940675005601541762211503156178885620450581569025731119"
        let tempUrl = "https://rjyst.mypep.cn/cp/ak/rjyst/user/\(userID)/\(bookID)/getList.json?access_token=\(accessToken)"
        PEPHttpRequestAgent.configHttpHeader(["app-channel": "ios"])
        PRHttpUtil.configHttpHeader(["app-channel": "ios"])
        Networking.postWithHttpResponse(with: tempUrl, params: nil) { [weak self] response in
            self?.hideLoadingView()
            let model = PRPoetryModel.init(fromJson: JSON(response))
            if model.errcode == "110" && model.result.count > 0{
                print("")
                self?.dataArray = model.result
                self?.hideHaveNoDataView()
            }else{
                self?.showHaveNoDataView()
            }
        } fail: { [weak self] error in
            self?.hideLoadingView()
            self?.showHaveNoDataView()
        }

    }
}
extension PRPoetryListViewController: UITableViewDelegate, UITableViewDataSource{

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
            return 85
        
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: PRPoetryListCell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(PRPoetryListCell.self), for: indexPath) as! PRPoetryListCell
        
        let model = dataArray[indexPath.row]
        cell.model = model
       
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let storyBoard = UIStoryboard(name: "PRPoetryModuleViewController", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "PRPoetryModuleViewController") as! PRPoetryModuleViewController
        let tempModel = dataArray[indexPath.row]
        
        var audioArr = Array<PoetryModel>()
        for model in dataArray{
            vc.bookID = model.bookId
            let audioModel = PoetryModel()
            audioModel.book_id = model.bookId
            audioModel.poemId = model.id
            audioModel.path = model.audioPath
            audioModel.chapter_id = model.chapterId
            audioModel.title = model.title
            audioModel.duration = String(model.duration)
            audioModel.genre = model.genre
            audioModel.fileName = model.indexPath
            audioModel.bgImgUrl = model.img_url
            audioArr.append(audioModel)
            if tempModel.chapterId == model.chapterId{
                vc.currentPoetryModel = audioModel
            }
        }
        vc.dataArray = audioArr
        vc.enType = .app
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if let cellView  = cell as? PRPoetryListCell{
            cellView.bgView.createShapeLayer(withRoundingCorners: [.allCorners] , cornerRadii: CGSize(width: 11, height: 11))

        }
    
        
    }
    
    
//    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
//        
//        if let headerView = headerViewDic[section]{
//            
//            headerView.changeBgView()
//        }
//        
//    }
   
}
extension PRPoetryListViewController{
    
    func tableViewSetting() {
        
//        tableView.contentInsetAdjustmentBehavior = .always

        tableView.register(PRPoetryListCell.self, forCellReuseIdentifier: NSStringFromClass(PRPoetryListCell.self))
        tableView.showsVerticalScrollIndicator = false
        
        tableView.sectionFooterHeight = 0
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = nil
        tableView.separatorStyle = .none

        
        tableView.backgroundColor = UIColor.init(hexString: "#F8F9FD")
    }
    
    func setupSubViews(){
        self.view.addSubview(self.tableView)
        tableView.clipsToBounds = false
        tableView.frame = CGRect(x: 0, y: NavBarH_SWIFT, width: Int(WIDTH_SWIFT), height: Int(HEIGHT_SWIFT) - NavBarH_SWIFT)
        tableView.translatesAutoresizingMaskIntoConstraints = false
//        tableView.snp.makeConstraints { (make) in
//            
//            make.left.equalToSuperview()
//            make.right.equalToSuperview()
//            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(0)
//            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
//            
//        }
        
    }
   
}
