//
//  SearchResultController.swift
//  Blur
//
//  Created by Drep on 13/08/21.
//

import Foundation
import UIKit

// the SearchResultController is the main controller that displays users that are searched by a specific name.

private let searchCellIdentifier = "Cell"

protocol SearchResultControllerDelegate:AnyObject {
    func showChatController(_ user:User)
}

class SearchResultController:UITableViewController {
    //MARK: - DATA
    var filteredUsers = [User]() {
        didSet {
            tableView.reloadData()
        }
    }
    weak var delegate:SearchResultControllerDelegate?
    
    //MARK: - PROPERTIES
    //MARK: - LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        configureUI()
        
    }
    //MARK: - SELECTORS
    //MARK: - API
    //MARK: - HELPERS
    func configureUI() {
        tableView.separatorStyle = .none
        
        tableView.register(SearchCell.self, forCellReuseIdentifier: searchCellIdentifier)
    }
}
//MARK: - EXTENSIONS
//MARK:-SearchResultController
extension SearchResultController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredUsers.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: searchCellIdentifier, for: indexPath) as! SearchCell
        cell.viewModel = UserCellViewModel(user: filteredUsers[indexPath.row])
        return cell
    }
}
//MARK:-SearchResultController
extension SearchResultController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
//MARK:-SearchResultController
extension SearchResultController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.delegate?.showChatController(filteredUsers[indexPath.row])
    }
}
