//
//  CustomerlyConversationListVC.swift
//  Customerly
//
//  Created by Paolo Musolino on 04/12/16.
//  Copyright © 2016 Customerly. All rights reserved.
//

import UIKit

class CustomerlyConversationListVC: CyViewController {

    //MARK: - Initialiser
    static func instantiate() -> CustomerlyConversationListVC
    {
        return self.cyViewControllerFromStoryboard(storyboardName: "CustomerlyChat", vcIdentifier: "CustomerlyConversationListVC") as! CustomerlyConversationListVC
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

extension CustomerlyConversationListVC: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "conversationCell", for: indexPath) as! CyConversationTableViewCell
            
        
            
            return cell
    }
}
