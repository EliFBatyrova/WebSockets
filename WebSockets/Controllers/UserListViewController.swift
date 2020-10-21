//
//  UserListViewController.swift
//  WebSockets
//
//  Created by Elina Batyrova on 08.10.2020.
//

import UIKit

class UserListViewController: UIViewController {
    
    //MARK: - Nested Types
    
    private enum Segues {
        static let writeMessage = "WriteMessage"
    }
    
    private enum Identifiers {
        static let userTableCell = "UserTableCell"
    }
    
    //MARK: - Instance Properties
    
    @IBOutlet private weak var tableView: UITableView!
    
    private var typingTimer: Timer?
    
    //MARK: -
    
    private var username: String!
    
    private var users: [UserData] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    private var socketManager = Managers.socketManager
    
    //MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationItem()
        connectToChat()
        startObservingUserList()
        startObservingTypingStates()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == Segues.writeMessage {
            
            guard let username = sender as? String else { return }
            
            guard let controller = segue.destination as? ChatViewController else { return }
            
            controller.apply(username: username)
        }
    }
    
    private func setupNavigationItem() {
        
        navigationItem.hidesBackButton = true
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Покинуть чат", style: .plain, target: self, action: #selector(exitButtonPressed))
    }
    
    //MARK: - Instance Methods
    
    func apply(username: String) {
        self.username = username
    }
    
    //MARK: -
    
    private func connectToChat() {
        socketManager.connectToChat(with: self.username)
    }
    
    private func startObservingUserList() {
        
        socketManager.observeUserList(completionHandler: { [weak self] data in
            
            var currentUsers: [UserData] = []
            
            for userData in data {
                
                let name = userData["nickname"] as! String
                let isConnected = userData["isConnected"] as! Bool
                
                let user = UserData(username: name, status: isConnected ? .online : .offline)
                
                currentUsers.append(user)
            }
            
            self?.users = currentUsers
        })
    }
    
    private func startObservingTypingStates() {
        
        socketManager.observeTypingEvent { [weak self] dict in
            
            guard let _self = self else { return }
            _self.resetTypingIndicatorTimer()
            
            let typingUsers = dict.keys
            
            guard !typingUsers.isEmpty else {
                
                let cells = _self.tableView.visibleCells as! [UserTableViewCell]
                
                cells.forEach {
                    $0.isUserTyping = false
                }
                return
            }
            
            typingUsers.forEach { typingUser in
                
                guard let index = _self.users.firstIndex(where: { $0.username == typingUser }) else { return }
                
                let cell = _self.tableView.cellForRow(at: IndexPath(row: index, section: 0)) as! UserTableViewCell
                
                UIView.animate(withDuration: 0.3) {
                    cell.isUserTyping = true
                }
            }
        }
    }
    
    
    private func resetTypingIndicatorTimer() {
        
        typingTimer?.invalidate()
        typingTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { [weak self] _ in
            
            guard let _self = self else { return }
            _self.socketManager.sendTypingStopped(userName: _self.username)
        }
    }
    
    //MARK: -
    
    @IBAction private func onWriteMessageTouchUpInside(_ sender: Any) {
        self.performSegue(withIdentifier: Segues.writeMessage, sender: self.username)
    }
    
    @objc
    private func exitButtonPressed() {
        
        socketManager.leaveChat(userName: username)
        
        navigationController?.popViewController(animated: true)
    }
}

//MARK: - UITableViewDataSource

extension UserListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let user = users[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.userTableCell, for: indexPath) as! UserTableViewCell
        
        cell.configure(currentUserName: username, userName: user.username, status: user.status)
        
        return cell
    }
}
