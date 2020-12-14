//
//  CyTableView.swift
//  Customerly

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
        pullToRefresh?.addTarget(self, action: #selector(refreshStart), for: UIControl.Event.valueChanged)
        self.addSubview(pullToRefresh!)
        self.refresh = action
    }
    
    func endPulltoRefresh(){
        pullToRefresh?.endRefreshing()
    }
    
    func pullToRefreshIsRefreshing() -> Bool{
        return pullToRefresh?.isRefreshing ?? false
    }
    
    @objc func refreshStart(){
        self.refresh?()
    }
    
    
    
}
