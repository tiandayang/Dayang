//
//  DYCloudFileListViewController.swift
//  Dayang
//
//  Created by 田向阳 on 2017/9/6.
//  Copyright © 2017年 田向阳. All rights reserved.
//

import UIKit

class DYCloudFileListViewController: DYBaseTableViewController {
    
    //MARK: ControllerLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initControllerFirstData()
        loadData()
        registNotification()
    }
    //MARK: LoadData
    private func loadData() {
     DYCloudFileModel.getCloudFileList { (listArray) in
        self.dataArray?.append(listArray)
        self.tableView .reloadData()
        }
    }
    
    private func initControllerFirstData() {
        self.title = "网盘文件"
        self.cellHeight = 50
    }
    //MARK: Action
    
    //MARK: AddNotificatoin
    private func registNotification() {
        
    }
    
    //MARK: tableViewDelegate
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "DYCloudFileListTableViewCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        if cell  == nil {
            cell = DYCloudFileListTableViewCell(style: .default, reuseIdentifier: cellIdentifier)
        }
        let cloudCell = cell as! DYCloudFileListTableViewCell
        cloudCell.fileModel = self.dataArray?.dy_objectAtIndex(index: indexPath.section)?.dy_objectAtIndex(index: indexPath.row) as? DYCloudFileModel
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = self.dataArray?.dy_objectAtIndex(index: indexPath.section)?.dy_objectAtIndex(index: indexPath.row) as? DYCloudFileModel
        let isDownload = DYDownloadManager.shared.fileIsDowloaded(fileURL: (model?.fileUrlString)! as String)
        if isDownload {
            DYAlertViewHelper.showAlert(title: "已下载", controller: self, complete: nil)
        }else{
            DYAlertViewHelper.showAlertWithCancel(title: "是否下载？", message: "", controller: self, complete: { (index) in
                if index == 1 {
                    DYDownloadManager.shared.beginDownload(url: (model?.fileURL)!, progress: nil, completed: nil)
                }
            })
        }
    }

}
