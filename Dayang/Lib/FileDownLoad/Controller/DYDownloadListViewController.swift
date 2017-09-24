//
//  DYDownloadListViewController.swift
//  Dayang
//
//  Created by 田向阳 on 2017/9/5.
//  Copyright © 2017年 田向阳. All rights reserved.
//

import UIKit

class DYDownloadListViewController: DYBaseTableViewController,DYDownloadManagerDelegate {

    //MARK: ControllerLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initControllerFirstData()
        createUI()
        loadData()
        registNotification()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DYDownloadManager.shared.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        DYDownloadManager.shared.delegate = nil
    }
    //MARK: LoadData
    private func loadData() {
        dataArray?.append(DYDownloadManager.shared.allFiles)
    }
    
    private func initControllerFirstData() {
        title = "下载管理"
    }
    //MARK: Action
    
    //MARK: AddNotificatoin
    private func registNotification() {
        
    }
    //MARK: DYDownloadManagerDelegate
    func downloadingResponse(model: DYDownloadFileModel) {
        if let index = DYDownloadManager.shared.allFiles.index(of: model) {
            let indexPath = IndexPath.init(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) {
                let fileCell = cell as! DYDownloadListTableViewCell
                fileCell.fileModel = model;
            }
        }
    }
    
    func downloadComplete(model: DYDownloadFileModel) {
        tableView.reloadData()
    }
    
    func downloadFaild(model: DYDownloadFileModel, error: Error?) {
        tableView.reloadData()
    }
    //MARK: tableViewDataSource & delegate
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return DYDownloadManager.shared.allFiles.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cellIdentifier = "DYDownloadListTableViewCell"
    var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
    if cell == nil {
        cell = DYDownloadListTableViewCell.init(style: .default, reuseIdentifier: cellIdentifier)
    }
    let listCell = cell as! DYDownloadListTableViewCell
    listCell.fileModel = DYDownloadManager.shared.allFiles[indexPath.row]
    return cell!
    }

    
    //MARK: CreateUI
    private func createUI() {
        
    }
    //MARK: Helper

}

