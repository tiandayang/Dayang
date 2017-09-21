//
//  DYCloudFileListTableViewCell.swift
//  Dayang
//
//  Created by 田向阳 on 2017/9/6.
//  Copyright © 2017年 田向阳. All rights reserved.
//

import UIKit

class DYCloudFileListTableViewCell: DYBaseTableViewCell {

    override func createSubUI() {
        self.textLabel?.font = UIFont.dy_systemFontWithSize(size: 13)
        self.textLabel?.numberOfLines = 0
    }

    var fileModel: DYCloudFileModel? {
        didSet{
            self.textLabel?.text = fileModel?.fileName
        }
    }
}
