//
//  Characters.swift
//  CharacterChar2
//
//  Created by Emily Balboni on 4/22/24.
//

import Foundation
import SwiftUI

// character object, has name, age, home, description
struct StoryCharacter: Codable, Identifiable {
    var id = UUID()
    var name: String
    var age: Int
    var home: String
    var description: String
    var profile: ProfileImage
    }

