//
//  ViolationController.swift
//  Blur
//
//  Created by Drep on 13/08/21.
//

import Foundation
import UIKit

private let violationCellIdentifier = "Cell"

class ViolationController:UITableViewController {
    //MARK: - DATA
    private var violations = [Violation]() {
        didSet { configureHeaderView() }
    }
    //MARK: - PROPERTIES
    private let backBarButtonItem:UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        button.tintColor = .label
        return button
    }()
    //MARK: - LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        configureUI()
        fetchUserViolations()
        
    }
    //MARK: - SELECTORS
    //MARK: - API
    func fetchUserViolations() {
        RegulationService.fetchUserViolations { violations in
            self.violations = violations
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    //MARK: - HELPERS
    func configureUI() {
        navigationController?.navigationBar.barTintColor = .systemBackground
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.tintColor = .label
        
        tableView.showsVerticalScrollIndicator = false
        
        navigationItem.backBarButtonItem = UIBarButtonItem(customView: backBarButtonItem)
        
        tableView.register(ViolationControllerCell.self, forCellReuseIdentifier: violationCellIdentifier)
    }
    func configureHeaderView() {
        guard let violations = violations.last else {return}
        guard let violation = ViolationType(rawValue: violations.type) else {return}
        let header = ViolationControllerHeaderView()
        
        header.viewModel = ViolationHeaderViewModel(violationType: violation)
        
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 280)
        header.frame = frame
        tableView.tableHeaderView = header
    }
    func pushWarningController() {
        let controller = WarningController(violations: violations.reversed())
        self.navigationController?.pushViewController(controller, animated: true)
    }
}
//MARK: - EXTENSIONS
//MARK: - ViolationController
extension ViolationController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ViolationOptions.allCases.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: violationCellIdentifier, for: indexPath) as! ViolationControllerCell
        
        guard let option = ViolationOptions(rawValue: indexPath.row) else {return cell}
        guard let violation = violations.last else {return cell}
        guard let type = ViolationType(rawValue: violation.type) else {return cell}
        
        let config = ViolationConfig(violationOption: option, violationType: type, violation: violation)
        
        cell.viewModel = ViolationViewModel(violationConfig: config)
        
        return cell
    }
}
//MARK: - ViolationController
extension ViolationController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        pushWarningController()
    }
}
//MARK: - ViolationController
extension ViolationController {
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
}
