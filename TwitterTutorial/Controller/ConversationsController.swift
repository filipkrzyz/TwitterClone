//
//  ConversationsController.swift
//  TwitterTutorial
//
//  Created by Filip Krzyzanowski on 31/08/2020.
//  Copyright © 2020 Filip Krzyzanowski. All rights reserved.
//

import Foundation
import UIKit

class ConversationsController: UIViewController {
    
    // MARK: - Properties
    
    // MARK: - Lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
    }

    // MARK: - Helpers
    
    func configureUI() {
        view.backgroundColor = .white
        navigationItem.title = "Conversations"
    }
}
