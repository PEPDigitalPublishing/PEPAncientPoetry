//
//  PRPoetrySearchListController.swift
//  PEPRead
//
//  Created by sunShine on 2023/9/14.
//  Copyright © 2023 PEP. All rights reserved.
//

import Foundation
import SwiftyJSON
class PRPoetrySearchListController : BaseAncientPoetryViewController {
    
    var tableView = UITableView.init(frame: CGRect.zero, style: .plain)
    var dataArray: Array = Array<PRPoetryModelData>() {
        didSet{
            self.tableView.reloadData()
        }
    }
    var noResultView = UIView()
    var searchText = ""
    var searchBar = PRPoetrySearchBarView.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    var currentIndex: IndexPath = IndexPath(row: 0, section: 0)
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubViews()
        tableViewSetting()
        setNavView()
        
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        searchBar.textField.resignFirstResponder()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
}
extension PRPoetrySearchListController{
    func setNavView(){
        
        searchBar.block = {[weak self] text in
            self?.dataArray .removeAll()
            self?.currentIndex = IndexPath(row: 0, section: 0)
            print("当前搜索项---\(text)")
            self?.requestResultData(text: text)
        }
        
        self.navigationItem.titleView = searchBar
        if searchText.count > 0{
            searchBar.textField.text = searchText
            searchBar.searchItem = searchText
            self.requestResultData(text: searchText)
        }
    }
}
extension PRPoetrySearchListController{
     func requestResultData(text: String) {
        let params = ["keyword": text]
        self.showLoadingView()
        Networking.postDic(with: URLString(with: .PR_API_poetrySearch), params: params) { [weak self] response in
            self?.hideLoadingView()
            let model = PRPoetrySearchResultModel.init(fromJson: JSON(response))
            if model.errcode == "110" && model.result.count > 0{
                print("")
                self?.dataArray = model.result
                self?.showNoresultView(status: true)
            }else{
                self?.showNoresultView(status: false)
            }
        } fail: { [weak self] error in
            self?.hideLoadingView()
            self?.showNoresultView(status: false)
        }

    }
}
extension PRPoetrySearchListController: UITableViewDelegate, UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
            return 75
        
        
    }
    

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
        
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: PRPoetryListCell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(PRPoetryListCell.self), for: indexPath) as! PRPoetryListCell
        
        let model = dataArray[indexPath.row]
        cell.model = model
        cell.isSearchCell = true
        cell.isSel = false
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            
        if let oldCell = tableView.cellForRow(at: currentIndex) as? PRPoetryListCell{
            oldCell.isSel = false
        }
          
           
        let cell = tableView.cellForRow(at: indexPath) as! PRPoetryListCell
        cell.isSel = true
        currentIndex = indexPath
        
        
        tableView.deselectRow(at: indexPath, animated: true)
        let storyBoard = UIStoryboard(name: "PRPoetryModuleViewController", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "PRPoetryModuleViewController") as! PRPoetryModuleViewController
        let tempModel = dataArray[indexPath.row]
        
        var audioArr = Array<PoetryModel>()
        for model in dataArray{
            vc.bookID = model.bookId
            let audioModel = PoetryModel()
            audioModel.book_id = model.bookId
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
        vc.enType = .sdk
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
extension PRPoetrySearchListController{
    
    func tableViewSetting() {
        tableView.register(PRPoetryListCell.self, forCellReuseIdentifier: NSStringFromClass(PRPoetryListCell.self))
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .white
        tableView.sectionFooterHeight = 0
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = nil
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        } else {
            // Fallback on earlier versions
        }
    }
    
    func setupSubViews(){
        self.view.addSubview(self.tableView)
        tableView.clipsToBounds = false
        tableView.snp.makeConstraints { (make) in
            
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalToSuperview().offset(0)
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
            } else {
                make.bottom.equalTo(bottomLayoutGuide.snp.bottom);
            };
        }
        self.view.addSubview(noResultView)
        noResultView.isHidden = true
        noResultView.backgroundColor = .white
        noResultView.snp.makeConstraints { make in
            make.top.bottom.left.right.equalToSuperview()
        }
        let imgV = UIImageView(image: UIImage(named: "pr_icon_poetry_NoResult"))
        noResultView.addSubview(imgV)
        imgV.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-100)
        }
        let textL = UILabel()
        textL.text = "没有找到您想搜索的古诗词，请换一个关键词试试吧"
        noResultView.addSubview(textL)
        textL.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(imgV.snp_bottom).offset(25)
        }
        textL.textColor = UIColor.init(hexString: "#999999")
        textL.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        let btn = UIButton(type: .custom)
        btn.setTitle("重新搜索", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = UIColor.init(hexString: "#fbb54a")
        noResultView.addSubview(btn)
        btn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(textL.snp_bottom).offset(25)
            make.size.equalTo(CGSize(width: 166, height: 40))
        }
        btn.layer.cornerRadius = 20
        btn.layer.masksToBounds = true
        btn.addTarget(self, action: #selector(clickNoResultBtn), for: .touchUpInside)
    }
    @objc func clickNoResultBtn(){
        self.searchBar.textField.text = ""
        self.noResultView.isHidden = true
        searchBar.textField.becomeFirstResponder()
    }
    func showNoresultView(status: Bool){
        self.noResultView.isHidden = status
    }

}
