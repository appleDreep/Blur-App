//
//  ChatsControllerFooter.swift
//  Blur
//
//  Created by Drep on 13/08/21.
//

import Foundation
import UIKit

// the supplementary table footer view to show registered users etc.

private let footerCellIdentifier = "FooterCell"

protocol ChatsControllerFooterViewDelegate:AnyObject {
    func didSelectRow(_ controller:ChatsControllerFooterView,user:User)
}

class ChatsControllerFooterView:UIView {
    //MARK: - DATA
    private var users = [User]()
    
    weak var delegate:ChatsControllerFooterViewDelegate?
    
    //MARK: - PROPERTIES
    private lazy var chatsCollectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.showsHorizontalScrollIndicator = false
        cv.backgroundColor = .systemBackground
        return cv
    }()
    private let titleLabel:UILabel = {
        let label = UILabel()
        //label.text = "Message Your Friends"
        label.text = "Candyy Inc."
        label.textColor = .label
        label.font = .sunFlower
        label.textAlignment = .center
        return label
    }()
    private let descriptionLabel:UILabel = {
        let label = UILabel()
        label.text = "When you chat with someone, you will see all the conversations here."
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        label.font = .flowerSystem
        label.textAlignment = .center
        return label
    }()
    private lazy var chatsControllerStackView:UIStackView = {
        let stack = UIStackView(arrangedSubviews: [titleLabel,descriptionLabel])
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 13
        return stack
    }()
    //MARK: - LIFECYCLE
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .systemBackground
        
        addSubview(chatsCollectionView)
        chatsCollectionView.fillSuperview()
        
        addSubview(chatsControllerStackView)
        chatsControllerStackView.centerX(inView: self, topAnchor: topAnchor, paddingTop: 34)
        chatsControllerStackView.anchor(left:leadingAnchor,right: trailingAnchor,paddingLeft: 34,paddingRight: 34)
        
        configureCollectionView()
        fetchUsers()
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - SELECTORS
    //MARK: - API
    func fetchUsers() {
        UserService.fetchUsers { (users) in
            self.users = users.shuffled()
            self.chatsCollectionView.reloadData()
        }
        
    }
    //MARK: - HELPERS
    func configureCollectionView() {
        chatsCollectionView.delegate = self
        chatsCollectionView.dataSource = self
        
        chatsCollectionView.register(ChatsFooterCell.self, forCellWithReuseIdentifier: footerCellIdentifier)
        
        if let layout  = self.chatsCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.sectionInset = .init(top: 0, left: 34, bottom: 0, right: 34)
        }
    }
}
//MARK: - EXTENSIONS
//MARK:-UICollectionViewDelegate
extension ChatsControllerFooterView:UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didSelectRow(self, user: users[indexPath.row])
    }
}
//MARK:-UICollectionViewDelegateFlowLayout
extension ChatsControllerFooterView:UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 233, height: frame.height / 2)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 13
    }
}
//MARK:-UICollectionViewDataSource
extension ChatsControllerFooterView:UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return users.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: footerCellIdentifier, for: indexPath) as! ChatsFooterCell
        cell.viewModel = UserCellViewModel(user: users[indexPath.row])
        return cell
    }
}
