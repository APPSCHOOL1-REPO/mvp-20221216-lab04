//
//  WeatherView.swift
//  Otdo
//
//  Created by BOMBSGIE on 2022/12/19.
//

import SwiftUI

struct WeatherView: View {
    @EnvironmentObject var postStore: PostStore
    @ObservedObject var weatherStore: WeatherStore = WeatherStore()
    var webService: WebService = WebService()
    let url: String = "https://api.openweathermap.org/data/2.5/weather"
    let regionDic: [String: String] = ["서울": "seoul", "인천": "incheon", "대전": "daejeon", "부산": "busan", "대구": "daegu", "울산": "ulsan", "광주": "gwangju", "제주": "jeju", "수원시": "suwon", "고양시": "goyang", "용인시": "yongin", "성남시": "seongnam", "화성시": "hwaseong"]
    let weatherImage: [String: String] = ["clear": "sun.max.fill", "Clouds": "cloud.fill", "Snow": "snowflake", "Mist": "cloud.fog.fill", "Rain": "cloud.rain.fill"]
    
    @State private var isShowRegionSheet: Bool = false
    @State private var isShowDetailWeatherSheet: Bool = false
    @State private var region: String?
    
    let ranks = ["homeRank", "homeRank", "homeRank", "homeRank", "homeRank"]
    
    var body: some View {
        // 현재 온도 및 소수점 자르기
        let temp: String = String(format: "%.1f", (weatherStore.currentWeatherInfo?.main?.temp ?? 273.15) - 273.15)
        // 최저 온도 및 소수점 자르기
        let tempMin: String = String(format: "%.1f", (weatherStore.currentWeatherInfo?.main?.temp_min ?? 273.15) - 273.15)
        // 최고 온도 및 소수점 자르기
        let tempMax: String = String(format: "%.1f", (weatherStore.currentWeatherInfo?.main?.temp_max ?? 273.15) - 273.15)
        
        ScrollView {
        // 현재 날씨
            VStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 30)
                        .fill(.gray.opacity(0.2))
                    
                    VStack {
                        // 지역 버튼
                        Button(action: {
                            isShowRegionSheet.toggle()
                        }) {
                            HStack {
                                // 현재 위치
                                Text("\(region ?? "서울")")
                                    .font(.title)
                                    .fontWeight(.semibold)
                                Image(systemName: "chevron.down")
                                    .font(.title2)
                            }
                            .foregroundColor(.black)
                        }
                        
                        .sheet(isPresented: $isShowRegionSheet, onDismiss: changeRegion) {
                            SelectRegionView(selectRegion: $region)
                                .presentationDetents([.medium])
                        }
                        
                        // 현재 날씨 표시 및 상세 날씨 보기로 이동
                        Button(action: {
                            isShowDetailWeatherSheet.toggle()
                        }) {
                            VStack(spacing: 8) {
                                Image(systemName: weatherImage[weatherStore.currentWeatherInfo?.weather?[0].main ?? ""] ?? "sun.max.fill")
                                    .renderingMode(.original)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 80)
                                Text("\(temp)°")
                                    .font(.largeTitle)
                                    .fontWeight(.bold)
                                Text(weatherStore.currentWeatherInfo?.weather?[0].description ?? "")
                                    .font(.body)
                                    .foregroundColor(.gray)
                                
                                Text("최고 \(tempMax)° / 최저 \(tempMin)°")
                                    .font(.title3)
                            }
                            .foregroundColor(.black)
                            
                        }
                        .sheet(isPresented: $isShowDetailWeatherSheet, onDismiss: changeRegion) {
                            DetailWeatherView(url: url+"?q=\(regionDic[region ?? "seoul"] ?? "seoul")&appid=da7d02bbb56edde56edb8830de8261df")
                        }
                    }
                    
                    .frame(maxWidth: .infinity)
                }
                .frame(height: 300)
                .padding(.horizontal, 30)
                
                Text("\(temp)℃ 추천 스타일")
                    .font(.title)
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 30)
                    .padding(.bottom, -5)
                // MARK: 최저, 최고 온도 나중에 고치기
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(postStore.posts) { post in
                            if post.temperature > -10 && post.temperature < 5 {
                                RecommendView(post: post)
                            }
                        }
                    }
                }
                .padding(.leading, 30)
                .scrollIndicators(.hidden)
                    
                HStack {
                    Image("ear")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100)
                    Image("padding")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100)
                    Image("coat")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100)
                }
                .padding(.horizontal, 30)
                .padding(.vertical, 15)
                .frame(width: 340)
                .background(.white.opacity(0.4))
                .cornerRadius(30)
                .shadow(radius: 10)
                
                // TOP 10
                VStack(alignment: .leading) {
                    Group{
                        Text("아우터")
                            .font(.title3)
                            .fontWeight(.heavy)
                        Text("패딩, 두꺼운 코트  ")
                            .padding(.bottom, 1)
                        Text("상의")
                            .font(.title3)
                            .fontWeight(.heavy)
                        Text("누빔 옷, 니트, 맨투맨, 후드티 ")
                            .padding(.bottom, 1)
                        Text("하의")
                            .font(.title3)
                            .fontWeight(.heavy)
                        Text("청바지, 히트텍  ")
                        
                    }
                }
                .padding(.horizontal, 30)
                .padding(.vertical, 25)
                .frame(width: 340)
                .background(.white.opacity(0.4))
                .cornerRadius(30)
                .shadow(radius: 10)
                
                
            }
        }
        .onAppear{
            Task {
                let currentLocationUrl = url+"?lat=37.54815556&lon=126.851675&appid=3f9b06947acddcef370b23a5aaaae195"
                weatherStore.currentWeatherInfo = try await webService.currentWeatherfetchData(url: currentLocationUrl)
            }
            
        }

    }
    
    func changeRegion() {
        Task {
            guard let selectRegion = region else { return }
            let regionUrl = url+"?q=\(regionDic[selectRegion] ?? "seoul")&appid=da7d02bbb56edde56edb8830de8261df"
            weatherStore.currentWeatherInfo = try await webService.currentWeatherfetchData(url: regionUrl)
            print(weatherStore.currentWeatherInfo?.name ?? "")
        }
    }
}

struct WeatherView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherView()
    }
}
