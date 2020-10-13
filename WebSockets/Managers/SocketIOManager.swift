//
//  SocketIOManager.swift
//  WebSockets
//
//  Created by Elina Batyrova on 08.10.2020.
//

import Foundation

protocol SocketIOManager {
    
    func establishConnection()
    func closeConnection()
    func connectToChat(with name: String)
    func observeUserList(completionHandler: @escaping ([[String: Any]]) -> Void)
    func send(message: String, username: String)
    func observeMessages(completionHandler: @escaping ([String: Any]) -> Void)
    
}
