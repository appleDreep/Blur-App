//
//  WarningController.swift
//  Blur
//
//  Created by Drep on 13/08/21.
//

import Foundation
import UIKit

private let warningCellIdentifier = "Cell"

class WarningController:UITableViewController {
    //MARK: - DATA
    private var violations = [Violation]()
    //MARK: - PROPERTIES
    private lazy var doneButtonItem:UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .label
        button.addTarget(self, action: #selector(handleDone), for: .touchUpInside)
        return button
    }()
    //MARK: - LIFECYCLE
    init(violations:[Violation]) {
        self.violations = violations
        super.init(style: .plain)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        configureUI()
        configureHeaderView()
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - SELECTORS
    @objc func handleDone() {
        self.showLoader(true)
        RegulationService.updateUserViolationWarning { error in
            self.showLoader(false)
            if let error = error {
                print(error.localizedDescription)
                return
            }
            self.dismiss(animated: true, completion: nil)
        }
    }
    //MARK: - API
    //MARK: - HELPERS
    func configureUI() {
        navigationController?.navigationBar.barTintColor = .systemBackground
        navigationController?.navigationBar.isTranslucent = false
        
        tableView.showsVerticalScrollIndicator = false
        tableView.allowsSelection = false
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: doneButtonItem)
        
        tableView.register(ViolationControllerCell.self, forCellReuseIdentifier: warningCellIdentifier)
    }
    func configureHeaderView() {
        let header = ViolationControllerHeaderView()
        header.warningHeaderViewModel = WarningHeaderViewModel(warningType: .violationsCount(violations: violations.count))
        
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 180)
        header.frame = frame
        tableView.tableHeaderView = header
    }
}
//MARK: - EXTENSIONS
//MARK: - ViolationController
extension WarningController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return violations.count
    }
}
//MARK: - ViolationController
extension WarningController {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: warningCellIdentifier, for: indexPath) as! ViolationControllerCell
        
        guard let violationType = ViolationType(rawValue: violations[indexPath.row].type) else {return cell}
        
        let config = WarningConfig(violation: violations[indexPath.row], violationType: violationType)
        
        cell.warningViewModel = WarningViewModel(warningConfig: config)
        
        return cell
    }
}
//MARK: - ViolationController
extension WarningController {
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
}
