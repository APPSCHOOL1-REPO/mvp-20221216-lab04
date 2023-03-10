//
//  PostAddView.swift
//  Otdo
//
//  Created by 박성민 on 2022/12/19.
//

import SwiftUI
import PhotosUI

struct PostAddView: View {
    @EnvironmentObject var postStore: PostStore
    @EnvironmentObject var userInfoStore: UserInfoStore
    
    @Binding var isShowingAdd: Bool
    
    @State private var title: String = ""
    @State private var content: String = ""
    @State private var location: String = ""
    @State private var showingAlert = false
    @State private var selectedImage: PhotosPickerItem? = nil
    @State private var selectedImageData: Data? = nil

    var body: some View {
        VStack {
            PhotosPicker(
                selection: $selectedImage,
                matching: .images,
                photoLibrary: .shared()) {
                    if selectedImageData == nil {
                        Text("이미지를 선택해주세요")
                            .font(.largeTitle)
                            .frame(width: UIScreen.main.bounds.size.width * 0.6, height: UIScreen.main.bounds.size.height * 0.45)
                            .padding(20)
                    } else {
                        if let selectedImageData,
                           let uiImage = UIImage(data: selectedImageData) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .frame(width: UIScreen.main.bounds.size.width * 0.6, height: UIScreen.main.bounds.size.height * 0.45)
                                .border(.gray.opacity(1))
                                .padding(20)
                        }
                    }
                }
                .onChange(of: selectedImage) { newItem in
                    Task {
                        // Retrieve selected asset in the form of Data
                        if let data = try? await newItem?.loadTransferable(type: Data.self) {
                            selectedImageData = data
                        }
                    }
                }
            
           
            
            VStack(alignment: .leading) {
                Divider()
                TextField("내용을 입력해주세요", text: $content)
                    .frame(height: 100)
                    .padding(.leading,5)
                Divider()
                Text("위치추가")
                    .foregroundColor(.gray)
                    .padding(.leading,5)
                Divider()
            }
            .padding()
            
            Button {
                if selectedImageData != nil {
                    for user in userInfoStore.users {
                        if user.id == userInfoStore.currentUser?.uid {
                            let id: String = UUID().uuidString
                            let createdAt = Date().timeIntervalSince1970
                            let imageName: String = UUID().uuidString
                            let post: Post = Post(id: id, userId: userInfoStore.currentUser?.uid ?? "", nickName: user.nickName, content: content, image: imageName, likes: [:], temperature: 2.0, createdAt: createdAt)
                            postStore.uploadImage(image: selectedImageData, postImage: imageName)
                            postStore.addPost(post)
                            //                        for post in postStore.posts {
                            //                            postStore.retrievePhotos(post)
                            //                        }
                            //                        postStore.fetchPost()
                            
                        }
                    }
                    isShowingAdd.toggle()
                }
                else {
                    showingAlert.toggle()
                }
            } label: {
                ZStack{
                    Rectangle()
                        .foregroundColor(.gray)
                        .cornerRadius(20)
                        .frame(width: UIScreen.main.bounds.size.width * 0.9, height: UIScreen.main.bounds.size.height * 0.07)
                    Text("게시물 추가")
                        .foregroundColor(.white)
                }
            }
            .alert("사진을 선택해 주세요", isPresented: $showingAlert){
                Button("확인", role: .cancel){
                    showingAlert.toggle()
                    
                }
            }
        }
        .onAppear {
            // userInfoStore.fetchUser()
        }
    }
}

//struct PostAddView_Previews: PreviewProvider {
//    static var previews: some View {
//        PostAddView()
//    }
//}
