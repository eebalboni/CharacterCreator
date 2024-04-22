//Open Source Spring 2024
//Emily Balboni
// links: https://developer.apple.com/tutorials/swiftui/building-lists-and-navigation
//https://www.hackingwithswift.com/quick-start/swiftui/how-to-let-users-select-pictures-using-photospicker
//https://www.hackingwithswift.com/new-syntax-swift-2-guard
//https://www.codecademy.com/article/building-lists-in-swiftui
//https://medium.com/@jpmtech/swiftui-list-from-beginner-to-merlin-5308261b78b6
//https://www.reddit.com/r/swift/comments/woiwpd/explain_to_me_like_im_5_what_is_a_binding_and/
//https://stackoverflow.com/questions/58733003/how-to-create-textfield-that-only-accepts-numbers
import SwiftUI
import PhotosUI

struct MyStories: View {
    
    @AppStorage("stories") private var storedStoriesData: Data?
    @State private var stories: [Story] = []
    @State private var newStoryTitle = ""
    
    //checking to see what view should be displayed
    @State private var isCreatingStory = false
    @State private var selectedStory: Story? = nil
    @State private var isDetailViewActive = false
    
    //image picker used to prompt user
    @State private var imagePicker: PhotosPickerItem?
    @State private var selectedImage: Image?

    var body: some View {
        NavigationView {
            VStack {
                Text("My Stories").font(.headline)
                //displaying list of stories and making each a "button"
                //if they are selected brought to another view displaying chosen story title
               
                    List(stories, id: \.uniqueId) { story in
                        Button(action: {
                            selectedStory = story
                            isDetailViewActive = true
                        }) {
                            HStack{
                                Image(systemName: "book.circle").resizable().frame(width:50,height:50)
                                Text(story.storyTitle)
                            }
                           
                        }
                        
                    }
                //if the user is creating a story, this is the field that appears
                HStack{
                    if isCreatingStory {
                        VStack {
                            //prompting the user to enter a new story title
                            TextField("Enter new story title", text: $newStoryTitle)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding()
                            Button(action: {
                                addStory()
                            }) {
                                Image(systemName: "checkmark.circle.fill")
                                    .resizable()
                                    .frame(width: 25, height: 25)
                                    .foregroundColor(.blue)
                            }
                            .padding()
                            PhotosPicker("Select Image", selection: $imagePicker, matching: .images)
                                .padding()
                                .border(Color.black)
                            selectedImage?
                                .resizable()
                                .scaledToFit()
                                .frame(width: 300, height: 300)
                        }
                        .onChange(of: imagePicker) { _ in
                            Task {
                                if let loaded = try? await imagePicker?.loadTransferable(type: Image.self) {
                                    selectedImage = loaded
                                } else {
                                    print("Failed")
                                }
                            }
                        }
                    } else {
                        Button(action: {
                            isCreatingStory = true
                        }) {
                            HStack {
                                Image(systemName: "pencil.line")
                                    .resizable()
                                    .frame(width: 25, height: 25)
                                Text("Create new Story")
                            }
                        }
                        .buttonStyle(BorderlessButtonStyle())
                    }
                }
            }
            .onAppear {
                loadStories()//this causes the page to refresh when a user creates a new story
            }
            .background(
                NavigationLink(
                    destination: StoryDetailView(story: selectedStory, stories: $stories),
                    isActive: $isDetailViewActive,
                    label: {
                        EmptyView()
                    })
            )
        
        }
        .onDisappear {
            selectedStory = nil //this resets the story that was selected
        }
    }

    //adds a new story by setting the title, does not need to prompt user to add characters
    private func addStory() {
        guard !newStoryTitle.isEmpty else {
            return
        }
        //keeping track of index of list
        let newUniqueId = stories.count
        let newStory = Story(uniqueId: newUniqueId, storyTitle: newStoryTitle, characters: [])
        stories.append(newStory)
        //this saves the stories to app storage
        saveStories()
        //resets these values for next story to be created
        newStoryTitle = ""
        isCreatingStory = false
    }

    //this returns the stories saved in app storage when it is called
    private func loadStories() {
        if let storedStoriesData = storedStoriesData {
            if let decodedStories = try? JSONDecoder().decode([Story].self, from: storedStoriesData) {
                stories = decodedStories
                return
            }
        }
        //these are default stories
        stories = [
            Story(uniqueId: 0, storyTitle: "Harry Potter", characters: []),
            Story(uniqueId: 1, storyTitle: "Red Queen", characters: [])
        ]
    }

    //called to save stories in app storage using encoded Data
    private func saveStories() {
        if let encodedData = try? JSONEncoder().encode(stories) {
            storedStoriesData = encodedData
        }
    }
}


struct MyStories_Previews: PreviewProvider {
    static var previews: some View {
        MyStories()
    }
}


