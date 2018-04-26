//
//  File.swift
//  LXMusicApp
//
//  Created by Lance on 2018/4/24.
//  Copyright © 2018年 Lance. All rights reserved.
//

import Foundation

class LrcTools{
    //6.6.1通过文件名解析歌词为每句歌词LrclineModel模型
    class func parseLrc (lrcName :String)-> [LrcLineModel]?{
        
        guard let filePath = Bundle.main.path(forResource: lrcName, ofType: nil) else {
            return nil
        }
        guard let lrc = try? String(contentsOfFile: filePath) else{
            return nil
        }
        var lrcModelArr = [LrcLineModel]()
        //装载行歌词数组
        let lrcStringBylinesArr = lrc.components(separatedBy: "\n")
        
        // 每一行歌唱
        for lrcStringByline in lrcStringBylinesArr {
            
            if lrcStringByline.contains("[ti:") || lrcStringByline.contains("[ar:") || lrcStringByline.contains("[al:") || !lrcStringByline.contains("[") {
                continue
            }
            //将每行转换为模型
            
            lrcModelArr.append(LrcLineModel(lrcLineStr: lrcStringByline))
            
        }
        return lrcModelArr
    }
    
}
