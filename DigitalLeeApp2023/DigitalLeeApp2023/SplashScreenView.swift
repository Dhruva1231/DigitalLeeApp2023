//
//  SplashScreenView.swift
//  swiftuidev15ios
//
//  Created by Cairocoders
//
 
import SwiftUI
 
struct SplashScreenView: View {
    @State var isActive : Bool = false
    @State private var size = 0.8
    @State private var opacity = 0.5
     
    var body: some View {
        if isActive {
            FlowDetection()
        } else {
            ZStack{
                VStack {
                    VStack {
                        Image("COFM")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 75, height: 75)
                        
                        Text("Welcome")
                            .font(Font.custom("Segoe-UI", size: 26))
                            .foregroundColor(.white.opacity(0.80))
                    }
                    .scaleEffect(size)
                    .opacity(opacity)
                    .onAppear {
                        withAnimation(.easeIn(duration: 1.1)) {
                            self.size = 0.9
                            self.opacity = 1.00
                        }
                    }
                }
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        withAnimation {
                            self.isActive = true
                        }
                    }
                }
            }.background(Image("test").resizable().edgesIgnoringSafeArea(.all).frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height + 200))

        }
    }
}
 
struct SplashScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreenView()
    }
}
