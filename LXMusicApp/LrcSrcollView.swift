//
//  LrcSrcollView.swift
//  LXMusicApp
//
//  Created by Lance on 2018/4/20.
//  Copyright © 2018年 王亚玲. All rights reserved.
//

import UIKit

class LrcSrcollView: UIScrollView {
    
    lazy var tableView : UITableView = UITableView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}

