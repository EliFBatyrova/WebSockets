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
    
    //MARK: - Properties
    
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
        
        setupBackButton()
        connectToChat()
        startObservingUserList()
        startObservingUserExitUpdate()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == Segues.writeMessage {
            guard let username = sender as? String else {
                return
            }
            
            guard let controller = segue.destination as? ChatViewController else {
                return
            }
            
            controller.apply(username: username)
        }
    }
    
    //MARK: - Instance Methods
    
    func apply(username: String) {
        self.username = username
    }
    
    //MARK: - Private methods
    
    private func setupBackButton() {
        
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "Exit chat", style: UIBarButtonItem.Style.plain, target: self, action: #selector(exitFromChat))
        self.navigationItem.leftBarButtonItem = newBackButton
    }
    
    private func connectToChat() {
        socketManager.connectToChat(with: self.username)
    }
    
    @objc
    private func exitFromChat() {
        socketManager.exitFromChat(with: self.username)
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - Observing methods
    
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
    
    private func startObservingUserExitUpdate() {
        socketManager.observeUserExitUpdate(completionHandler: { [weak self] data in
            guard let filteredUsers = self?.users.filter({$0.username != data}) else { return }
            self?.users = filteredUsers
        })
    }
    
    //MARK: - Button actions
    
    @IBAction private func onWriteMessageTouchUpInside(_ sender: Any) {
        self.performSegue(withIdentifier: Segues.writeMessage, sender: self.username)
    }
}

//MARK: - UITableViewDataSource

extension UserListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let user = users[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.userTableCell, for: indexPath) as! UserTableViewCell
        
        cell.configure(userName: user.username, status: user.status)
        
        return cell
    }
}
