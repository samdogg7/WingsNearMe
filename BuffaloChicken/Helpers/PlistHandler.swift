//
//  PlistHandler.swift
//  BuffaloChicken
//
//  Created by Sam Doggett on 8/23/20.
//  Copyright © 2020 Sam Doggett. All rights reserved.
//

import Foundation

enum PlistFile: String {
    case api = "ApiKeys"
}

class PlistHandler {
    static func getPlist<File:PlistModel>(named: PlistFile, fileType: File.Type) -> File? {
        if let path = Bundle.main.path(forResource: named.rawValue, ofType: "plist"), let xml = FileManager.default.contents(atPath: path) {
            return try? PropertyListDecoder().decode(File.self, from: xml)
        }
        return nil
    }
}
