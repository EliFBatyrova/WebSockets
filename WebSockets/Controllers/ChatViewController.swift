//
//  ChatViewController.swift
//  WebSockets
//
//  Created by Elina Batyrova on 08.10.2020.
//

import UIKit

class ChatViewController: UIViewController {
    
    //MARK: - Nested Types
    
    private enum Identifiers {
        static let messageTableCell = "MessageTableCell"
    }
    
    //MARK: - Instance Properties
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var messageTextField: UITextField!
    @IBOutlet private weak var bottomViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var typeIndicatorLabel: UILabel!
    
    //MARK: -
    
    private var username: String!
    
    private var socketManager = Managers.socketManager
    
    private var messages: [MessageData] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    private var idleTimer: Timer?
    
    private var isTyping: Bool = false {
        didSet {
            if isTyping {
                socketManager.sendStartTypeEvent(nickName: username)
            }
            else {
                socketManager.sendStopTypeEvent(nickName: username)
            }
        }
    }
    
    //MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupKeyboardNotifications()
        
        self.navigationItem.title = username
        
        messageTextField.delegate = self
        messageTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        startObservingMessages()
        startObservingTypeNotifications()
    }
    
    //MARK: - Instance Methods
    
    func apply(username: String) {
        self.username = username
    }
    
    //MARK: -
    
    @IBAction private func onSendButtonTouchUpInside(_ sender: Any) {
        let text = messageTextField.text ?? ""
        messageTextField.text = nil
        
        socketManager.send(message: text, username: self.username)
    }
    
    //MARK: -
    
    func startObservingMessages() {
        socketManager.observeMessages(completionHandler: { [weak self] data in
            let name = data["nickname"] as! String
            let text = data["message"] as! String
            
            let message = MessageData(text: text, sender: name)
            
            self?.messages.append(message)
        })
    }
    
    func startObservingTypeNotifications() {
        socketManager.observeTypeChangeEvent { [weak self] dict in
            
            guard let self = self else { return }
            let typers = dict.keys
            
            guard !typers.isEmpty && !(typers.count == 1 && typers.first! == self.username) else {
                UIView.animate(withDuration: 0.5) {
                    self.typeIndicatorLabel.alpha = 0
                }
                return
            }
            
            self.typeIndicatorLabel.alpha = 1
            self.typeIndicatorLabel.text = "\(typers.filter({ $0 != self.username }).joined(separator: ", ")) набирает(ют) сообщение"
        }
    }
    
    private func setupKeyboardNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardWillShow(with:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardWillHide(with:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    private func resetIdleTimer() {
        
        idleTimer?.invalidate()
        idleTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { [weak self] _ in
            
            guard let self = self else { return }
            self.socketManager.sendStopTypeEvent(nickName: self.username)
        }
    }

    
    @objc
    private func keyboardWillShow(with notification: Notification) {
        guard let info = notification.userInfo, let keyboardEndSize = (info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size else {
            return
        }
        
        let keyboardHeight = keyboardEndSize.height
        
        UIView.animate(withDuration: 0.25) { [weak self] in
            self?.bottomViewHeightConstraint.constant = keyboardHeight
            
            self?.view.layoutIfNeeded()
        }
    }
    
    @objc
    private func keyboardWillHide(with notification: Notification) {
        UIView.animate(withDuration: 0.25) { [weak self] in
            self?.bottomViewHeightConstraint.constant = 0
            
            self?.view.layoutIfNeeded()
        }
    }
    
    @objc
    private func textFieldDidChange(_ textField: UITextField) {
        isTyping = true
        resetIdleTimer()
    }
}

//MARK: - UITableViewDataSource

extension ChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.messageTableCell, for: indexPath) as! MessageTableViewCell
        
        cell.configure(message: message.text, username: message.sender)
        
        return cell
    }
}

extension ChatViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        isTyping = false
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        isTyping = false
    }
}
