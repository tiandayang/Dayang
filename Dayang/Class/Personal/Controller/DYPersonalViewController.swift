//
//  DYPersonalViewController.swift
//  Dayang
//
//  Created by 田向阳 on 2017/8/28.
//  Copyright © 2017年 田向阳. All rights reserved.
//

import UIKit

class DYPersonalViewController: DYBaseTableViewController {

    //MARK: ControllerLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initControllerFirstData()
        loadData()
        registNotification()
    }
    //MARK: LoadData
    private func loadData() {
        DYPersonUIModel.getAllList { (listArray) in
            self.dataArray?.append(listArray)
            self.tableView.reloadData()
        }
    }
    
    private func initControllerFirstData() {
        title = "个人"
    }
    //MARK: Action
    
    //MARK: AddNotificatoin
    private func registNotification() {
        
    }
    
    //MARK: tableViewDataSource & delegate
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "DYBaseTableViewCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        if cell == nil {
            cell = DYBaseTableViewCell(style: .default, reuseIdentifier: cellIdentifier)
        }
        if let model = self.dataArray?.dy_objectAtIndex(index: indexPath.section)?.dy_objectAtIndex(index: indexPath.row) {
            cell?.imageView?.image = UIImage.init(named: (model as! DYPersonUIModel).icon!)
            cell?.textLabel?.text = (model as! DYPersonUIModel).title!
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 0:
            //全部文件
            let fileVC = WXXFileListViewController()
            fileVC.title = "我的文件"
//            fileVC.path = DYLocalFilePathServer.userRootPath()
            self.navigationController?.pushViewController(fileVC, animated: true)
            break
        case 1:
            //图片
            let photoVC = DYAlbumListViewController()
            let nav = DYBaseNavigationController(rootViewController: photoVC)
            photoVC.mediaType = .both
            self.present(nav, animated: true, completion: nil)
            break
            
        default:
           let cloudVC = DYCloudFileListViewController()
           self.navigationController?.pushViewController(cloudVC, animated: true)
            break
        }
    }
    
}
