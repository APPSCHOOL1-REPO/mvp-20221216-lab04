//
//  PostStore.swift
//  Otdo
//
//  Created by 이민경 on 2022/12/20.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import UIKit

class PostStore : ObservableObject {
    @Published var posts : [Post] = []
    let database = Firestore.firestore()
    
    private var storage = Storage.storage()
    
    
    
    func fetchPost() {
        print("fetch!")
        database.collection("Posts")
            .order(by: "createdDate", descending: true)
            .getDocuments{ (snapshot, error ) in
                self.posts.removeAll()
//                self.uiImage.removeAll()
                if let snapshot {
                    for document in snapshot.documents {
                        let id = document["id"] as? String ?? ""
                        let userId = document["userId"] as? String ?? ""
                        let content = document["content"] as? String ?? ""
                        let nickName = document["nickName"] as? String ?? ""
                        let image = document["image"] as? String ?? ""
                        let likes = document["likes"] as? [String:Bool] ?? [:]
                        let temperature = document["temperature"] as? Double ?? 0.0
                        let createdAt = document["createdAt"] as? Double ?? 0.0
                        // let postImage = document["postImage"] as? UIImage ?? nil
            
                        self.posts.append(Post(id: id, userId: userId, nickName: nickName, content: content, image: image, likes: likes, temperature: temperature, createdAt: createdAt))
                        
                    }
                    print(self.posts)
                }
            }
    }
    
    func addPost(newPost: Post) {
        Task {
            do {
                
                let _ = try await database.collection("Posts")
                    .document("\(newPost.id)")
                    .setData(["id": newPost.id,
                              "userId": newPost.userId,
                              "nickName": newPost.nickName,
                              "content": newPost.content,
                              "image": newPost.image,
                              "likes": newPost.likes,
                              "temperature": newPost.temperature,
                              "createdAt": newPost.createdAt,
                              "createdDate": newPost.createdDate
                             ])
            } catch {
                await MainActor.run(body: {
                    print("\(error.localizedDescription)")
                })
            }
        }
        fetchPost()
    }
    
    func removePost(_ post:Post) {
        database.collection("Posts").document(post.id).delete()
        { error in
            if let error = error {
                print("Error removing document: \(error)")
            } else {
                print("Document successfully removed!")
            }
        }
        
        let imagesRef = storage.reference().child("images/\(post.id)")
        imagesRef.delete { error in
            if let error = error {
                print("Error removing image from storage: \(error.localizedDescription)")
            }
        }
        fetchPost()
    }
    
    func updatePost(_ post: Post) {
        database.collection("Posts").document(post.id).updateData([
            "id": post.id,
            "userId": post.userId,
            "content": post.content,
            "nickName": post.nickName,
            "image": post.image,
            "likes": post.likes,
            "temperature": post.temperature,
            "createdAt": post.createdAt,
            "createdDate": post.createdDate
        ], completion: { error in
            if let error {
                print(error)
            }
        })
        fetchPost()
    }
    
    // 사진 업로드
    func uploadImage(postId: String, image: Data?, name: String) {
        let storageRef = storage.reference().child("images/\(post)/\(name)") //images/postId/imageName
        let data = image
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"
        
        if let data = data{
            storageRef.putData(data, metadata: metadata) {(metadata, error) in
                if let error = error {
                    print("Error: \(error)")
                }
                if let metadata = metadata {
                    print("metadata: \(metadata)")
                }
            }
        }
    }
    
    // 사진 불러오기
    func fetchImage(postId: String, imageName: String){
        let ref = storage.reference().child("images/\(postId)/\(imageName)")
        
        ref.get
                
                
                // posts배열 중에 postId가 동일한 postImage라는 항목에 Image를 할당해준다.
                
            }
        }
    }
}

