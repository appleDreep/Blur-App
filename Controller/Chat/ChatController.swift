//
//  ChatController.swift
//  Blur
//
//  Created by Drep on 13/08/21.
//

import Foundation
import UIKit

// the ChatController is the main controller that displays the user's messages with someone else.

private let reuseIdentifier = "Cell"

protocol ChatControllerDelegate:AnyObject {
    func didDeleteMessages(controller:ChatController)
}

class ChatController:UITableViewController {
    //MARK: - DATA
    var currentUser:User?
    private let user:User
    private var messages = [Message]() {
        didSet { configureHeaderView() }
    }
    private var currentUserBlocked:Bool?
    private var userBlocked:Bool?
    
    weak var delegate:ChatControllerDelegate?
    
    //MARK: - PROPERTIES
    private lazy var customInputView: CustomAccesoryView = {
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        let iv = CustomAccesoryView(frame: frame)
        iv.delegate = self
        return iv
    }()
    private lazy var rightBarButtonItem:UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.tintColor = .label
        button.addTarget(self, action: #selector(handleChatOptions), for: .touchUpInside)
        return button
    }()
    private lazy var usernameTitleLabel:UILabel = {
        let label = UILabel()
        label.text = user.username
        label.textColor = .label
        label.font = .flowerLabelSuperBold
        label.textAlignment = .center
        label.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(handleUserOptions))
        label.addGestureRecognizer(gesture)
        return label
    }()
    private let backBarButtonItem:UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        button.tintColor = .label
        return button
    }()
    private lazy var chatControllerHeaderView = ChatControllerHeaderView(user: user)
    
    //MARK: - LIFECYCLE
    init(user:User) {
        self.user = user
        super.init(style: .plain)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        configureUI()
        fetchMessages()
        
        checkIfCurrentUserIsBlocked()
        checkIfUserIsBlocked()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        guard !messages.isEmpty else {return}
        self.tableView.scrollToRow(at: [0,self.messages.count - 1], at: .middle, animated: true)
    }
    override var inputAccessoryView: UIView? {
        get {return customInputView}
    }
    override var canBecomeFirstResponder: Bool {
        return true
    }
    //MARK: - SELECTORS
    @objc func handleChatOptions() {
        let alertControllerSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let action = UIAlertAction(title: "Delete Chat", style: .destructive) { (_) in
            let stringMessage = "This will permanently delete the conversation history."
            
            let alertControllerAlert = UIAlertController(title: "Delete Chat?", message: stringMessage , preferredStyle: .alert)
            
            let action = UIAlertAction(title: "Delete", style: .default) { (_) in
                self.deleteMessages()
            }
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            alertControllerAlert.addAction(action)
            alertControllerAlert.addAction(cancel)
            
            self.present(alertControllerAlert, animated: true, completion: nil)
            
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertControllerSheet.addAction(action)
        alertControllerSheet.addAction(cancel)
        
        self.present(alertControllerSheet, animated: true, completion: nil)
        
    }
    @objc func handleUserOptions(gesture:UITapGestureRecognizer) {
        let controller = ChatOptionsController(user: user)
        controller.userBlocked = self.userBlocked
        controller.delegate = self
        navigationController?.pushViewController(controller, animated: true)
    }
    //MARK: - API
    func fetchMessages() {
        MessagingService.fetchMessages(forUser: self.user) { (messages) in
            self.messages = messages
            DispatchQueue.main.async {
                self.tableView.reloadData()
                guard !messages.isEmpty else {return}
                self.tableView.scrollToRow(at: [0,self.messages.count - 1], at: .middle, animated: true)
            }
        }
    }
    func deleteMessages() {
        guard !messages.isEmpty else {return}
        self.showLoader(true)
        MessagingService.deleteMessages(withUser: self.user) { (error) in
            self.showLoader(false)
            if let error = error {
                print(error.localizedDescription)
                return
            }
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
                self.delegate?.didDeleteMessages(controller: self)
            }
        }
    }
    func unblockUser() {
        RegulationService.unblockUser(user: self.user) { error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            self.checkIfUserIsBlocked()
        }
    }
    func checkIfCurrentUserIsBlocked() {
        RegulationService.checkIfCurrentUserIsBlocked(user: self.user) { blocked in
            self.currentUserBlocked = blocked
        }
    }
    func checkIfUserIsBlocked() {
        RegulationService.checkIfUserIsBlocked(user: self.user) { blocked in
            self.userBlocked = blocked
        }
    }
    //MARK: - HELPERS
    func configureUI() {
        navigationItem.titleView = usernameTitleLabel
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightBarButtonItem)
        navigationItem.backBarButtonItem = UIBarButtonItem(customView: backBarButtonItem)
        
        navigationItem.backBarButtonItem?.tintColor = .label
        
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.keyboardDismissMode = .interactive
        
        tableView.register(ChatCell.self, forCellReuseIdentifier: reuseIdentifier)
        
    }
    func configureHeaderView() {
        //if messages.isEmpty || messages.count < 10 {
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 233)
        chatControllerHeaderView.frame = frame
        tableView.tableHeaderView = chatControllerHeaderView
        //}
    }
}
//MARK: - EXTENSIONS
//MARK:-ChatController
extension ChatController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! ChatCell
        cell.viewModel = ChatViewModel(message: messages[indexPath.row])
        return cell
    }
}
//MARK:-CustomAccesoryViewDelegate
extension ChatController: CustomAccesoryViewDelegate {
    func inputView(_ inputView: CustomAccesoryView) {
        guard !messages.isEmpty else {return}
        self.tableView.scrollToRow(at: [0,self.messages.count - 1], at: .middle, animated: true)
    }
    func inputView(_ inputView: CustomAccesoryView, wantsToUploadText text: String) {
        
        guard let userBlocked = userBlocked else {return}
        guard let currentUserBlocked = currentUserBlocked else {return}
        
        if userBlocked {
            let alert = UIAlertController(title: "You've Blocked This Account", message: "You can't message with \(user.username)", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "Unblock", style: .default) { _ in
                self.unblockUser()
            }
            let cancel = UIAlertAction(title: "Cancel",style: .cancel,handler: nil)
            
            alert.addAction(action)
            alert.addAction(cancel)
            
            present(alert, animated: true, completion: nil)
            
        }else if currentUserBlocked {
            let alert = UIAlertController(title: "Message Not Sent", message: "This person isn't receiving messages right now.", preferredStyle: .alert)
            
            let cancel = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            alert.addAction(cancel)
            
            present(alert, animated: true, completion: nil)
            
        }else {
            guard !text.isEmpty else {return}
            guard let currentUser = currentUser else {return}
            inputView.clearInputTextView()
            
            MessagingService.uploadMessage(text, fromUser: currentUser, to: user) { (error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
            }
        }
    }
}
//MARK:-ChatController
extension ChatController {
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.heightAnchor.constraint(equalToConstant: 11.25).isActive = true
        return view
    }
}
//MARK:-ChatOptionsControllerDelegate
extension ChatController:ChatOptionsControllerDelegate {
    func didBlockUser() {
        self.checkIfUserIsBlocked()
    }
    func didUnblockUser() {
        self.checkIfUserIsBlocked()
    }
}
