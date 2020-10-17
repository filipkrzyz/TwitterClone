//
//  TweetCell.swift
//  TwitterTutorial
//
//  Created by Filip Krzyzanowski on 07/09/2020.
//  Copyright © 2020 Filip Krzyzanowski. All rights reserved.
//

import UIKit

protocol TweetCellDelegate: AnyObject {
    func handleProfileImageTapped(_ cell: TweetCell)
    func handleReplyTapped(_ cell: TweetCell)
    func handleLikeTapped(_ cell: TweetCell)
}

class TweetCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    var tweet: Tweet? {
        didSet {
            configure()
        }
    }
    
    weak var delegate: TweetCellDelegate?
    
    private let replyLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
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
    
    private let infoLabel = UILabel()
    
    private let captionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var replyButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "comment"), for: .normal)
        button.tintColor = .darkGray
        button.setDimensions(width: 20, height: 20)
        button.addTarget(self, action: #selector(handleReplyTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var retweetButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "retweet"), for: .normal)
        button.tintColor = .darkGray
        button.setDimensions(width: 20, height: 20)
        button.addTarget(self, action: #selector(handleRetweetTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var likeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "like"), for: .normal)
        button.tintColor = .darkGray
        button.setDimensions(width: 20, height: 20)
        button.addTarget(self, action: #selector(handleLikeTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var shareButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "share"), for: .normal)
        button.tintColor = .darkGray
        button.setDimensions(width: 20, height: 20)
        button.addTarget(self, action: #selector(handleShareTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        let infoCaptionStack = UIStackView(arrangedSubviews: [infoLabel, captionLabel])
        infoCaptionStack.axis = .vertical
        infoCaptionStack.distribution = .fillProportionally
        infoCaptionStack.spacing = 4
        
        let imageInfoCaptionStack = UIStackView(arrangedSubviews: [profileImageView, infoCaptionStack])
        imageInfoCaptionStack.distribution = .fillProportionally
        imageInfoCaptionStack.spacing = 12
        imageInfoCaptionStack.alignment = .leading
        
        let replyImageInfoCaptionStack = UIStackView(arrangedSubviews: [replyLabel, imageInfoCaptionStack])
        replyImageInfoCaptionStack.axis = .vertical
        replyImageInfoCaptionStack.spacing = 8
        replyImageInfoCaptionStack.distribution = .fillProportionally
        
        addSubview(replyImageInfoCaptionStack)
        replyImageInfoCaptionStack.anchor(top: topAnchor, left: leftAnchor,
        right: rightAnchor, paddingTop: 4,
        paddingLeft: 12, paddingRight: 12)
        
        let actionStack = UIStackView(arrangedSubviews: [replyButton, retweetButton,
                                                         likeButton, shareButton])
        actionStack.axis = .horizontal
        actionStack.spacing = 72
        
        addSubview(actionStack)
        actionStack.centerX(inView: self)
        actionStack.anchor(bottom: bottomAnchor, paddingBottom: 8)
        
        let underlineView = UIView()
        underlineView.backgroundColor = .systemGroupedBackground
        
        addSubview(underlineView)
        underlineView.anchor(left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, height: 1)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selectors
    
    @objc func handleProfileImageTapped() {
        print("DEBUG: Profile image tapped")
        delegate?.handleProfileImageTapped(self)
    }
    
    @objc func handleReplyTapped() {
        print("DEBUG: Reply tapped")
        delegate?.handleReplyTapped(self)
    }
    
    @objc func handleRetweetTapped() {
        print("DEBUG: Retweet tapped")
    }
    
    @objc func handleLikeTapped() {
        delegate?.handleLikeTapped(self)
    }
    
    @objc func handleShareTapped() {
        print("DEBUG: Share tapped")
    }
    
    // MARK: - Helpers
    
    func configure() {
        guard let tweet = tweet else { return }
        let tweetViewModel = TweetViewModel(tweet: tweet)
        
        profileImageView.sd_setImage(with: tweetViewModel.profileImageUrl)
        infoLabel.attributedText = tweetViewModel.userInfoText
        captionLabel.text = tweet.caption
        
        likeButton.tintColor = tweetViewModel.likeButtonTintColor
        likeButton.setImage(tweetViewModel.likeButtonImage, for: .normal)
        
        replyLabel.isHidden = tweetViewModel.shouldHideReplyLabel
        replyLabel.text = tweetViewModel.replyText
    }
}
