//
//  MusicViewModel.swift
//  LXMusicApp
//
//  Created by Lance on 2018/4/23.
//  Copyright © 2018年 Lance. All rights reserved.
//

import UIKit

class MusicViewModel: NSObject {

    var musicModel: MusicModel
    init(ms: MusicModel) {
        
        self.musicModel = ms
        super.init()
    }
 
    override var description: String{
        return self.musicModel.description
    }
}
