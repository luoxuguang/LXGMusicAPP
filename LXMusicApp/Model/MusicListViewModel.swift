//
//  MusicListViewModel.swift
//  LXMusicApp
//
//  Created by Lance on 2018/4/23.
//  Copyright © 2018年 Lance. All rights reserved.
//

import UIKit

class MusicListViewModel: NSObject {
    lazy var musicList = [MusicViewModel]()
    
    func loadMusicList(finished: (_ isSucceed:Bool)->()){
        let filePath = Bundle.main.path(forResource: "Musics.plist", ofType: nil)
        guard (filePath != nil) else{
            finished(false)
            return
        }
        guard let arr = NSArray(contentsOfFile: filePath!) as? [[String: AnyObject]] else{
            finished(false)
            return
        }
        for dict in arr {
            musicList.append(MusicViewModel(ms: MusicModel(dict: dict)))
        }
        finished(true)
    }
}

