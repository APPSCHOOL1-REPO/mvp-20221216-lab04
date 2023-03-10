//
//  OtdoApp.swift
//  Otdo
//
//  Created by BOMBSGIE on 2022/12/19.
//

import SwiftUI
import FirebaseCore


class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}

@main
struct OtdoApp: App {
    
    @StateObject var viewRouter = ViewRouter()
    @StateObject var userInfoStore = UserInfoStore()
    @StateObject var postStore = PostStore()
    @StateObject var commentStore = CommentStore()
    @StateObject var slider = CustomSlider(start: -30, end: 50)


  // register app delegate for Firebase setup
  @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate


  var body: some Scene {
    WindowGroup {
      NavigationView {
          if userInfoStore.currentUser == nil {
              ContentView().environmentObject(viewRouter).environmentObject(userInfoStore).environmentObject(postStore).environmentObject(commentStore)
                  .environmentObject(slider)

          } else {
              MainView().environmentObject(viewRouter).environmentObject(userInfoStore).environmentObject(postStore).environmentObject(commentStore)
                  .environmentObject(slider)
          }
      }
    }
  }
}
