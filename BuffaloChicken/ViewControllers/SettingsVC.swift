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
    
    private lazy var doneButton: UIButton = {
        let button = UIButton()
        button.setTitle("Done", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(doneButtonPressed), for: .touchUpInside)
        return button
    }()
    
    private lazy var separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
        s.addTarget(self, action: #selector(testingSwitchToggle), for: .valueChanged)
        return s
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Settings"
        self.view.backgroundColor = .white
        setupSubviews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        doneButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5).isActive = true
        doneButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -5).isActive = true
        doneButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
        doneButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        separatorView.topAnchor.constraint(equalTo: doneButton.bottomAnchor, constant: 5).isActive = true
        separatorView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        separatorView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        separatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true

        mainStack.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 5).isActive = true
        mainStack.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -5).isActive = true
        mainStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 5).isActive = true
        mainStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -5).isActive = true
    }
    
    func setupSubviews() {
        self.view.addSubview(mainStack)
        self.view.addSubview(doneButton)
        self.view.addSubview(separatorView)

        mainStack.addArrangedSubview(testingModeStack)
        testingModeStack.addArrangedSubview(testingModeLabel)
        testingModeStack.addArrangedSubview(testingModeSwitch)
    }
    
    @objc func testingSwitchToggle() {
        UserDefaults.standard.setValue(testingModeSwitch.isOn, forKey: .isTestingKey)
    }
    
    @objc func doneButtonPressed() {
        dismiss(animated: true, completion: nil)
    }
}
