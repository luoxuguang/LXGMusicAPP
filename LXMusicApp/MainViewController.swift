//
//  MainViewController.swift
//  LXMusicApp
//
//  Created by Lance on 2018/4/25.
//  Copyright © 2018年 Lance. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    lazy var MusicBtn:UIButton = {
       let btn = UIButton()
        btn.setTitle("音乐", for: UIControlState.normal)
        btn.setTitleColor(UIColor.green, for: UIControlState.normal)
        btn .sizeToFit()
        return btn
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(MusicBtn)
        view.backgroundColor = UIColor.white
        MusicBtn.snp.makeConstraints { (make) in
            make.center.equalTo(view.snp.center)
            make.width.equalTo(100)
            make.height.equalTo(50)
        }
       MusicBtn .addTarget(self, action: #selector(MainViewController.showPlayView), for: UIControlEvents.touchUpInside)
        
    }
    

}
extension MainViewController{
    @objc func showPlayView(){
        let main = PlayViewController()
        navigationController?.present(main, animated: true, completion: {
            
        })
    }
}
