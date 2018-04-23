//
//  MusicModel.swift
//  LXMusicApp
//
//  Created by Lance on 2018/4/23.
//  Copyright © 2018年 Lance. All rights reserved.
//

import UIKit

class MusicModel: NSObject {

    var name: String?
    var filename: String?
    var lrcname: String?
    var singer: String?
    var singerIcon: String?
    var icon: String?
    
    init(dict: [String: AnyObject]) {
        super.init()
        self.setValuesForKeys(dict)
    }
    
    override func setValuesForKeys(_ keyedValues: [String : Any]) {
        
    }
    
    override var description: String{
        let keys = ["name","filename","lrcname","singer","singerIcon","icon"]
        
        return dictionaryWithValues(forKeys: keys).description
    }
}
