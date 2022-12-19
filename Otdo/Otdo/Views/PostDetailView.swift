//
//  PostDetailView.swift
//  Otdo
//
//  Created by 박성민 on 2022/12/19.
//

import SwiftUI

struct PostDetailView: View {
    var body: some View {
        VStack {
            Image("PostDetailImage")
                .resizable()
                .frame(width: UIScreen.main.bounds.size.width * 0.6, height: UIScreen.main.bounds.size.height * 0.45)
                .border(.gray.opacity(1))
                .padding(20)
            
            HStack {
                Image(systemName: "heart.fill")
                    .padding(.leading)
                    .padding(.trailing, -5)
                Text("1324")
                    .padding(.trailing, -5)
                Image(systemName: "message")
                    .padding(.trailing, -5)
                Text("26")
                Spacer()
                Text("서울시 중랑구")
                    .padding(.trailing)
                    .foregroundColor(.gray)
            }
            HStack {
                VStack(alignment: .leading) {
                    Text("오늘 겁나 추워브러")
                        .font(.title3)
                        .bold()
                        .padding(.leading)
                        .padding(.vertical, -1)
                    Text("얼 죽 코!")
                        .padding(.leading)
                }
                Spacer()
            }
            
            Divider()
            
            ScrollView {
                HStack {
                    Circle()
                        .frame(width: 44)
                    VStack(alignment: .leading) {
                        Text("민콩")
                        Text("이뿌댜앙")
                    }
                    Spacer()
                    Text("2분전")
                        .foregroundColor(.gray)
                }
                .padding(.horizontal)
                HStack {
                    Circle()
                        .frame(width: 44)
                    VStack(alignment: .leading) {
                        Text("민콩")
                        Text("이뿌댜앙")
                    }
                    Spacer()
                    Text("2분전")
                        .foregroundColor(.gray)
                }
                .padding(.horizontal)
                HStack {
                    Circle()
                        .frame(width: 44)
                    VStack(alignment: .leading) {
                        Text("민콩")
                        Text("이뿌댜앙")
                    }
                    Spacer()
                    Text("2분전")
                        .foregroundColor(.gray)
                }
                .padding(.horizontal)
            }
            .padding(.top, 5)
            .padding(.bottom, 10)
        }
    }
}

struct PostDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PostDetailView()
    }
}
