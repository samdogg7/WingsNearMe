//
//  ReusableIdentifier.swift
//  BuffaloChicken
//
//  Created by Sam Doggett on 6/25/20.
//  Copyright © 2020 Sam Doggett. All rights reserved.
//

import Foundation

protocol ReusableIdentifier: class {
    static var reuseIdentifier: String { get }
}

extension ReusableIdentifier {
    static var reuseIdentifier: String {
        return String(describing: Self.self)
    }
}
