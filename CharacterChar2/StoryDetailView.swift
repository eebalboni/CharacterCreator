//
//  StoryDetailView.swift
//  CharacterChar2
//
//  Created by Emily Balboni on 4/22/24.
//

import SwiftUI
import UIKit
//https://developer.apple.com/documentation/swiftui/nsviewcontrollerrepresentablecontext/coordinator
//https://developer.apple.com/tutorials/swiftui/interfacing-with-uikit
//view displays story details (character objects for each story)
struct StoryDetailView: View {
    //used to keep track of what story has been selected from the stories view
    let story: Story?
    @Binding var stories: [Story]
    @AppStorage("characters") private var storedCharactersData:Data?
    //variables set to a default value and then used to create character
    @State private var newCharacterName = ""
    @State private var newCharacterAge = 0
    @State private var newCharacterDescription = ""
    @State private var newCharacterHome = ""
    @State private var isCharacterSheetPresented = false
    
    @State private var showingImagePicker = false
    @State private var selectedImage: UIImage?
    @State private var selectedProfileImage: ProfileImage?
    var body: some View {
        if let story = story {
            //displaying the character and their attributes
            VStack {
                List {
                    ForEach(story.characters) { character in
                        HStack{
                            Image(uiImage: character.profile.image).resizable().frame(width:50,height:50)
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
                    loadCharacters()
                }
                Button("Add Character"){
                    isCharacterSheetPresented.toggle()
                }.sheet(isPresented:$isCharacterSheetPresented){
                    //prompting the user to fill in character details
                    VStack {
                        Text("Enter Character Information").font(.headline)
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
                        Button("Select Image") {
                                        showingImagePicker.toggle()
                                    }
                                    .padding()
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(8)
                                    .padding()
                                    .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
                                        ImagePicker(selectedImage: $selectedImage)
                                    }

                                    if let image = selectedImage {
                                        Image(uiImage: image)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 200, height: 200)
                                            .padding()
                                    }
                        Button(action: {
                            addCharacter()
                        }) {
                            Text("Submit Character").padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                                .padding()
                        }
                        .padding()
                        Button("Exit"){
                            isCharacterSheetPresented = false
                        }.padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                            .padding()
                    }
                }
        }.navigationTitle(story.storyTitle)
        } else {
            EmptyView()
        }
    }
    //adding a new character to a story
    private func addCharacter() {
        guard let index = stories.firstIndex(where:{ $0.uniqueId == story?.uniqueId }) else {
            return
        }
        //Add logic to get description from user input
        let newChar = StoryCharacter(name: newCharacterName, age: newCharacterAge, home: newCharacterHome, description: newCharacterDescription, profile:selectedProfileImage!)

        stories[index].characters.append(newChar)
        saveCharacters()
        //resetting all the variables used for creating a new character to their default value
        newCharacterName = ""
        newCharacterAge = 0
        newCharacterHome=""
        newCharacterDescription=""
    }
    
    //saves characters to app storage
    private func saveCharacters() {
        if let encodedData = try? JSONEncoder().encode(stories) {
            UserDefaults.standard.set(encodedData, forKey: "stories")
            storedCharactersData = encodedData
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
    
    //this is what changes the image the user selects to the ProfileImage class that is needed
    func loadImage() {
        guard let selectedImage = selectedImage else {
            return
        }
        selectedProfileImage = ProfileImage(selectedImage)
    }
    
    
    //needs to reload characters when updates happen
    private func loadCharacters() {
//        if let storedCharactersData = storedCharactersData {
//              if let decodedCharacters = try? JSONDecoder().decode([StoryCharacter].self, from: storedCharactersData) {
//                  if let index = stories.firstIndex(where: { $0.uniqueId == story.uniqueId }) {
//                      stories[index].characters = decodedCharacters
//                  }
//              }
//          }
    }
}

//this will allow the user to pick an image from their camera roll
//this is a custom type in order to accomodate the profileimage object that I use for characters
//this is representing a UIKit
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    
    //this class is used to create an object
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        @Binding var selectedImage: UIImage?

        //this is how the image is sent back to the story detail view
        init(selectedImage: Binding<UIImage?>) {
            _selectedImage = selectedImage
        }

        //this is what controls the user picking their image 
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                selectedImage = uiImage
            }
            picker.dismiss(animated: true, completion: nil)
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true, completion: nil)
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(selectedImage: $selectedImage)
    }

    //
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }

    //this function follows the UIViewController class but isn't used because there is no updating
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
    }
}
