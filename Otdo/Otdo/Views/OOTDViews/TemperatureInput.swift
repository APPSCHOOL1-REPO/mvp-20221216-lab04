//
//  TemperatureInput.swift
//  Otdo
//
//  Created by do hee kim on 2022/12/21.
//

import SwiftUI

struct TemperatureInput: View {
    @EnvironmentObject var postStore: PostStore
    
    @Binding var lowTemp: String
    @Binding var highTemp: String
    
    var body: some View {
        VStack {
                
            HStack {
                Text("온도 선택")
                    .font(.title3)
                    .bold()
                    .padding(.trailing, 10)
                    
                TextField("최저", text: $lowTemp)
                    .frame(width: 40)
                    .textFieldStyle(.roundedBorder)
                Text("℃   ~  ")
                    .padding(.leading, -6)
                TextField("최저", text: $highTemp)
                    .frame(width: 40)
                    .textFieldStyle(.roundedBorder)
                Text("℃")
                    .padding(.leading, -6)
                Button {
                    postStore.fetchPostByTemperature(lowTemperature: lowTemp, highTemperature: highTemp)
                } label: {
                    Text("설정")
                        .foregroundColor(Color.white)
                        .padding(10)
                }
                .background(.black)
                .cornerRadius(10)
                .padding(.leading, 10)
            }
        }
    }
}

//struct TemperatureInput_Previews: PreviewProvider {
//    static var previews: some View {
//        TemperatureInput()
//    }
//}