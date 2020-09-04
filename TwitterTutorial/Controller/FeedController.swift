//
//  FeedController.swift
//  TwitterTutorial
//
//  Created by Filip Krzyzanowski on 31/08/2020.
//  Copyright © 2020 Filip Krzyzanowski. All rights reserved.
//

import Foundation
import UIKit

class FeedController: UIViewController {
    
    // MARK: - Properties
    
    // MARK: - Lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
    }

    // MARK: - Helpers
    
    func configureUI() {
        view.backgroundColor = .white
        
        let imageView = UIImageView(image: UIImage(named: "twitter_logo_blue"))
        imageView.contentMode = .scaleAspectFit
        navigationItem.titleView = imageView
    }
    
}
