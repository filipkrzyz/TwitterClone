//
//  UploadTweetController.swift
//  TwitterTutorial
//
//  Created by Filip Krzyzanowski on 04/09/2020.
//  Copyright © 2020 Filip Krzyzanowski. All rights reserved.
//

import UIKit
import ActiveLabel

class UploadTweetController: UIViewController {
    
    // MARK: - Properties
    
    private var user: User
    private let uploadTweetConfiguration: UploadTweetConfiguration
    private lazy var uploadTweetViewModel = UploadTweetViewModel(config: uploadTweetConfiguration)
    
    private lazy var tweetReplyButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .twitterBlue
        button.setTitle("Tweet", for: .normal)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitleColor(.white, for: .normal)
        
        button.frame = CGRect(x: 0, y: 0, width: 64, height: 32)
        button.layer.cornerRadius = 32 / 2
        
        button.addTarget(self, action: #selector(handleUploadTweet), for: .touchUpInside)
        return button
    }()
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.setDimensions(width: 48, height: 48)
        imageView.layer.cornerRadius = 48 / 2
        imageView.backgroundColor = .twitterBlue
        return imageView
    }()
    
    private lazy var replyLabel: ActiveLabel = {
        let label = ActiveLabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .lightGray
        label.mentionColor = .twitterBlue
        label.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        return label
    }()
    
    private let captionTextView = CaptionTextView()
    
    // MARK: - Lifecycle
    
    init(user: User, config: UploadTweetConfiguration) {
        self.user = user
        self.uploadTweetConfiguration = config
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureMentionHandler()
    }
    
    // MARK: - Selectors
    
    @objc func handleUploadTweet() {
        guard let caption = captionTextView.text else { return }
        TweetService.shared.uploadTweet(caption: caption, config: uploadTweetConfiguration) { (error, reference) in
            if let error = error {
                print("DEBUG: Uploading tweet failed with error: \(error)")
            }
            
            if case .reply(let tweet) = self.uploadTweetConfiguration {
                NotificationService.shared.uploadNotification(toUser: tweet.user,
                                                              type: .reply,
                                                              tweetID: tweet.tweetID)
            }
            
            self.uploadMentionNotification(forCaption: caption, tweetID: reference.key)
            
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - API
    
    fileprivate func uploadMentionNotification(forCaption caption: String, tweetID: String?) {
        guard caption.contains("@") else { return }
        let words = caption.components(separatedBy: .whitespacesAndNewlines)
        
        words.forEach { word in
            guard word.hasPrefix("@") else { return }
            
            var username = word.trimmingCharacters(in: .symbols)
            username = username.trimmingCharacters(in: .punctuationCharacters)
            
            UserService.shared.fetchUser(withUsername: username) { user in
                NotificationService.shared.uploadNotification(toUser: user,
                                                              type: .mention,
                                                              tweetID: tweetID)
            }
        }
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        view.backgroundColor = .white
        configureNavigationBar()
        
        let imageCaptionStack = UIStackView(arrangedSubviews: [profileImageView, captionTextView])
        imageCaptionStack.axis = .horizontal
        imageCaptionStack.spacing = 12
        imageCaptionStack.alignment = .leading
        
        let replyImageCaptionStack = UIStackView(arrangedSubviews: [replyLabel, imageCaptionStack])
        replyImageCaptionStack.axis = .vertical
        replyImageCaptionStack.spacing = 12
        
        view.addSubview(replyImageCaptionStack)
        replyImageCaptionStack.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                     left: view.leftAnchor, right: view.rightAnchor,
                     paddingTop: 16, paddingLeft: 16, paddingRight: 16)
        
        profileImageView.sd_setImage(with: user.profileImageUrl, completed: nil)
        tweetReplyButton.setTitle(uploadTweetViewModel.actionButtonTitle, for: .normal)
        captionTextView.placeholderLabel.text = uploadTweetViewModel.placeholderText
        
        replyLabel.isHidden = !uploadTweetViewModel.shouldShowReplyLabel
        guard let replyText = uploadTweetViewModel.replyText else { return }
        replyLabel.text = replyText
    }
    
    func configureNavigationBar() {
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.isTranslucent = false
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: tweetReplyButton)
    }
    
    func configureMentionHandler() {
        replyLabel.handleMentionTap { username in
            print("DEBUG: Go to @\(username) profile")
        }
    }
}
