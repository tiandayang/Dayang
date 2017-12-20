//
//  DYAlbumListViewController.swift
//  Dayang
//
//  Created by 田向阳 on 2017/8/29.
//  Copyright © 2017年 田向阳. All rights reserved.
//

import UIKit

class DYAlbumListViewController: DYBaseTableViewController {

    var selectComplete: dySelectImagesComplete?
    var maxSelectCount: Int = 9 //做多选择的个数
    var mediaType: DYPhotoMediaType = .both //默认展示的资源类型
    //MARK: ControllerLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initControllerFirstData()
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registNotification()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK: LoadData
    @objc private func loadData() {
        
        if !DYPhotosHelper.isOpenAuthority() {
            
            DYAlertViewHelper .showAlertWithCancel(title: "温馨提示", message: "您还没有开启相册权限，是否设置", controller: self, complete: { (index) in
                if index == 1 {
                    DYPhotosHelper.jumpToSetting()
                }else{
                    self.didClickNavigationBarLeftButton()
                }
            })
            return
        }
        
        DYPhotosHelper.getAllAlbumList(mediaType: self.mediaType) { (listArray) in
            self.dataArray?.removeAll()
            self.dataArray?.append(listArray)
            self.tableView.reloadData()
        }
    }
    
    private func initControllerFirstData() {
        self.title = "相册"
        cellHeight = 90
        self.setLeftButtonItemWithTitle(title: "取消")
    }

    private func registNotification() {
    
        NotificationCenter.default.addObserver(self, selector: #selector(loadData), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
    }
    
    override func didClickNavigationBarLeftButton() {
        self.dismiss(animated: true, completion: nil)
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
