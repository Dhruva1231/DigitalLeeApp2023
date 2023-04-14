//
//  FlowDetection.swift
//  LBTASwiftUIFirebaseChat
//
//  Created by Dhruva Sharma on 2/14/23.
//

import Foundation
import SwiftUI



struct SettingsView: View{
    var body: some View{
        NavigationView{
            ZStack{
                
                
                
            }.background(Image("aibackground").resizable().edgesIgnoringSafeArea(.all).frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height + 400))
        }
    }
}


struct FlowDetection: View {
    @State var name: String = ""
        var body: some View {
            TabView {
               
                
                    SimulationView()
                        .tabItem {
                            Label("Report", systemImage: "clipboard")
                        }
                        .toolbar(.visible, for: .tabBar)
                        .toolbarBackground(Color(red: 0.07, green: 0.30, blue: 0.46), for: .tabBar)

                    ContentView()
                        .tabItem {
                            Label("Camera", systemImage: "camera")
                        }
                        .toolbar(.visible, for: .tabBar)
                    
                        .toolbarBackground(Color(red: 0.07, green: 0.30, blue: 0.46), for: .tabBar)

                    SignOut()
                        .tabItem {
                            Label("Settings", systemImage: "gearshape")
                        }
                        .toolbar(.visible, for: .tabBar)
                    
                        .toolbarBackground(Color(red: 0.07, green: 0.30, blue: 0.46), for: .tabBar)

            }.accentColor(.red)
                }
            }

    struct ContentView_Previews2: PreviewProvider {
        static var previews: some View {
            FlowDetection()
            
        }
    }

