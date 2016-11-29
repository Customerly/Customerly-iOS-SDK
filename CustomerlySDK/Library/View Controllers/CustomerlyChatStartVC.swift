//
//  CyChatStartVC.swift
//  Customerly
//
//  Created by Paolo Musolino on 11/11/16.
//
//

import UIKit

class CustomerlyChatStartVC: CyViewController{
    
    @IBOutlet weak var chatTableView: UITableView!
    @IBOutlet weak var chatTextField: CyTextField!
    @IBOutlet weak var attachmentsButton: CyButton!
    @IBOutlet weak var sendMessageButton: CyButton!
    @IBOutlet weak var composeMessageViewBottomConstraint: NSLayoutConstraint!
    
    var data: CyDataModel?
    
    //MARK: - Initialiser
    static func instantiate() -> CustomerlyChatStartVC
    {
        return self.cyViewControllerFromStoryboard(storyboardName: "CustomerlyChat", vcIdentifier: "CustomerlyChatStartVC") as! CustomerlyChatStartVC
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //TableView configuration
        chatTableView.dataSource = self
        chatTableView.rowHeight = UITableViewAutomaticDimension
        chatTableView.estimatedRowHeight = 124
        data = CyStorage.getCyDataModel()
        
        chatTextField.keyboardDelegate = self
        
        title = data?.app?.name
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: Utils
    func lastAdminActivity() -> String{
        guard data?.active_admins?.count != nil, (data?.active_admins?.count)! >= 1 else {
            return ""
        }
        
        if let last_activity = data?.active_admins?[0].last_active{
            return Date.timeAgoSinceUnixTime(unix_time: last_activity, currentDate: Date())
        }
        
        return ""
    }
    
    //MARK: Actions
    @IBAction func dismissVC(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func newAttachments(_ sender: Any) {
    }
    
    @IBAction func sendMessage(_ sender: Any) {
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension CustomerlyChatStartVC: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //if no admins, the related admin cell and info cell is not showed
        guard (data?.active_admins?.count) != nil else {
            return 0
        }
        
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "activeAdminsCell", for: indexPath) as! CyActiveAdminsTableViewCell
            
            cell.active_admins = data?.active_admins
            cell.lastActivityLabel.text = "Last activity " + lastAdminActivity()
            
            cell.setNeedsUpdateConstraints()
            cell.updateConstraintsIfNeeded()
            
            cell.setNeedsLayout()
            cell.layoutIfNeeded()
            
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "infoCustomerlyCell", for: indexPath) as! CyInfoTableViewCell
            
            return cell
        }
        
    }
}

extension CustomerlyChatStartVC: CyTextFieldKeyboardDelegate{
    func keyboardShowed(height: CGFloat) {
        composeMessageViewBottomConstraint.constant = height
    }
    
    func keyboardHided(height: CGFloat) {
        composeMessageViewBottomConstraint.constant = 0
    }
}

