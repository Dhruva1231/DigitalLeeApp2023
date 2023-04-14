//
//  SimulationView.swift
//  LBTASwiftUIFirebaseChat
//
//  Created by Dhruva Sharma on 2/14/23.
//
import PhotosUI
import Foundation
import SwiftUI
import AVKit

struct SimulationView: View{
    @State var isActive : Bool = false
    @State var selectedItems: [PhotosPickerItem] = []
    @State var isLoginMode = false
    @State var model = ""
    @State var epoch = ""
    @State var description = ""
    @State var location = ""
    @State var shouldShowImagePicker = false
    @State var isOn = false
    @State var willMoveToNextScreen = true
    @State var loggedOn = false
    @State var simActive : Bool = false
    @State var image: UIImage?
    
    var body: some View{
        NavigationView{
            if(simActive){
                ZStack{
                    ZStack{
                        VStack(spacing: 16){
                            Text("Submitted:").font(Font.custom("Segoe-UI", size: 25)).multilineTextAlignment(.leading)
                            Text("Name: \(model)").font(.body).font(Font.custom("Segoe-UI", size: 15))
                            Text("Location: \(location)").font(.body).font(Font.custom("Segoe-UI", size: 15))
                            Text("Description: \(description)").font(.body).font(Font.custom("Segoe-UI", size: 15))

                            Button {
                                simActive = false
                            } label: {
                                HStack {
                                    Spacer()
                                    Text("Return")
                                        .foregroundColor(.white)
                                        .padding(.vertical, 10)
                                        .font(.system(size: 14, weight: .semibold))
                                    Spacer()
                                }.background(Color.blue).frame(width: 200)
                            }
                        }.frame(width: 350, height: 275).opacity(1)

                    }.background(Color(red: 0.9, green: 0.9, blue: 0.9)).cornerRadius(25)

                }.background(Image("DigitalLeeBackground").resizable().edgesIgnoringSafeArea(.all).frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height + 200))
            }else{
                NavigationView {
                    
                    ScrollView {
                        
                        VStack(spacing: 16) {
                            
                            if !isLoginMode {
                                Button {
                                    shouldShowImagePicker.toggle()
                                } label: {
                                    VStack{
                                        if let image = self.image {
                                            Image(uiImage: image)
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: 128, height: 128)
                                                .cornerRadius(64)
                                        } else {
                                            Image("upload").resizable()
                                                .frame(width: 100.0, height: 100.0)
                                        }
                                    }
                                }
                                
                            }
                            Group {
                                TextField("Name", text: $model)
                                TextField("Location", text: $location)
                                TextField("Description", text: $description, axis: .vertical)
                                TextField("Phone Number", text: $epoch).keyboardType(.decimalPad)
                            }
                            .padding(12)
                            .background(Color.white)
                            
                            Button {
                                simActive = true
                            } label: {
                                HStack {
                                    Spacer()
                                    Text("Submit")
                                        .foregroundColor(.white)
                                        .padding(.vertical, 10)
                                        .font(.system(size: 14, weight: .semibold))
                                    Spacer()
                                }.background(Color.blue)
                            }.padding(.top, 35)
                     
                        }
                        .padding()
                    }.background(Color(red: 0.9, green: 0.9, blue: 0.9).ignoresSafeArea())

                }.navigationTitle(isLoginMode ? "Log In" : "Report").background(Color(red: 0.9, green: 0.9, blue: 0.9).ignoresSafeArea())
                .navigationViewStyle(StackNavigationViewStyle())
                .fullScreenCover(isPresented: $shouldShowImagePicker, onDismiss: nil) {
                    ImagePicker(image: $image)
                }
                
            }
            
        }

    }
}

struct SimulationView_Previews2: PreviewProvider {
    static var previews: some View {
        SimulationView()
        
    }
}
