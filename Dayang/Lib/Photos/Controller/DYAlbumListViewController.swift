//
//  DYAlbumListViewController.swift
//  Dayang
//
//  Created by 田向阳 on 2017/8/29.
//  Copyright © 2017年 田向阳. All rights reserved.
//

import UIKit

class DYAlbumListViewController: DYBaseTableViewController {

    var selectComplete: ((_ selectArray: Array<DYPhotoModel>)->())? //选择完成的回调
    var maxSelectCount: Int = 9 //做多选择的个数
    
    //MARK: ControllerLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initControllerFirstData()
        loadData()
    }
    
    //MARK: LoadData
    private func loadData() {
        
        DYPhotosHelper.getAllAlbumList { (listArray) in
            self.dataArray?.append(listArray)
            self.tableView.reloadData()
        }
    }
    
    private func initControllerFirstData() {
        self.title = "相册"
        cellHeight = 90
    }

    //MARK: tableViewDataSource & delegate
    
   override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cellIdentifier = "DYAlbumListTableViewCell"
    var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
    if cell == nil {
        cell = DYAlbumListTableViewCell(style: .default, reuseIdentifier: cellIdentifier)
    }
    let albumListCell = cell as! DYAlbumListTableViewCell
    if let model = self.dataArray?.dy_objectAtIndex(index: indexPath.section)?.dy_objectAtIndex(index: indexPath.row){
        albumListCell.albumModel = model as? DYAlbumModel
    }
    return cell!
    
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let model = self.dataArray?.dy_objectAtIndex(index: indexPath.section)?.dy_objectAtIndex(index: indexPath.row){
            let photoListVC = DYPhotoListViewController()
            photoListVC.albumModel = model as? DYAlbumModel
            photoListVC.title = (model as? DYAlbumModel)?.albumName
            photoListVC.selectComplete = self.selectComplete
            photoListVC.maxSelectCount = self.maxSelectCount
            self.navigationController?.pushViewController(photoListVC, animated: true)
        }
    }
    
}
