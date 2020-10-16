//
//  EnterViewController.swift
//  WebSockets
//
//  Created by Elina Batyrova on 07.10.2020.
//

import UIKit

class EnterViewController: UIViewController {
    
    //MARK: - Nested Types
    
    private enum Segues {
        static let showChat = "ShowChat"
    }
    
    //MARK: - Instance Properties
    
    @IBOutlet private weak var userNameTextField: UITextField!
    @IBOutlet private weak var enterButton: UIButton!
    
    //MARK: -
    
    private var socketManager = Managers.socketManager
    
    //MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        socketManager.establishConnection()
        setupView()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == Segues.showChat {
            guard let username = sender as? String else {
                return
            }
            
            guard let destinationViewController = segue.destination as? UserListViewController else {
                return
            }
            
            destinationViewController.apply(username: username)
        }
        
    }
    
    //MARK: - Instance Methods
    
    @IBAction private func onEnterButtonTouchUpInside(_ sender: Any) {
        let username = userNameTextField.text
        performSegue(withIdentifier: Segues.showChat, sender: username)
    }
    
    //MARK: -
    
    private func setupView() {
        enterButton.layer.cornerRadius = 5
    }
}
