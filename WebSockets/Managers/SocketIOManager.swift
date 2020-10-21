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
    func send(message: String, username: String)
    func exitFromChat(with name: String)
    func startType(with name: String)
    func stopType(with name: String)
    func observeUserList(completionHandler: @escaping ([[String: Any]]) -> Void)
    func observeMessages(completionHandler: @escaping ([String: Any]) -> Void)
    func observeUserTypingUpdate(completionHandler: @escaping ([String: Any]) -> Void)
    func observeUserExitUpdate(completionHandler: @escaping (String) -> Void)
}
