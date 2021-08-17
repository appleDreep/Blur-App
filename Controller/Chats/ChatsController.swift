//
//  ChatsController.swift
//  Blur
//
//  Created by Drep on 13/08/21.
//

import Foundation
import UIKit
import Firebase
import FacebookLogin

// the ChatsController is the main controller that displays user conversations.

enum LogOutType {
    case logOut
    case disabledAccountLogOut
}

private let chatCellIdentifier = "Cell"

class ChatsController:UITableViewController {
    //MARK: - DATA
    private var currentUser:User? {
        didSet {
            guard let currentUser = currentUser else {return}
            guard currentUser.disabled == false else {return logOutAccount(type: .disabledAccountLogOut)}
            configureUI()
            configureSearchController()
            fetchConversations()
            checkUserViolation()
        }
    }
    private var searchUsers = [User]()
    private var conversations = [Message]() {
        didSet{ configureFooterView() }
    }
    private var conversationsDictionary = [String: Message]()
    
    private var inSearchMode:Bool {
        return searchController.isActive && !searchController.searchBar.text!.isEmpty
    }
    
    //MARK: - PROPERTIES
    private let searchController = UISearchController(searchResultsController: SearchResultController())
    
    private let backBarButtonItem:UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        button.tintColor = .label
        return button
    }()
    private lazy var userBarButtonItem:UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.tintColor = .label
        button.addTarget(self, action: #selector(handleOptionMenu), for: .touchUpInside)
        return button
    }()
    private lazy var usernameTitleLabel:UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .flowerLabelSuperBold
        label.textAlignment = .center
        label.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(handleEditProfile))
        label.addGestureRecognizer(gesture)
        return label
    }()
    private lazy var chatsControllerFooterView = ChatsControllerFooterView()
    
    //MARK: - LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorStyle = .none
        view.backgroundColor = .systemBackground
        checkIfUserIsLoggedIn()
        
    }
    //MARK: - SELECTORS
    @objc func handleOptionMenu() {
        let popUpWindow = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let action = UIAlertAction(title: "Log out", style: .default) { (_) in
            
            guard let currentUser = self.currentUser else {return}
            
            let alert = UIAlertController(title: "Are you sure \(currentUser.username)?", message: nil, preferredStyle: .alert)
            
            let action = UIAlertAction(title: "Log out", style: .default) { (_) in
                self.logOutAccount(type: .logOut)
            }
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            alert.addAction(action)
            alert.addAction(cancel)
            
            self.present(alert, animated: true, completion: nil)
            
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        popUpWindow.addAction(action)
        popUpWindow.addAction(cancel)
        
        present(popUpWindow, animated: true, completion: nil)
    }
    @objc func handleEditProfile() {
        guard let currentUser = currentUser else {return}
        let controller = EditProfileController(user: currentUser)
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true, completion: nil)
    }
    //MARK: - API
    //MARK: -checkIfUserIsLoggedIn
    func checkIfUserIsLoggedIn(){
        if Auth.auth().currentUser == nil {
            presentLogInController()
        }else {
            checkIfUserIsRegistered()
        }
    }
    //MARK: -checkIfUserIsRegistered
    func checkIfUserIsRegistered() {
        AuthService.checkIfUserIsRegistered { (registered) in
            if registered == false {
                self.presentLogInController()
            }else {
                self.fetchCurrentUser()
            }
        }
    }
    //MARK: -fetchCurrentUser
    func fetchCurrentUser() {
        UserService.fetchCurrentUser { (user) in
            self.currentUser = user
        }
    }
    //MARK: -fetchConversations
    func fetchConversations() {
        MessagingService.fetchRecentMessages { (conversations) in
            conversations.forEach { (conversations) in
                self.conversationsDictionary[conversations.chatPartnerId] = conversations
            }
            self.conversations = Array(self.conversationsDictionary.values)
            self.conversations.sort(by: { $0.timestamp.seconds > $1.timestamp.seconds })
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    //MARK: -fetchSearchUsers
    func fetchSearchUsers() {
        UserService.fetchUsers { (users) in
            self.searchUsers = users
            self.tableView.reloadData()
        }
    }
    //MARK: -logOutAccount
    func logOutAccount(type:LogOutType) {
        switch type {
        
        case .logOut:
            self.logOut()
        case .disabledAccountLogOut:
            self.dismiss(animated: true, completion: nil)
            
            let message = "Your account has been disabled for violating our terms."
            let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            
            self.present(alert, animated: true, completion: nil)
            
            DispatchQueue.main.asyncAfter(deadline: .now()+3) {
                alert.dismiss(animated: true, completion: nil)
                self.logOut()
            }
        }
    }
    //MARK: -logOut
    func logOut() {
        showLoader(true)
        DispatchQueue.main.async {
            LoginManager().logOut()
            do {
                try Auth.auth().signOut()
                self.showLoader(false)
                self.presentLogInController()
            }catch let error {
                print(error.localizedDescription)
            }
        }
    }
    //MARK: - HELPERS
    func configureUI() {
        guard let currentUser = currentUser else {return}
        
        usernameTitleLabel.text = currentUser.username
        navigationItem.titleView = usernameTitleLabel
        
        navigationItem.backBarButtonItem = UIBarButtonItem(customView: backBarButtonItem)
        navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: userBarButtonItem)]
        
        navigationItem.backBarButtonItem?.tintColor = .label
        
        tableView.register(ChatsCell.self, forCellReuseIdentifier: chatCellIdentifier)
        
        tableView.allowsMultipleSelection = false
        tableView.allowsMultipleSelectionDuringEditing = false
        tableView.showsVerticalScrollIndicator = false
        
    }
    func configureSearchController() {
        navigationItem.searchController = searchController
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
    }
    func showChatControllerForUser(user:User) {
        let controller = ChatController(user: user)
        controller.delegate = self
        controller.currentUser = self.currentUser
        self.navigationController?.pushViewController(controller, animated: true)
    }
    func presentLogInController() {
        DispatchQueue.main.async {
            let controller = LogInController()
            controller.delegate = self
            let nav = UINavigationController(rootViewController: controller)
            nav.modalPresentationStyle = .fullScreen
            nav.modalTransitionStyle = .crossDissolve
            self.present(nav, animated: true, completion: nil)
        }
    }
    func refreshChats() {
        DispatchQueue.main.async {
            self.conversations.removeAll()
            self.conversationsDictionary.removeAll()
            self.fetchConversations()
        }
    }
    func configureFooterView() {
        chatsControllerFooterView.delegate = self
        if conversations.count < 5 {
            DispatchQueue.main.async {
                let frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height - 55)
                self.chatsControllerFooterView.frame = frame
                self.tableView.tableFooterView = self.chatsControllerFooterView
            }
        }
    }
    //MARK: - REGULATION
    func checkUserViolation() {
        guard let currentUser = currentUser else {return}
        
        if currentUser.violation == true {
            let controller = ViolationController()
            let nav = UINavigationController(rootViewController: controller)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true, completion: nil)
        }
    }
}
//MARK: - EXTENSIONS
//MARK:-ChatsController
extension ChatsController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversations.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: chatCellIdentifier, for: indexPath) as! ChatsCell
        cell.viewModel = ChatViewModel(message: conversations[indexPath.row])
        return cell
    }
}
//MARK:-ChatsController
extension ChatsController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
//MARK:-ChatsController
extension ChatsController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        UserService.fetchUser(withUid: conversations[indexPath.row].chatPartnerId) { (user) in
            self.showChatControllerForUser(user: user)
        }
    }
}
//MARK:-UISearchResultsUpdating
extension ChatsController:UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else {return}
        let controller = searchController.searchResultsController as! SearchResultController
        controller.delegate = self
        
        if inSearchMode {
            controller.filteredUsers = searchUsers.filter({
                $0.username.contains(text)
            })
        }
    }
}
//MARK:-UISearchBarDelegate
extension ChatsController:UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.fetchSearchUsers()
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        let controller = searchController.searchResultsController as! SearchResultController
        controller.filteredUsers.removeAll()
    }
}
//MARK:-SearchResultControllerDelegate
extension ChatsController:SearchResultControllerDelegate {
    func showChatController(_ user: User) {
        showChatControllerForUser(user: user)
    }
}
//MARK:-AuthenticationDelegate
extension ChatsController:AuthenticationDelegate {
    func AuthenticationDidComplete(type: AuthCompleteType) {
        switch type {
        
        case .normal:
            self.fetchCurrentUser()
            self.dismiss(animated: true, completion: nil)
        case .async:
            self.navigationController?.popToViewController(self, animated: true)
            self.conversations.removeAll()
            self.conversationsDictionary.removeAll()
            self.tableView.reloadData()
            DispatchQueue.main.asyncAfter(deadline: .now()+3) {
                self.fetchCurrentUser()
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
}
//MARK:-ChatControllerDelegate
extension ChatsController:ChatControllerDelegate {
    func didDeleteMessages(controller: ChatController) {
        refreshChats()
    }
}
//MARK:-ChatsControllerFooterViewDelegate
extension ChatsController:ChatsControllerFooterViewDelegate {
    func didSelectRow(_ controller: ChatsControllerFooterView, user: User) {
        UserService.fetchUser(withUid: user.uid) { (user) in
            self.showChatControllerForUser(user: user)
        }
    }
}
