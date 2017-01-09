//
//  CyTableView.swift
//  Customerly
//
//  Created by Paolo Musolino on 08/12/16.
//  Copyright © 2016 Customerly. All rights reserved.
//

import UIKit

class CyTableView: UITableView {
    
    private var refresh: (() -> Void)?
    private var pullToRefresh : UIRefreshControl?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func addPullToRefresh(action: (() -> Void)? = nil){
        
        // Initialize the refresh control.
        pullToRefresh = UIRefreshControl()
        pullToRefresh?.backgroundColor = UIColor.clear
        pullToRefresh?.tintColor = UIColor.gray
        pullToRefresh?.attributedTitle = NSAttributedString(string: "pullToRefresh".localized(comment: "Extra"))
        pullToRefresh?.addTarget(self, action: #selector(refreshStart), for: UIControlEvents.valueChanged)
        self.addSubview(pullToRefresh!)
        self.refresh = action
    }
    
    func endPulltoRefresh(){
        pullToRefresh?.endRefreshing()
    }
    
    func pullToRefreshIsRefreshing() -> Bool{
        return pullToRefresh?.isRefreshing ?? false
    }
    
    func refreshStart(){
        self.refresh?()
    }
    
    
    
}
