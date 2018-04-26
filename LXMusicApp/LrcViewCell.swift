//
//  LrcViewCell.swift
//  LXMusicApp
//
//  Created by Lance on 2018/4/20.
//  Copyright © 2018年 Lance. All rights reserved.
//

import UIKit

class LrcViewCell: UITableViewCell {

    lazy var lrclabel: UILabel = {
        let lable = UILabel()
        lable.textAlignment = .center
        lable.font = UIFont.systemFont(ofSize: 15.0)
        
        return lable
    }()
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(lrclabel)
        selectionStyle = .none
        backgroundColor = UIColor.clear
    }
    
    override func layoutSubviews() {
        lrclabel.sizeToFit()
        lrclabel.center = contentView.center
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("none implemented")
    }

}
