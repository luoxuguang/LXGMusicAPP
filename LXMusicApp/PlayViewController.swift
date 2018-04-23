//
//  ViewController.swift
//  LXMusicApp
//
//  Created by 王亚玲 on 2017/9/18.
//  Copyright © 2017年 王亚玲. All rights reserved.
//

import UIKit
import SnapKit

class PlayViewController: UIViewController {
    
    var rotationAnim:CABasicAnimation?
    
    override func viewDidAppear(_ animated: Bool) {
        playMusic()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor=UIColor.red
        setUI()
        
    }
    
    //左上关闭按钮
    lazy var closeButton:UIButton = {
        
        let b = UIButton()
        b.setImage(UIImage.init(named: "miniplayer_btn_playlist_close"), for: UIControlState.normal)
        return b
        
    }()
    //更多按钮
    lazy var moreButton:UIButton = {
        
        let b = UIButton()
        b.setImage(UIImage.init(named: "main_tab_more_h"), for: UIControlState.normal)
        b.tintColor = UIColor.darkGray
        b.sizeToFit()
        return b
    }()
    //歌曲名字
    lazy var songTitle:UILabel = {
        let lab = UILabel()
        lab.textColor = UIColor.white
        lab.text = "歌曲名称"
        lab.sizeToFit()
        return lab
    }()
    //歌手名字
    lazy var songSingle:UILabel = {
        let label = UILabel()
        label.textColor = UIColor.lightGray
        label.text = "歌手"
        label.sizeToFit()
        return label
    }()
    //背景
    lazy var bgView:UIImageView = {
        let v = UIImageView()
        v.image = UIImage.init(named: "ddd")
        return v
    }()
    
    //专辑封面图
    lazy var bgImageView:UIImageView = {
        let bgV = UIImageView()
        bgV.layer.borderWidth=5;
        bgV.layer.borderColor=UIColor.lightGray.cgColor
        bgV.image = UIImage.init(named: "ddd")
        return bgV
    }()
    
    //1.7 曲目进度条
    lazy var progressSlider:UISlider = {
        let sv = UISlider()
        sv.minimumTrackTintColor = UIColor.init(red: 51/255, green: 194/255, blue: 124/255, alpha: 1)
        sv.thumbTintColor =  UIColor.init(red: 51/255, green: 194/255, blue: 124/255, alpha: 1)
        return sv
    }()
    
    //曲目进度时间
    lazy var currentPlayLabel:UILabel = {
        
        let lb = UILabel()
        lb.text = "00:00"
        lb.textColor = UIColor.white
        lb.font = UIFont.systemFont(ofSize: 10)
        lb.sizeToFit()
        return lb
    }()
    
    //曲目时长
    lazy var totalPlayLabel:UILabel = {
        
        let lb = UILabel()
        lb.text = "00:00"
        lb.textColor = UIColor.white
        lb.font = UIFont.systemFont(ofSize: 10)
        lb.sizeToFit()
        return lb
    }()
    
    //上一首按钮
    lazy var previousSong:UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage.init(named: "player_btn_pre_normal"), for: .normal)
        return btn
    }()
    
    //下一首按钮
    lazy var nextSong:UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage.init(named: "player_btn_next_normal"), for: .normal)
        return btn
    }()
    
    //播放/暂停 按钮
    lazy var playOrpauseButton:UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage.init(named: "player_btn_play_normal"), for: .normal)
        btn.sizeToFit()
        return btn
    }()

}

extension PlayViewController{
    func playMusic() {
        if rotationAnim == nil {
            addRotationAnim()
        }
    }
    
    func addRotationAnim() {
        
        //创建动画(CABasic/KeyFrame)
        rotationAnim = CABasicAnimation(keyPath: "transform.rotation.z")
        //设置动画的属性
        rotationAnim?.fromValue = 0
        rotationAnim?.toValue = Double.pi * 2
        rotationAnim?.repeatCount = MAXFLOAT
        rotationAnim?.duration = 30
        
        rotationAnim?.isRemovedOnCompletion = false
        guard let animCA = rotationAnim else {
            return
        }
        //将动画添加到layer中
        bgImageView.layer.add(animCA, forKey: nil)
    }
}



extension PlayViewController{
    func setUI(){
        
        //控件添加到view
        view.addSubview(bgView)
        view.addSubview(songSingle)
        view.addSubview(songTitle)
        view.addSubview(closeButton)
        view.addSubview(moreButton)
        view.addSubview(bgImageView)
        view.addSubview(currentPlayLabel)
        view.addSubview(progressSlider)
        view.addSubview(totalPlayLabel)
        view.addSubview(previousSong)
        view.addSubview(playOrpauseButton)
        view.addSubview(nextSong)
        
        
        //设置自动布局
        layoutIconWithSnapKit()
        
        
        setupBlurView()
        
        view.layoutIfNeeded()
        setupIconViewCorner()
        
        
    }
    
    func layoutIconWithSnapKit() {
        //蒙版背景
        bgView.frame = view.bounds
        
        songTitle.snp.makeConstraints { (make) in
            make.top.equalTo(topLayoutGuide.snp.bottom).offset(5)
            make.centerX.equalTo(view.snp.centerX)
        }
        
        songSingle.snp.makeConstraints { (make) in
            make.top.equalTo(songTitle.snp.bottom).offset(15)
            make.centerX.equalTo(songTitle.snp.centerX)
        }
        
        //关闭按钮
        closeButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(songTitle.snp.centerY)
            make.left.equalTo(view.snp.left).offset(5)
            make.height.width.equalTo(moreButton.snp.height)
        }
        
        moreButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(songTitle.snp.centerY)
            make.right.equalTo(view.snp.right).offset(-5)
        }
        
        let imageWidth = view.frame.size.width*3/4
        bgImageView.snp.makeConstraints { (make) in
            make.top.equalTo(songSingle.snp.bottom).offset(15)
            make.centerX.equalTo(view.snp.centerX)
            make.width.height.equalTo(imageWidth)
        }
        
        currentPlayLabel.snp.makeConstraints { (make) in
            make.left.equalTo(view.snp.left)
            make.centerY.equalTo(progressSlider.snp.centerY)
        }
        
        totalPlayLabel.snp.makeConstraints { (make) in
            make.right.equalTo(view.snp.right)
            make.centerY.equalTo(progressSlider.snp.centerY)
        }
        
        progressSlider.snp.makeConstraints { (make) in
            make.bottom.equalTo(playOrpauseButton.snp.top).offset(-20)
            make.centerX.equalTo(playOrpauseButton.snp.centerX)
            make.width.equalTo(view.bounds.width - currentPlayLabel.bounds.width - totalPlayLabel.bounds.width-10)
            make.height.equalTo(20)
        }
        
        playOrpauseButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(view.snp.bottom).offset(-20)
            make.centerX.equalTo(view.snp.centerX)
        }

        previousSong.snp.makeConstraints { (make) in
            make.right.equalTo(playOrpauseButton.snp.left).offset(-20)
            make.centerY.equalTo(playOrpauseButton.snp.centerY)
        }

        nextSong.snp.makeConstraints { (make) in
            make.left.equalTo(playOrpauseButton.snp.right).offset(20)
            make.centerY.equalTo(playOrpauseButton.snp.centerY)
        }
        
    }
    
    /*给背景增加毛玻璃效果*/
    private func setupBlurView() {
        let blurEffect = UIBlurEffect(style: .dark)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = view.bounds
        blurView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        bgView.addSubview(blurView)
    }
    //圆角
    private func setupIconViewCorner() {
        bgImageView.layer.cornerRadius = CGFloat(bgImageView.frame.width/2)
        bgImageView.layer.masksToBounds = true
    }
    
}






