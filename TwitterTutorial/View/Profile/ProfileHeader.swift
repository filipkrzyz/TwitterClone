//
//  ProfileHeader.swift
//  TwitterTutorial
//
//  Created by Filip Krzyzanowski on 08/09/2020.
//  Copyright © 2020 Filip Krzyzanowski. All rights reserved.
//

import UIKit

protocol ProfileHeaderDelegate: AnyObject {
    func handleDismissal()
    func handleEditProfileFollow(_ header: ProfileHeader)
    func didSelect(filter: ProfileFilterOptions)
}

class ProfileHeader: UICollectionReusableView {
    
    // MARK: - Properties
    
    var user: User? {
        didSet {
            configure()
        }
    }
    
    weak var delegate: ProfileHeaderDelegate?
    
    private let filterBar = ProfileFilterView()
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .twitterBlue
        
        view.addSubview(backButton)
        backButton.anchor(top: view.topAnchor, left: view.leftAnchor,
                          paddingTop: 42, paddingLeft: 16)
        backButton.setDimensions(width: 30, height: 30)
        
        return view
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "baseline_arrow_back_white_24dp").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleBackButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 4
        imageView.backgroundColor = .lightGray
        
        return imageView
    }()
    
    private lazy var editProfileOrFollowButton: UIButton = {
        let button = UIButton()
        button.setTitle("Loading", for: .normal)
        button.layer.borderColor = UIColor.twitterBlue.cgColor
        button.layer.borderWidth = 1.25
        button.setTitleColor(.twitterBlue, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.addTarget(self, action: #selector(handleEditProfileFollow), for: .touchUpInside)
        return button
    }()
    
    private let fullnameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .lightGray
        return label
    }()
    
    private let bioLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 3
        return label
    }()
    
    private let followingLabel: UILabel = {
        let label = UILabel()
        label.text = "0 Following"
        let followTap = UITapGestureRecognizer(target: self, action: #selector(handleFollowersTapped))
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(followTap)
        return label
    }()
    
    private let followersLabel: UILabel = {
        let label = UILabel()
        label.text = "2 Followers"
        let followTap = UITapGestureRecognizer(target: self, action: #selector(handleFollowingTapped))
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(followTap)
        return label
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        filterBar.delegate = self
        
        addSubview(containerView)
        containerView.anchor(top: topAnchor,
                             left: leftAnchor, right: rightAnchor,
                             height: 108)
        
        addSubview(profileImageView)
        profileImageView.anchor(top: containerView.bottomAnchor,
                                left: leftAnchor,
                                paddingTop: -24, paddingLeft: 8)

        profileImageView.setDimensions(width: 80, height: 80)
        profileImageView.layer.cornerRadius = 80 / 2
        
        addSubview(editProfileOrFollowButton)
        editProfileOrFollowButton.anchor(top: containerView.bottomAnchor,
                                         right: rightAnchor,
                                         paddingTop: 12, paddingRight: 12)
        
        editProfileOrFollowButton.setDimensions(width: 100, height: 36)
        editProfileOrFollowButton.layer.cornerRadius = 36 / 2
        
        let userDetailStackView = UIStackView(arrangedSubviews: [fullnameLabel,
                                                                 usernameLabel,
                                                                 bioLabel])
        userDetailStackView.axis = .vertical
        userDetailStackView.distribution = .fillProportionally
        userDetailStackView.spacing = 4
        
        addSubview(userDetailStackView)
        userDetailStackView.anchor(top: profileImageView.bottomAnchor,
                                   left: leftAnchor, right: rightAnchor,
                                   paddingTop: 8, paddingLeft: 12, paddingRight: 12)
        
        let followStack = UIStackView(arrangedSubviews: [followingLabel,
                                                         followersLabel])
        followStack.axis = .horizontal
        followStack.distribution = .fillEqually
        followStack.spacing = 8
        
        addSubview(followStack)
        followStack.anchor(top: userDetailStackView.bottomAnchor,
                           left: leftAnchor,
                           paddingTop: 8, paddingLeft: 12)
        
        addSubview(filterBar)
        filterBar.anchor(left: leftAnchor, bottom: bottomAnchor,
                         right: rightAnchor, height: 50)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selectors
    
    @objc func handleBackButtonTapped() {
        delegate?.handleDismissal()
    }
    
    @objc func handleEditProfileFollow() {
        print("DEBUG: handleEditProfileFollow")
        delegate?.handleEditProfileFollow(self)
    }
    
    @objc func handleFollowingTapped() {
        print("DEBUG: handleFollowingTapped")
    }
    
    @objc func handleFollowersTapped() {
        print("DEBUG: handleFollowingTapped")
    }

    // MARK: - Helpers
    
    func configure() {
        guard let user = user else { return }
        let profileHeaderViewModel = ProfileHeaderViewModel(user: user)
        
        profileImageView.sd_setImage(with: user.profileImageUrl)
        
        editProfileOrFollowButton.setTitle(profileHeaderViewModel.actionButtonTitle,
                                           for: .normal)
        
        followingLabel.attributedText = profileHeaderViewModel.followingString
        followersLabel.attributedText = profileHeaderViewModel.followersString
        
        fullnameLabel.text = user.fullname
        usernameLabel.text = profileHeaderViewModel.usernameText
        bioLabel.text = user.bio
    }
}



// MARK: - ProfileFilterViewDelegate

extension ProfileHeader: ProfileFilterViewDelegate {
    func filterView(_ view: ProfileFilterView, didSelect index: Int) {
        guard let filter = ProfileFilterOptions(rawValue: index) else { return }
        delegate?.didSelect(filter: filter)
    }
}
