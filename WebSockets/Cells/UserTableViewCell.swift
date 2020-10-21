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
    
    private var userName = ""
    
    public var isUserTyping: Bool = false {
        didSet {
            
            userNameLabel.text = isUserTyping ?  userName + "(печатает..)" : userName
        }
    }
    
    //MARK: - Instance Methods
    
    func configure(currentUserName: String, userName: String, status: Status) {
        
        self.userName = userName
        
        userNameLabel.text = currentUserName == userName ? "\(userName)(ВЫ)" : userName        
        
        switch status {
        case .online:
            statusLabel.text = "Online"
            statusLabel.textColor = .green
            
        case .offline:
            statusLabel.text = "Offline"
            statusLabel.textColor = .red
        }
    }
}
