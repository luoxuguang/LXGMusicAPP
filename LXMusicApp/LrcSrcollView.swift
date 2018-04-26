//
//  LrcSrcollView.swift
//  LXMusicApp
//
//  Created by Lance on 2018/4/20.
//  Copyright © 2018年 王亚玲. All rights reserved.
//

import UIKit

let lrcCellID = "LrcViewCellID"
protocol LrcScrollViewDelegate : class {
    
    func lrcScrollView(lrcScrollView : LrcSrcollView, nextLrcText : String, currentLrcText : String,  preLrcText : String)
}

class LrcSrcollView: UIScrollView {
    
    var currentLineIndex : Int = 0
    var LrcLines: [LrcLineModel]?
    weak var lrcDelegate : LrcScrollViewDelegate?
    var lrcname:String?{
        didSet{
            LrcTableView.setContentOffset(CGPoint(x: 0, y: -bounds.height*0.5), animated: false)
            guard lrcname != nil else {
                return
            }
            LrcLines = LrcTools.parseLrc(lrcName: lrcname!)
            LrcTableView.reloadData()
        }
    }
    var currentTime:TimeInterval = 0 {
        didSet{
            guard let lrclines = LrcLines else {
                return
            }
            
            let count = lrclines.count
            
            //7.2 获取当前播放到那句歌词
            for i in 0..<count{
                //当前句歌词
                let currentLrcline = lrclines[i]
                
                //下一句歌词
                let nextIndex = i + 1
                if nextIndex > count - 1 {
                    continue
                }
                let nextLrcline = lrclines[nextIndex]
                
                // 取得当前两句歌词之间的时间
                
                if currentTime >= currentLrcline.lrcTime  && currentTime < nextLrcline.lrcTime  {
                    
                    if (i == currentLineIndex){
                        return
                    }
                    //7.2.1 用全局变量标记正播放的下标
                    currentLineIndex = i
                    
                    // 取出当前i位置对应的indexPath
                    let indexPath = IndexPath(row: i, section: 0)
                    
                    //7.2.2 刷新正在播放的歌词与前一句
                    LrcTableView.reloadData()
                    LrcTableView.scrollToRow(at: indexPath, at: .middle, animated: true)
                    
                    //7.7 歌词label显示实现
                    currentlineLrcAndNextLineLrc()
                }
            }
        }
        
    }
    
    
    
    lazy var LrcTableView : UITableView = {
        let tableView = UITableView()
        tableView.register(LrcViewCell.self, forCellReuseIdentifier: lrcCellID)
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.rowHeight = 35
        return tableView
    }()
    override func layoutSubviews() {
        super.layoutSubviews()
        //6.5.3 tabelView 位置设置
        let x : CGFloat = bounds.width
        let y : CGFloat = 0
        let w : CGFloat = bounds.width
        let h : CGFloat = bounds.height
        LrcTableView.frame = CGRect(x: x, y: y, width: w, height: h)
        LrcTableView.backgroundColor = UIColor.clear
        
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    func setupUI() {
        addSubview(LrcTableView)
        
    }
}

extension LrcSrcollView: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return LrcLines?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: lrcCellID, for: indexPath) as!LrcViewCell
        if indexPath.row == currentLineIndex {
            cell.lrclabel.font = UIFont.systemFont(ofSize: 17.0)
            cell.lrclabel.textColor = UIColor.white
        } else {
            cell.lrclabel.textColor = UIColor.gray
            cell.lrclabel.font = UIFont.systemFont(ofSize: 14.0)
            
        }
        let lrcline = LrcLines![indexPath.row]
        cell.lrclabel.text = lrcline.lrcText
        return cell
    }
    
}

extension LrcSrcollView {
    func currentlineLrcAndNextLineLrc() {
        
        //  取出本句歌词
        let currentLrcText = LrcLines![currentLineIndex].lrcText ?? ""
        //  取出上一句歌词
        var previousLrcText = ""
        if currentLineIndex - 1 >= 0 {
            previousLrcText = LrcLines![currentLineIndex - 1].lrcText ?? ""
        }
        //  取出下一句歌词
        var nextLrcText = ""
        if currentLineIndex + 1 <= LrcLines!.count - 1 {
            nextLrcText = LrcLines![currentLineIndex + 1].lrcText ?? ""
        }
        
        // 7.8 通过代理回掉歌词
        lrcDelegate?.lrcScrollView(lrcScrollView: self, nextLrcText: nextLrcText, currentLrcText: currentLrcText, preLrcText: previousLrcText)
    }
}



