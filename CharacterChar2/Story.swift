//
//  Story.swift
//  CharacterChar2
//
//  Created by Emily Balboni on 4/22/24.
//

import Foundation
import SwiftUI

//story object, has story title & id, list of characters
struct Story: Identifiable, Codable {
    var uniqueId: Int
    var storyTitle: String
    var characters: [StoryCharacter]

    var id: Int {
        return uniqueId
    }

}
