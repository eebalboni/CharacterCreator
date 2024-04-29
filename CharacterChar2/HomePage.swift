//
//  ContentView.swift
//  CharacterCreator
//
//  Created by Emily Balboni on 4/1/24.


import SwiftUI
import PhotosUI
struct HomePage: View {
    @State private var imagePicker: PhotosPickerItem?
    @State private var selectedImage: Image?
    var body: some View{
        NavigationView {
            VStack{
                Image("pencils").resizable().frame(width:400,height:90, alignment:.center).rotationEffect(.degrees(-180)).ignoresSafeArea()
                Rectangle()
                                .frame(height: 0)
                                .background(.ultraThinMaterial)
                VStack(spacing: 30) {
                    NavigationLink(destination: MyStories()) {
                        HStack{
                            Text("My Stories")
                                .frame(width: 300, height: 100)
                                .foregroundColor(.black)
                                .background(Color.white)
                                .font(.system(size: 20, weight: .bold))
                        }.cornerRadius(20)
                            .border(Color.black) .padding([.bottom], 20)
                        
                    }
                    Image("pencils").resizable().frame(width:400,height:90, alignment:.center).rotationEffect(.degrees(-180)).ignoresSafeArea()
                    NavigationLink(destination: About()) {
                        Text("About the App")
                            .frame(width: 300, height: 100)
                            .foregroundColor(.black)
                            .background(Color.white)
                            .font(.system(size: 20, weight: .bold))
                            .cornerRadius(20)
                            .border(Color.black)
                    }
                    Image("pencils").resizable().frame(width:400,height:90, alignment:.center).rotationEffect(.degrees(-180)).ignoresSafeArea()
                }
            }
            .background(LinearGradient(gradient: Gradient(colors: [.blue.opacity(2.0),.blue.opacity(0.5),  .blue.opacity(0.40),.blue.opacity(0.25),.white.opacity(1.0)]), startPoint: .topLeading, endPoint: .bottomTrailing))
                .navigationTitle(Text("Character Creator"))
            
        }
        
        
    }
}

struct HomePagePreviews: PreviewProvider {
    static var previews: some View {
        HomePage()
    }
}

