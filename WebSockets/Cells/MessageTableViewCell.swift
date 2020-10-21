//
//  MessageTableViewCell.swift
//  WebSockets
//
//  Created by Elina Batyrova on 08.10.2020.
//

import UIKit

class MessageTableViewCell: UITableViewCell {
    
    //MARK: - Instance Properties
    
    @IBOutlet private weak var messageLabel: UILabel!
    @IBOutlet private weak var senderLabel: UILabel!
    
    //MARK: - Instance Methods
    
    func configure(message: String, username: String) {
        
        let isMe = username == UserDefaults.standard.string(forKey: "currentUserName")
        if isMe {
            self.backgroundColor = .red
        }
        
        messageLabel.text = message
        
        let senderName = isMe ? "ВЫ" : username
        senderLabel.text = "Отправитель: \(senderName)"
    }
}
