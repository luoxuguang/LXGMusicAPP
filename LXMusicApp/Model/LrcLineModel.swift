//
//  LrcModel.swift
//  LXMusicApp
//
//  Created by Lance on 2018/4/23.
//  Copyright © 2018年 Lance. All rights reserved.
//

import UIKit

class LrcLineModel: NSObject {
    
    var lrcText:String?
    var lrcTime: TimeInterval = 0
    
    init(lrcLineStr: String) {
        // [00:35.89]你所有承诺　虽然都太脆弱
        let str0 = lrcLineStr.components(separatedBy: "]")
        
        lrcText = str0[1]
        
        //时间解析
        //[00:35.89
        let str1 = str0[0].components(separatedBy: "[")
        //00:35.89
        let str2 = str1[1]
        let str3 = str2.components(separatedBy: ":")
        //
        let minute =  Double(str3[0])
        
        let second = Double(str3[1].components(separatedBy: ".")[0])
        
        let ms = Double(str3[1].components(separatedBy: ".")[1])
        
        let timeSecond = minute! * 60 + second! + ms! * 0.01
        lrcTime = timeSecond
    }
}
