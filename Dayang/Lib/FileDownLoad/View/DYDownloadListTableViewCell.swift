//
//  DYDownloadListTableViewCell.swift
//  Dayang
//
//  Created by 田向阳 on 2017/9/5.
//  Copyright © 2017年 田向阳. All rights reserved.
//

import UIKit
import ReactiveCocoa

class DYDownloadListTableViewCell: DYBaseTableViewCell {

    //MARK: setData
    var fileModel: DYDownloadFileModel? {
        didSet{
            if fileModel != nil {
                self.titleLabel.text = fileModel?.fileName;
                switch fileModel!.downloadStatus {
                case .ing:
                    progressView.progress = fileModel!.progress
                    break
                case .suspend:
//                    progressView.progress = fileModel!.progress
                    progressView.setStateLayer(image:#imageLiteral(resourceName: "file_pause"))
                    break
                case .wait:
                    progressView.setStateLayer(image: #imageLiteral(resourceName: "file_wait"))
                    break
                case .completed:
                    progressView.setStateLayer(image: #imageLiteral(resourceName: "file_success"))
                    break
                case .failed:
                    progressView.setStateLayer(image: #imageLiteral(resourceName: "file_retry"))
                    break
                default: break
                    
                }
            }
        }
    }
    
    //MARK: CreateUI
    override func createSubUI() {
//        selectionStyle = .none
        contentView.addSubview(progressView)
        contentView.addSubview(titleLabel)
        progressView.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-10)
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize.init(width: 40, height: 40))
        }
                
        titleLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(10)
            make.right.equalTo(progressView.snp.left).offset(-10)
        }
    }
    
    lazy var progressView: DYProgressView = {
        let progressView = DYProgressView()
        return progressView;
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.dy_systemFontWithSize(size: 13)
        label.numberOfLines = 0
        label.textColor = .black
        return label
    }()
}
