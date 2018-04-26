//
//  CALayer-Extension.swift
//  LXMusicApp
//
//  Created by Lance on 2018/4/20.
//  Copyright © 2018年 王亚玲. All rights reserved.
//

import UIKit

extension CALayer{
    func pauseAnimation() {
        let pausedTime = convertTime(CACurrentMediaTime(), from: nil)
        speed = 0.0
        timeOffset = pausedTime
    }
    
    func resumeAnimation() {
        let pausedTime = timeOffset
        speed = 1.0
        timeOffset = 0.0
        beginTime = 0.0
        let currentTime = convertTime(CACurrentMediaTime(), from: nil)
        beginTime = currentTime - pausedTime
    }
    
}
