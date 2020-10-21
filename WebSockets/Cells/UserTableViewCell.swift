//
//  UserTableViewCell.swift
//  WebSockets
//
//  Created by Elina Batyrova on 08.10.2020.
//

import UIKit

class UserTableViewCell: UITableViewCell {
    
    //MARK: - Instance Properties
    
    @IBOutlet private weak var userNameLabel: UILabel!
    @IBOutlet private weak var statusLabel: UILabel!
    
    //MARK: - Instance Methods
    
    func configure(userName: String, status: Status) {
        
        userNameLabel.text = userName
        
        switch status {
        case .online:
            statusLabel.text = "Online"
            statusLabel.textColor = .green
            
        case .offline:
            statusLabel.text = "Offline"
            statusLabel.textColor = .red
        }
        
        self.selectionStyle = .none
    }
}
