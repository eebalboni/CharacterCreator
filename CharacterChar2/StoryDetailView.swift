//
//  StoryDetailView.swift
//  CharacterChar2
//
//  Created by Emily Balboni on 4/22/24.
//

import SwiftUI

//view displays story details (character objects for each story)
struct StoryDetailView: View {
    //used to keep track of what story has been selected from the stories view
    let story: Story?
    @Binding var stories: [Story]
    //variables set to a default value and then used to create character
    @State private var newCharacterName = ""
    @State private var newCharacterAge = 0
    @State private var newCharacterDescription = ""
    @State private var newCharacterHome = ""
    //displaying the characters
    var body: some View {
        if let story = story {
            //displaying the character and their attributes
            VStack {
                List {
                    ForEach(story.characters) { character in
                        HStack{
                            Image(uiImage: character.profile.image).resizable().frame(width:25,height:25)
                            VStack(alignment: .leading) {
                                Text("Name: " + character.name)
                                    .font(.headline)
                                Text("Age: " + String(character.age)).font(.body)
                                Text("Description: " + character.description)
                                    .font(.body)
                                Text("Origin: " + character.home)
                                    .font(.body)
                                
                            }
                            .padding(.trailing)
                        }
                        
                    }
                    //calling method to delete list item from storage
                    .onDelete(perform: deleteCharacter)
                }.onAppear {
                  
                }
                //prompting the user to fill in character details
                VStack {
                    TextField("Enter character name", text: $newCharacterName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    TextField("Enter character description",text:$newCharacterDescription).textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    TextField("Enter character's age", value: $newCharacterAge, formatter: NumberFormatter())
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    TextField("Enter character's home",text:$newCharacterHome).textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    
                    Button(action: {
                        addCharacter()
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .frame(width: 25, height: 25)
                            .foregroundColor(.blue)
                    }
                    .padding()
                }
            }
            .navigationTitle(story.storyTitle)
        } else {
            EmptyView()
        }
    }
    //adding a new character to a story
    private func addCharacter() {
        guard let index = stories.firstIndex(where:
                                            
            { $0.uniqueId == story?.uniqueId }) else {
            return
        }
         //Add logic to get description from user input
        let newChar = Characters(name: newCharacterName, age: newCharacterAge, home: newCharacterHome, description: newCharacterDescription,profile:ProfileImage(#imageLiteral(resourceName: "IMG_9581_Original.JPG")))
        stories[index].characters.append(newChar)
        
        //resetting all the variables used for creating a new character to their default value
        newCharacterName = ""
        newCharacterAge = 0
        newCharacterHome=""
        newCharacterDescription=""
        saveCharacters()
    }

    //saves characters to app storage
    private func saveCharacters() {
        if let encodedData = try? JSONEncoder().encode(stories) {
            UserDefaults.standard.set(encodedData, forKey: "stories")
        }
    }
    //removing characters from app storage
    private func deleteCharacter(at offsets: IndexSet) {
        guard let index = stories.firstIndex(where: { $0.uniqueId == story?.uniqueId }) else {
            return
        }
        stories[index].characters.remove(atOffsets: offsets)
        //saving updated list of characters
        saveCharacters()
    }
    
    //needs to reload characters when updates happen
    private func loadCharacters() {
        //need to use
        }
        
}
