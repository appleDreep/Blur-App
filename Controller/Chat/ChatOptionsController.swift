//
//  ChatOptionsController.swift
//  Blur
//
//  Created by Drep on 13/08/21.
//

import Foundation
import UIKit

private let chatOptionsCellIdentifier = "Cell"

protocol ChatOptionsControllerDelegate:AnyObject {
    func didBlockUser()
    func didUnblockUser()
}
struct CustomAlertControllerConfig {
    let title:String
    let message:String
}

class ChatOptionsController:UITableViewController {
    //MARK: - DATA
    private let user:User
    var userBlocked:Bool?
    
    weak var delegate:ChatOptionsControllerDelegate?
    //MARK: - PROPERTIES
    private lazy var usernameTitleLabel:UILabel = {
        let label = UILabel()
        label.text = user.username
        label.textColor = .label
        label.font = .flowerLabelSuperBold
        label.textAlignment = .center
        return label
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
        
    }
    //MARK: - SELECTORS
    //MARK: - API
    func blockUser() {
        RegulationService.blockUser(user: self.user) { error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            self.navigationController?.popViewController(animated: true)
            self.delegate?.didBlockUser()
        }
    }
    func unblockUser() {
        RegulationService.unblockUser(user: self.user) { error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            self.navigationController?.popViewController(animated: true)
            self.delegate?.didUnblockUser()
        }
    }
    func reportUser(type:ViolationType) {
        self.navigationController?.popViewController(animated: true)
        RegulationService.reportUser(user: self.user, type: type) { error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
        }
    }
    //MARK: - HELPERS
    func configureUI() {
        navigationItem.titleView = usernameTitleLabel
        
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 233)
        chatControllerHeaderView.frame = frame
        tableView.tableHeaderView = chatControllerHeaderView
        
        tableView.register(ChatOptionsControllerCell.self, forCellReuseIdentifier: chatOptionsCellIdentifier)
    }
    //MARK: -showBlockAlert
    func showBlockAlert() {
        let message = "\(user.username) will not be able to send you messages. Blur won't let them know you blocked them."
        
        let config = CustomAlertControllerConfig(title: "Block \(user.username)?", message: message)
        
        let action = UIAlertAction(title: "Block", style: .default) { (_) in
            self.blockUser()
        }
        customAlertController(config: config, preferredStyle: .alert, action: action)
    }
    //MARK: -showUnblockAlert
    func showUnblockAlert() {
        let message = "They won't be notified that you unblocked them."
        
        let config = CustomAlertControllerConfig(title: "Unblock \(user.username)?", message: message)
        
        let action = UIAlertAction(title: "Unblock", style: .default) { (_) in
            self.unblockUser()
        }
        
        customAlertController(config: config, preferredStyle: .alert, action: action)
    }
    //MARK: -showReportAlert
    func showReportAlert() {
        let message = "We won't notify the account you submitted this report."
        
        let config = CustomAlertControllerConfig(title: "Report \(user.username)?", message: message)
        
        let action = UIAlertAction(title: "Report", style: .default) { (_) in
            
            let message = "You can report this user if you think it is against our community guidelines."
            
            let alertController = UIAlertController(title: "What would you like to report?", message: message, preferredStyle: .actionSheet)
            
            let adultAction = UIAlertAction(title: "Nudity or sexual activity", style: .default) { _ in
                self.reportUser(type: .adult)
            }
            let violenceAction = UIAlertAction(title: "Violence", style: .default) { _ in
                self.reportUser(type: .violence)
            }
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            alertController.addAction(adultAction)
            alertController.addAction(violenceAction)
            alertController.addAction(cancel)
            
            self.present(alertController, animated: true, completion: nil)
            
        }
        customAlertController(config: config, preferredStyle: .actionSheet, action: action)
    }
    //MARK: -createAlertController
    func customAlertController(config:CustomAlertControllerConfig,preferredStyle:UIAlertController.Style,action:UIAlertAction) {
        
        let alert = UIAlertController(title: config.title, message: config.message, preferredStyle: preferredStyle)
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(action)
        alert.addAction(cancel)
        
        self.present(alert, animated: true, completion: nil)
    }
}
//MARK: - EXTENSIONS
//MARK:-ChatOptionsController
extension ChatOptionsController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ChatOptions.allCases.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: chatOptionsCellIdentifier, for: indexPath) as! ChatOptionsControllerCell
        
        guard let option = ChatOptions(rawValue: indexPath.row) else {return cell}
        guard let userBlocked = userBlocked else {return cell}
        
        cell.viewModel = ChatOptionsViewModel(option: option, userBlocked: userBlocked)
        
        return cell
    }
}
//MARK:-ChatOptionsController
extension ChatOptionsController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
}
//MARK:-ChatOptionsController
extension ChatOptionsController {
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
}
//MARK:-ChatOptionsController
extension ChatOptionsController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let option = ChatOptions(rawValue: indexPath.row) else {return}
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch option {
        
        case .Block:
            guard let userBlocked = userBlocked else {return}
            
            if userBlocked {
                self.showUnblockAlert()
            }else {
                self.showBlockAlert()
            }
        case .Report:
            self.showReportAlert()
        }
    }
}
