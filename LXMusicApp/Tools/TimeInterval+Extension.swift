//
//  TimeInterval+Extension.swift
//  LXMusicApp
//
//  Created by Lance on 2018/4/25.
//  Copyright © 2018年 Lance. All rights reserved.
//

import Foundation

extension TimeInterval{
    //时间格式化
    func stringByTime()-> String {
        let min = Int(self) / 60
        let second = Int(self) % 60
        
        return String(format: "%02d:%02d", min, second)
    }
}
