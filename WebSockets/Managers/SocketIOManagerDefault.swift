//
//  SocketIOManagerDefault.swift
//  WebSockets
//
//  Created by Elina Batyrova on 08.10.2020.
//

import Foundation
import SocketIO

class SocketIOManagerDefault: NSObject, SocketIOManager {
    
    //MARK: - Instance Properties
    
    private var manager: SocketManager!
    private var socket: SocketIOClient!
    
    //MARK: - Initializers
    
    override init() {
        super.init()
        
        manager = SocketManager(socketURL: URL(string: "http://10.17.35.28:3000")!)
        socket = manager.defaultSocket
    }
    
    //MARK: - Instance Methods
    
    func establishConnection() {
        socket.connect()
    }
    
    func closeConnection() {
        socket.disconnect()
    }
    
    func connectToChat(with name: String) {
        socket.emit("connectUser", name)
    }
    
    func observeUserList(completionHandler: @escaping ([[String: Any]]) -> Void) {
        socket.on("userList") { dataArray, _ in
            completionHandler(dataArray[0] as! [[String: Any]])
        }
    }
    
    func send(message: String, username: String) {
        socket.emit("chatMessage", username, message)
    }
    
    func observeMessages(completionHandler: @escaping ([String: Any]) -> Void) {
        socket.on("newChatMessage") { dataArray, _ in
            var messageDict: [String: Any] = [:]
            
            messageDict["nickname"] = dataArray[0] as! String
            messageDict["message"] = dataArray[1] as! String
            
            completionHandler(messageDict)
        }
    }
    
    func exitFromChat(with name: String) {
        socket.emit("exitUser", name)
    }
    
    func observeUserExitUpdate(completionHandler: @escaping (String) -> Void) {
        socket.on("userExitUpdate") { dataArray, _ in
            completionHandler(dataArray[0] as! String)
        }
    }
    
    func startType(with name: String) {
        socket.emit("startType", name)
    }
    
    func stopType(with name: String) {
        socket.emit("stopType", name)
    }
    
    func observeUserTypingUpdate(completionHandler: @escaping ([String: Any]) -> Void) {
        socket.on("userTypingUpdate") { dataArray, _ in
            completionHandler(dataArray[0] as! [String: Any])
        }
    }
}
