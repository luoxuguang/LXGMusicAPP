//
//  LrcSrcollView.swift
//  LXMusicApp
//
//  Created by Lance on 2018/4/20.
//  Copyright © 2018年 王亚玲. All rights reserved.
//

import UIKit

let lrcCellID = "LrcViewCellID"
class LrcSrcollView: UIScrollView {
    
    var LrcLines: [LrcLineModel]?
    lazy var LrcTableView : UITableView = {
        let tableView = UITableView()
        tableView.register(LrcViewCell.self, forCellReuseIdentifier: lrcCellID)
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.rowHeight = 35
        return tableView
    }()
    
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
        let lrcline = LrcLines![indexPath.row]
        cell.lrclabel.text = lrcline.lrcText
        return cell
    }
    
}




