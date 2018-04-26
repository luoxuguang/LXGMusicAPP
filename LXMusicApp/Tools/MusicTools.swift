//
//  MusicTools.swift
//  LXMusicApp
//
//  Created by Lance on 2018/4/16.
//  Copyright © 2018年 王亚玲. All rights reserved.
//

import Foundation
import AVFoundation

class MusicTools{
    
    var player : AVAudioPlayer?
    
    static let sharePlayer: MusicTools = {
        
        let player = MusicTools()
        
        return player
        
    }()
    
    func playMusic(musicName:String){
        guard let pathUrl = Bundle.main.url(forResource: musicName, withExtension: nil) else{
            return
        }
        if pathUrl == player?.url{
            player?.play()
            return
        }
        guard let musicTrue = try? AVAudioPlayer(contentsOf: pathUrl) else{
            return
        }
        player = musicTrue
        
        player?.play()
    }
    func pausePlay() {
        player?.pause()
    }
}
extension MusicTools{
    func getDuration() -> TimeInterval {
        return player?.duration ?? 0
    }
    
    func getCurrentTime() -> TimeInterval {
        return player?.currentTime ?? 0
    }
    func setPlayCurretTime(ct:TimeInterval) {
        player?.currentTime = ct
    }
    //代理
    func delegateOfAVAudioPlayerDelegate(delegate:AVAudioPlayerDelegate){
        
        player?.delegate = delegate
        
    }
}

