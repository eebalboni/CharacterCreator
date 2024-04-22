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
                ZStack {
                    VStack(spacing: 30) {
                        NavigationLink(destination: MyStories()) {
                            HStack{
//                                Image(systemName:"books.vertical")
//                                    .resizable()
//                                    .frame(width: 50, height: 50)
//                                    .foregroundColor(.black).padding(.trailing)
                                Text("My Stories")
                                    .frame(width: 300, height: 100)
                                    .foregroundColor(.black)
                                    .background(Color.white)
                                    .font(.system(size: 20, weight: .bold))
                            }.cornerRadius(20)
                                .border(Color.black)
                           
                        }
                       
                        NavigationLink(destination: About()) {
                            Text("About the App")
                                .frame(width: 300, height: 100)
                                .foregroundColor(.black)
                                .background(Color.white)
                                .font(.system(size: 20, weight: .bold))
                                .cornerRadius(20)
                                .border(Color.black)
                        }
                    }
                }
            }
        }
}

struct HomePagePreviews: PreviewProvider {
    static var previews: some View {
        HomePage()
    }
}

