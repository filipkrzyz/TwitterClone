//
//  TweetHeader.swift
//  TwitterTutorial
//
//  Created by Filip Krzyzanowski on 30/09/2020.
//  Copyright © 2020 Filip Krzyzanowski. All rights reserved.
//

import UIKit
import ActiveLabel

protocol TweetHeaderDelegate: AnyObject {
    func showActionSheet()
    func handleFetchUser(withUsername username: String)
}

class TweetHeader: UICollectionReusableView {
    
    
    // MARK: - Properties
    
    var tweet: Tweet? {
        didSet {
            configure()
        }
    }
    
    weak var delegate: TweetHeaderDelegate?
    
    private let replyLabel: ActiveLabel = {
        let label = ActiveLabel()
        label.textColor = .lightGray
        label.mentionColor = .twitterBlue
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.setDimensions(width: 48, height: 48)
        imageView.layer.cornerRadius = 48 / 2
        imageView.backgroundColor = .twitterBlue
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleProfileImageTapped))
        imageView.addGestureRecognizer(tap)
        imageView.isUserInteractionEnabled = true
        
        return imageView
    }()
    
    private let fullnameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.text = "Full Name"
        return label
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .lightGray
        label.text = "username"
        return label
    }()
    
    private let captionLabel: ActiveLabel = {
        let label = ActiveLabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.numberOfLines = 0
        label.mentionColor = .twitterBlue
        label.hashtagColor = .twitterBlue
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .left
        label.text = "21:00 23/07/2020"
        return label
    }()
    
    private lazy var optionsButton: UIButton = {
        let button = UIButton()
        button.tintColor = .lightGray
        button.setImage(UIImage(named: "down_arrow_24pt"), for: .normal)
        button.addTarget(self, action: #selector(showActionSheet), for: .touchUpInside)
        return button
    }()
    
    private lazy var retweetsLabel = UILabel()
    private lazy var likesLabel = UILabel()
    
    private lazy var statsView: UIView = {
        let view = UIView()
        
        let topSeparator = UIView()
        topSeparator.backgroundColor = .systemGroupedBackground
        view.addSubview(topSeparator)
        topSeparator.anchor(top: view.topAnchor,
                            left: view.leftAnchor, right: view.rightAnchor,
                            paddingLeft: 8, height: 1.0)
        
        let stack = UIStackView(arrangedSubviews: [retweetsLabel, likesLabel])
        stack.axis = .horizontal
        stack.spacing = 12
        
        view.addSubview(stack)
        stack.centerY(inView: view)
        stack.anchor(left: view.leftAnchor, paddingLeft: 16)
        
        let bottomSeparator = UIView()
        bottomSeparator.backgroundColor = .systemGroupedBackground
        view.addSubview(bottomSeparator)
        bottomSeparator.anchor(left: view.leftAnchor, bottom: view.bottomAnchor,
                               right: view.rightAnchor,
                               paddingLeft: 8, height: 1.0)
        
        return view
    }()
    
    private lazy var replyButton: UIButton = {
        let button = self.createButton(withImageName: "comment")
        button.addTarget(self, action: #selector(handleReplyTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var retweetButton: UIButton = {
        let button = self.createButton(withImageName: "retweet")
        button.addTarget(self, action: #selector(handleRetweetTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var likeButton: UIButton = {
        let button = self.createButton(withImageName: "like")
        button.addTarget(self, action: #selector(handleLikeTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var shareButton: UIButton = {
        let button = self.createButton(withImageName: "share")
        button.addTarget(self, action: #selector(handleShareTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        let userInfoStack = UIStackView(arrangedSubviews: [fullnameLabel, usernameLabel])
        userInfoStack.axis = .vertical
        userInfoStack.spacing = -6
        
        let imageUserInfoStack = UIStackView(arrangedSubviews: [profileImageView, userInfoStack])
        imageUserInfoStack.spacing = 12
        
        let replyImageUserInfoStack = UIStackView(arrangedSubviews: [replyLabel, imageUserInfoStack])
        replyImageUserInfoStack.axis = .vertical
        replyImageUserInfoStack.spacing = 8
        replyImageUserInfoStack.distribution = .fillProportionally
        
        addSubview(replyImageUserInfoStack)
        replyImageUserInfoStack.anchor(top: topAnchor, left: leftAnchor,
                                       paddingTop: 16, paddingLeft: 16)
        
        addSubview(captionLabel)
        captionLabel.anchor(top: replyImageUserInfoStack.bottomAnchor,
                            left: leftAnchor, right: rightAnchor,
                            paddingTop: 12, paddingLeft: 16, paddingRight: 16)
        
        addSubview(dateLabel)
        dateLabel.anchor(top: captionLabel.bottomAnchor, left: leftAnchor,
                         paddingTop: 20, paddingLeft: 16)
        
        addSubview(optionsButton)
        optionsButton.centerY(inView: replyImageUserInfoStack)
        optionsButton.anchor(right: rightAnchor, paddingRight: 8)
        
        addSubview(statsView)
        statsView.anchor(top: dateLabel.bottomAnchor,
                         left: leftAnchor, right: rightAnchor,
                         paddingTop: 12, height: 40)
        
        let actionStack = UIStackView(arrangedSubviews: [replyButton, retweetButton,
                                                         likeButton, shareButton])
        actionStack.spacing = 72
    
        addSubview(actionStack)
        actionStack.centerX(inView: self)
        actionStack.anchor(top: statsView.bottomAnchor, paddingTop: 16)
        
        configureMentionHandler()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selectors
    
    @objc func handleProfileImageTapped() {
        print("DEBUG: Profile image tapped")
        //delegate?.handleProfileImageTapped(self)
    }
    
    @objc func showActionSheet() {
        delegate?.showActionSheet()
    }
    
    @objc func handleReplyTapped() {
        print("DEBUG: Reply button tapped")
    }
    
    @objc func handleRetweetTapped() {
        print("DEBUG: Retweet button tapped")
    }
    
    @objc func handleLikeTapped() {
        print("DEBUG: Like button tapped")
    }
    
    @objc func handleShareTapped() {
        print("DEBUG: Share button tapped")
    }
    
    // MARK: - Helpers

    func configure() {
        guard let tweet = tweet else { return }
        
        let tweetViewModel = TweetViewModel(tweet: tweet)
        
        captionLabel.text = tweet.caption
        fullnameLabel.text = tweet.user.fullname
        usernameLabel.text = tweetViewModel.usernameText
        profileImageView.sd_setImage(with: tweetViewModel.profileImageUrl)
        dateLabel.text = tweetViewModel.headerTimestamp
        retweetsLabel.attributedText = tweetViewModel.retweetAtributedString
        likesLabel.attributedText = tweetViewModel.likesAtributedString
        likeButton.tintColor = tweetViewModel.likeButtonTintColor
        likeButton.setImage(tweetViewModel.likeButtonImage, for: .normal)
        
        replyLabel.isHidden = tweetViewModel.shouldHideReplyLabel
        replyLabel.text = tweetViewModel.replyText
    }
    
    func createButton(withImageName imageName: String) -> UIButton {
        let button = UIButton()
        button.setImage(UIImage(named: imageName), for: .normal)
        button.tintColor = .darkGray
        button.setDimensions(width: 20, height: 20)
        return button
    }
    
    func configureMentionHandler() {
        captionLabel.handleMentionTap { username in
            self.delegate?.handleFetchUser(withUsername: username)
        }
        
        replyLabel.handleMentionTap { username in
            self.delegate?.handleFetchUser(withUsername: username)
        }
    }

}
