//
//  SettingsVC.swift
//  BuffaloChicken
//
//  Created by Sam Doggett on 11/10/20.
//  Copyright © 2020 Sam Doggett. All rights reserved.
//

import UIKit

class SettingsVC: UIViewController {
    private lazy var mainStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        return stack
    }()
    
    private lazy var testingModeStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        return stack
    }()
    
    private lazy var testingModeLabel: UILabel = {
        let label = UILabel()
        label.text = "Testing enabled: "
        return label
    }()
    
    private lazy var testingModeSwitch: UISwitch = {
        let s = UISwitch()
        s.isOn = UserDefaults.standard.bool(forKey: .isTestingKey)
        return s
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.title = "Settings"

        setupSubviews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        mainStack.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        mainStack.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        mainStack.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        mainStack.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    func setupSubviews() {
        self.view.addSubview(mainStack)
        mainStack.addArrangedSubview(testingModeStack)
        testingModeStack.addArrangedSubview(testingModeLabel)
        testingModeStack.addArrangedSubview(testingModeSwitch)
    }
}
