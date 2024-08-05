//
// Created by S7epz on 04/08/24.
// Copyright © 2024 ACME.
// All Rights Reserved.


import SwiftUI

struct ContentView: View {
    
    @State private var user: gitHubUser?
    @State private var isNight = false
    //State to keep the variable
    
    
    
    //async = async way - throws = to throw errors
    func getUser() async throws -> gitHubUser {
        
        //endPoint = where to get the data from
        let endPoint = "https://api.github.com/users/S7epz"
        
        //create an URL object
        guard let url = URL(string: endPoint) else { throw GHError.invalidURL }
        
        //use URLSession to get data from the url object created above
        //it returns a tuple of data and respose
        let(data, response) = try await URLSession.shared.data(from: url)
        
        //check the response ( 404 or other errors )
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw GHError.invalidURL
        }
        
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(gitHubUser.self, from: data)
        } catch {
            throw GHError.invalidURL
        }
    }
    
    
    
    
    var body: some View {

        ZStack{
            BackgroundView(isNight: $isNight)
            
            VStack{
                
                CityTextView(cityName:"Montebelluna, TV")
                
                todayView(image: isNight ? "cloud.moon.fill" : "cloud.sun.fill", temp: "32")
                
                .padding(.bottom, 40)
                
                HStack(spacing: 20){
                   WeatherView(day: "MAR", image: "cloud.sun.fill", temp: "28")
                    WeatherView(day: "MER", image: "cloud.bolt.fill", temp: "29")
                    WeatherView(day: "GIO", image: "cloud.rain.fill", temp: "22")
                    WeatherView(day: "VEN", image: "sun.max.fill", temp: "25")
                    WeatherView(day: "SAB", image: "cloud.sun.fill", temp: "26")
                    
            }
                    Spacer()
                
                    .task {
                        do{
                            user = try await getUser()
                        }catch GHError.invalidURL{
                            print("invalid")
                        }catch{
                            print("ok")
                        }
                    }
                
                
                if let user = user{
                    Text(user.username)
                }else{
                    
                }
                
                    
                    
                
                Button{
                    isNight.toggle()
                }label: {
                    buttonView(
                        labelName: "Change Day Time",
                        backgroundColor: .white
                    )
                }
                
                Spacer()
            }
            
                
        }
        
    }
}



#Preview {
    ContentView()
}



struct WeatherView: View {
    var day: String
    var image: String
    var temp: String
    
    var body: some View {
        VStack{
            Text(day)
                .font(.system(size: 16, weight: .medium, design: .default))
                .foregroundColor(.white)
            Image(systemName: image)
                .renderingMode(.original)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 50, height: 50)
            Text(temp + "°")
                .font(.system(size: 28, weight: .medium, design: .default))
                .foregroundColor(.white)
            
        }
    }
}

struct BackgroundView: View {
    
    @Binding var isNight: Bool
    
    var body: some View {
        LinearGradient(gradient: Gradient(colors: [isNight ? .black : .blue, isNight ? .gray : .yellow]),
                       startPoint: .topLeading,
                       endPoint: .bottomTrailing
        )
        .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
    }
}


struct CityTextView: View{
    
    var cityName: String
    
    var body: some View{
        Text(cityName)
            .font(.system(size: 32, weight: .medium, design: .default))
            .foregroundColor(.white)
            .padding()
    }
}

struct todayView: View {
    
    var image: String
    var temp: String
    
    var body: some View {
        VStack(spacing: 10){
            Image(systemName: image)
                .symbolRenderingMode(.multicolor)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 180, height: 180)
            
            Text(temp + "°")
                .font(.system(size: 70, weight: .medium))
                .foregroundColor(.white)
        }
    }
}

struct gitHubUser: Codable{
    
    let username: String
    
}


enum GHError: Error {
    case invalidURL
}
