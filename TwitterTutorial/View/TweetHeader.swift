//
//  TweetHeader.swift
//  TwitterTutorial
//
//  Created by Filip Krzyzanowski on 30/09/2020.
//  Copyright © 2020 Filip Krzyzanowski. All rights reserved.
//

import UIKit

class TweetHeader: UICollectionReusableView {
    
    
    // MARK: - Properties
    
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .systemPurple
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
