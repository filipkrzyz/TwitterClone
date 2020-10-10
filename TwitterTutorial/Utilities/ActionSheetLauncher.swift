//
//  ActionSheetLauncher.swift
//  TwitterTutorial
//
//  Created by Filip Krzyzanowski on 05/10/2020.
//  Copyright © 2020 Filip Krzyzanowski. All rights reserved.
//

import UIKit

private let actionSheetCellIdentifier = "ActionSheetCell"

protocol ActionSheetLauncherDelegate: AnyObject {
    func didSelect(option: ActionSheetOptions)
}

class ActionSheetLauncher: NSObject {
    
    // MARK: - Properties
    
    private let user: User
    
    private let tableView = UITableView()
    private var tableViewHeight: CGFloat?
    
    private var window: UIWindow?
    
    private lazy var actionSheetViewModel = ActionSheetViewModel(user: user)
    
    weak var delegate: ActionSheetLauncherDelegate?
    
    private lazy var darkView: UIView = {
        let view = UIView()
        view.alpha = 0
        view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleDismissal))
        view.addGestureRecognizer(tap)
        
        return view
    }()
    
    private lazy var footerView: UIView = {
        let view = UIView()
        
        view.addSubview(cancelButton)
        cancelButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        cancelButton.anchor(left: view.leftAnchor, right: view.rightAnchor,
                            paddingLeft: 12, paddingRight: 12)
        cancelButton.centerY(inView: view)
        cancelButton.layer.cornerRadius = 50 / 2
        
        return view
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Cancel", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .systemGroupedBackground
        button.addTarget(self, action: #selector(handleDismissal), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    
    init(user: User){
        self.user = user
        super.init()
        self.configureTableView()
    }
    
    // MARK: - Helpers
    
    func showTableView(_ shouldShow: Bool) {
        guard let window = window else { return }
        guard let height = self.tableViewHeight else { return }
        let y = shouldShow ? window.frame.height - height : window.frame.height
        tableView.frame.origin.y = y
    }
    
    func show() {
        print("DEBUG: Show action sheet for user: @\(user.username)")
        
        guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else { return }
        self.window = window
        
        window.addSubview(darkView)
        darkView.frame = window.frame
        
        window.addSubview(tableView)
        let height = CGFloat(actionSheetViewModel.options.count * 60) + 100
        self.tableViewHeight = height
        tableView.frame = CGRect(x: 0, y: window.frame.height,
                                 width: window.frame.width, height: height)
        
        UIView.animate(withDuration: 0.5) {
            self.darkView.alpha = 1
            self.showTableView(true)
        }
    }
    
    func configureTableView() {
        tableView.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 60
        tableView.separatorStyle = .none
        tableView.layer.cornerRadius = 5
        tableView.isScrollEnabled = false
        
        tableView.register(ActionSheetCell.self, forCellReuseIdentifier: actionSheetCellIdentifier)
    }
    
    // MARK: - Selectors
    
    @objc func handleDismissal() {
        UIView.animate(withDuration: 0.5) {
            self.darkView.alpha = 0
            self.showTableView(false)
        }
    }
}

// MARK: - UITableViewDataSource

extension ActionSheetLauncher: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return actionSheetViewModel.options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: actionSheetCellIdentifier, for: indexPath) as! ActionSheetCell
        cell.option = actionSheetViewModel.options[indexPath.row]
        return cell
    }
}

// MARK: - UITableViewDelegate

extension ActionSheetLauncher: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let option = actionSheetViewModel.options[indexPath.row]
        
        UIView.animate(withDuration: 0.5, animations: {
            self.darkView.alpha = 0
            self.showTableView(false)
        }) { _ in
            self.delegate?.didSelect(option: option)
        }
        
    }
}