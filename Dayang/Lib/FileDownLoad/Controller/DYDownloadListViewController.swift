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
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DYDownloadManager.shared.delegate = self
        tableView.reloadData()
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

    //MARK: DYDownloadManagerDelegate
    func downloadingResponse(model: DYDownloadFileModel) {
        DispatchQueue.main.async {
            if let index = DYDownloadManager.shared.allFiles.index(of: model) {
                let indexPath = IndexPath.init(row: index, section: 0)
                if let cell = self.tableView.cellForRow(at: indexPath) {
                    let fileCell = cell as! DYDownloadListTableViewCell
                    fileCell.fileModel = model;
                }
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

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true);
        let model = DYDownloadManager.shared.allFiles[indexPath.row]
        switch model.value(forKeyPath: "dowloadState") as! Int {
        case DYDownloadStatus.ing.rawValue:
            DYDownloadManager.shared.suspend(url: model.fileUrlString);
            break;
        case DYDownloadStatus.none.rawValue:
            DYDownloadManager.shared.resume(url: model.fileUrlString);
            break;
        case DYDownloadStatus.suspend.rawValue:
            DYDownloadManager.shared.resume(url: model.fileUrlString);
            break;
        case DYDownloadStatus.failed.rawValue:
            DYDownloadManager.shared.resume(url: model.fileUrlString);
            break;
        case DYDownloadStatus.completed.rawValue:
            let previewVC = WXXFilePreViewViewController()
            let fileModel = WXXFileListModel()
            fileModel.filePath = model.filePath;
            previewVC.fileArray = [fileModel];
            navigationController?.pushViewController(previewVC, animated: true)
            break;
        default:
            break;
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true;
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete;
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let model = DYDownloadManager.shared.allFiles[indexPath.row]
        DYDownloadManager.shared.deleteFile(url: model.fileUrlString)
        tableView.reloadData()
    }
}

