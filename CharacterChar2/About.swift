//
//  About.swift
//  CharacterCreator
//
//  Created by Emily Balboni on 4/1/24.
// https://www.youtube.com/watch?v=iHDUSwkVsL8&t=129s for more list information
// https://www.youtube.com/watch?v=hCpM95KHb_Q for scrollable behavior

import SwiftUI

struct About: View {
    
    var body: some View{
       
        ScrollView{
            VStack(){
                Color.blue.opacity(0.25)
                    .ignoresSafeArea()
                Text("About Character Creator").font(.title).padding()
                Text("For writers it's sometimes difficult to keep track of characters and world building. We've seen this before with Harry Potter, why didn't everyone before the battle of Hogwarts drink liquid luck? Or we've seen this with Friends and Phoebe's parents. They suddenly appear, dissappear after a few episodes, and throughout the seasons Phoebe tells us conflicting stories. This app is intended to help writers avoid plotholes in their stories by providing a centralized location for their notes. This can also be used by D&D players to help keep track of their games. Happy creating! ").padding(.horizontal)
                Text("About the Developer").font(.title).padding()
                Image("Author").resizable().frame(width:250,height:320, alignment:.center)
                Text("Pictured above: My reaction to Dumbledor's death.").font(.caption2).padding(.bottom)
                Text("Hi everyone! My name is Emily and I am a senior Software Engineering Major at QU! Aside from coding, one of my passions is writing. So, when we were tasked to start a project this semester in open source, I wanted to create an application that I would use as a writer. Hopefully one day I will be able to publish my own young adult stories! Until then, I'll be using this to keep track of my characters and I hope I can help any writers or D&D players do the same :)").padding(.horizontal)
            }
            Color.blue.opacity(0.25)
                .ignoresSafeArea()
            .scrollBounceBehavior(.basedOnSize)
        }
        
    }
}
#Preview {
    About()
}
