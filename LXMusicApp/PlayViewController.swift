//
//  ViewController.swift
//  LXMusicApp
//
//  Created by 王亚玲 on 2017/9/18.
//  Copyright © 2017年 王亚玲. All rights reserved.
//

import UIKit
import SnapKit
import AVFoundation

class PlayViewController: UIViewController {
    
    var rotationAnim:CABasicAnimation?
    var timerForProgress :Timer?
    var lrcTimer : CADisplayLink?
    var musicListViewModel = MusicListViewModel()
    var currentMusic:MusicViewModel?{
        didSet{
            songTitle.text = currentMusic?.musicModel.name
            songSingle.text = currentMusic?.musicModel.singer
            bgImageView.image = UIImage(named: currentMusic?.musicModel.icon ?? "")
            bgView.image = UIImage(named: currentMusic?.musicModel.icon ?? "")
            lrcScrollView.lrcname =  currentMusic?.musicModel.lrcname
        }
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        setUI()
        
        loadMusicList()
        
        musicPlayOrPause()
        
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
    lazy var lrcLabel:UILabel = {
        let lb = UILabel()
        lb.textColor = UIColor.lightGray
        lb.text = "当前播放的歌词"
        return lb
    }()
    
    //1.6.1 歌词文本
    lazy var lrcLabelTwo:UILabel = {
        let lb = UILabel()
        lb.textColor = UIColor.lightGray
        lb.text = "下一句歌词"
        return lb
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
    lazy var lrcScrollView:LrcSrcollView = {
        
        let sv = LrcSrcollView()
        return sv
    }()

}

extension PlayViewController{
    @objc func musicPlayOrPause (){
        
        guard (currentMusic?.musicModel.filename) != nil else {
            
            currentMusic = musicListViewModel.musicList[0]
            playMusic()
            return
        }
        if  MusicTools.sharePlayer.player?.isPlaying == true {
            //暂停
            //暂停动画旋转
            bgImageView.layer.pauseAnimation()
            
            MusicTools.sharePlayer.pausePlay()
            
            playOrpauseButton.setImage(UIImage.init(named: "player_btn_play_normal"), for: .normal)
            
            //7.5 关闭歌词计时器
            removeLrcTimer()
            
            
        }else{
            
            //播放音乐
            //继续动画旋转
            bgImageView.layer.resumeAnimation()
            
            playMusic()
            
            playOrpauseButton.setImage(UIImage.init(named: "player_btn_pause_normal"), for: .normal)
            
            
            
        }
        
        
    }
    func playMusic() {
        if rotationAnim == nil {
            addRotationAnim()
        }
        playOrpauseButton.setImage(UIImage.init(named: "player_btn_pause_normal"), for: .normal)
        MusicTools.sharePlayer.playMusic(musicName: currentMusic?.musicModel.filename ?? "")
        //将时间格式化再赋值
        totalPlayLabel.text = MusicTools.sharePlayer.getDuration().stringByTime()
        
        addTimer()
        //启动计时器
        addLrcTimer()
        
        MusicTools.sharePlayer.delegateOfAVAudioPlayerDelegate(delegate: self as AVAudioPlayerDelegate)
    }
    
    func loadMusicList() {
        
        musicListViewModel.loadMusicList{ (isSuccessed) in
            guard isSuccessed else{
                return
            }
        }
    }
    
    
    func addTimer() {
        timerForProgress = Timer(timeInterval: 1.0, target: self, selector: #selector(PlayViewController.updateProgress), userInfo: nil, repeats: true)
        
        RunLoop.main.add(timerForProgress!, forMode: RunLoopMode.commonModes)
    }
    
   @objc func updateProgress(){
        
        currentPlayLabel.text = MusicTools.sharePlayer.getCurrentTime().stringByTime()
        progressSlider.value = Float(MusicTools.sharePlayer.getCurrentTime() / MusicTools.sharePlayer.getDuration())
        
    }
    func removeProgressTimer (){
        timerForProgress?.invalidate()
        timerForProgress = nil
    }
    
    func addLrcTimer() {
        lrcTimer = CADisplayLink(target: self, selector: #selector(PlayViewController.updateLrc))
        lrcTimer?.add(to: RunLoop.main, forMode: .commonModes)
    }
    
    @objc func updateLrc(){
        //获取实时歌曲播放进度时间
        lrcScrollView.currentTime = MusicTools.sharePlayer.getCurrentTime()
    }
    //移除
    func removeLrcTimer (){
        lrcTimer?.invalidate()
        lrcTimer = nil
    }
    func addTargetToIcon(){
        //3.1监听播放&暂停按钮
        playOrpauseButton.addTarget(self, action: #selector(PlayViewController.musicPlayOrPause), for: .touchUpInside)
        
        nextSong.addTarget(self, action: #selector(PlayViewController.nextOne), for:.touchUpInside)
        
        previousSong.addTarget(self, action: #selector(PlayViewController.previousOne), for: .touchUpInside)
        closeButton.addTarget(self, action: #selector(PlayViewController.closeView), for: .touchUpInside)
    }
    //3.5 下一首歌按钮方法实现
    @objc  func nextOne(){
        
        whichLastOrNext(isNext: true)
        
    }
    @objc func closeView(){
        self .dismiss(animated: true) {
            
        }
    }
    //3.6 下一首歌按钮方法实现
    @objc func previousOne(){
        
        whichLastOrNext(isNext: false)
        
        
        
    }
    //上下曲目选择抽取
    func whichLastOrNext(isNext:Bool){
        
        guard currentMusic != nil else {
            print("currentMusic==nil !!")
            return
        }
        
        let currentIndex = musicListViewModel.musicList.index(of: currentMusic!)
        
        var nextIndex = 0
        
        if isNext {
            
            nextIndex = currentIndex! + 1
            
            if nextIndex > musicListViewModel.musicList.count - 1  {
                
                nextIndex = 0
                
            }
            
            currentMusic = musicListViewModel.musicList[nextIndex]
            
            //播放下一首
            MusicTools.sharePlayer.pausePlay()
            playMusic()
            playOrpauseButton.setImage(UIImage.init(named: "player_btn_pause_normal"), for: .normal)
            
        }else{
            nextIndex = currentIndex! - 1
            
            if nextIndex < 0  {
                
                nextIndex = musicListViewModel.musicList.count - 1
            }
            currentMusic = musicListViewModel.musicList[nextIndex]
            
            //播放上一首
            MusicTools.sharePlayer.pausePlay()
            playMusic()
            playOrpauseButton.setImage(UIImage.init(named: "player_btn_pause_normal"), for: .normal)
            
            
        }
    }
    
    func addTargetToSlider(){
        
        //5.1 监听进度条各个事件
        progressSlider.addTarget(self, action: #selector(PlayViewController.sliderTouchUpInside), for: UIControlEvents.touchUpInside)
        
        progressSlider.addTarget(self, action: #selector(PlayViewController.sliderTouchUpOutside), for: UIControlEvents.touchUpOutside)
        
        progressSlider.addTarget(self, action: #selector(PlayViewController.slidertouchDown), for: UIControlEvents.touchDown)
        
    }
    
    @objc func sliderTouchUpOutside(){
        
        setCTime()
    }
    @objc func sliderTouchUpInside(){
        setCTime()
        
    }
    //重置播放位置
    func setCTime(){
        
        let time = Double(progressSlider.value) * MusicTools.sharePlayer.getDuration()
        //从当前百分比播放
        MusicTools.sharePlayer.setPlayCurretTime(ct: time)
        //给进度条添加记时器
        //   addTimer()
    }
    
    @objc func slidertouchDown(){
        
        //移除计时器
        removeProgressTimer()
        
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
        view.addSubview(lrcLabel)
        view.addSubview(lrcLabelTwo)
        view.addSubview(playOrpauseButton)
        view.addSubview(nextSong)
        //LrcScrollView添加
        setupLrcScrollView()
        
        //设置自动布局
        layoutIconWithSnapKit()
        
        
        setupBlurView()
        
        view.layoutIfNeeded()
        setupIconViewCorner()
        
        //对按钮的处理，添加相应监听事件,能播放音乐
        addTargetToIcon()
        
        //歌曲进度条的完善
        addTargetToSlider()
        
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
            make.left.equalTo(view.snp.left).offset(10)
            make.centerY.equalTo(progressSlider.snp.centerY)
        }
        
        totalPlayLabel.snp.makeConstraints { (make) in
            make.right.equalTo(view.snp.right).offset(-10)
            make.centerY.equalTo(progressSlider.snp.centerY)
        }
        //歌词
        lrcLabel.snp.makeConstraints { (make) in
            make.top.equalTo(bgImageView.snp.bottom).offset(30)
            make.centerX.equalTo(bgImageView.snp.centerX)
            
        }
        lrcLabelTwo.snp.makeConstraints { (make) in
            make.top.equalTo(lrcLabel.snp.bottom).offset(5)
            make.centerX.equalTo(lrcLabel.snp.centerX)
            
        }
        progressSlider.snp.makeConstraints { (make) in
            make.bottom.equalTo(playOrpauseButton.snp.top).offset(-20)
            make.centerX.equalTo(playOrpauseButton.snp.centerX)
            make.width.equalTo(view.bounds.width - currentPlayLabel.bounds.width - totalPlayLabel.bounds.width-30)
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
        //布局lrcScrollView
        lrcScrollView.snp.makeConstraints { (make) in
            make.top.equalTo(songSingle.snp.bottom).offset(10)
            make.left.equalTo(view.snp.left)
            make.right.equalTo(view.snp.right)
            make.bottom.equalTo(playOrpauseButton.snp.top).offset(-50)
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
    //6.3 完善lrcScrollView
    func setupLrcScrollView(){
        view.addSubview(lrcScrollView)
        //lrcScrollView.backgroundColor = UIColor.yellow
        lrcScrollView.contentSize = CGSize(width: CGFloat( UIScreen.main.bounds.width * 2 ), height: 0)
        lrcScrollView.isPagingEnabled = true
        lrcScrollView.showsHorizontalScrollIndicator = false
        lrcScrollView.lrcDelegate = self
        lrcScrollView.delegate = self
    }
    //圆角
    private func setupIconViewCorner() {
        bgImageView.layer.cornerRadius = CGFloat(bgImageView.frame.width/2)
        bgImageView.layer.masksToBounds = true
    }
    
}
extension PlayViewController: AVAudioPlayerDelegate{
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag{
//            nextOne()
            
        }
    }
}
//UIScrollView 代理
extension PlayViewController:LrcScrollViewDelegate,UIScrollViewDelegate{
    //滚动scrollView背景透明效果
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let ratio = scrollView.contentOffset.x / scrollView.bounds.width
        
        lrcLabel.alpha = 1 - ratio
        bgImageView.alpha = 1 - ratio
        lrcLabelTwo.alpha = 1 - ratio
    }
    //7.9 代理实现
    func lrcScrollView(lrcScrollView: LrcSrcollView, nextLrcText: String, currentLrcText: String, preLrcText: String) {
        lrcLabel.text = currentLrcText
        lrcLabelTwo.text = nextLrcText
    }
}





