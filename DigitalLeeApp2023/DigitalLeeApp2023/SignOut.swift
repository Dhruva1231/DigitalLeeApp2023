//
//  ContentView.swift
//  LBTASwiftUIFirebaseChat
//
//  Created by Brian Voong on 10/23/21.
//
import PhotosUI
import SwiftUI
import Firebase
import FirebaseStorage
import FirebaseFirestore

struct SignOut: View {
    @State var isActive : Bool = false
    @State var selectedItems: [PhotosPickerItem] = []
    @State var isLoginMode = false
    @State var email = ""
    @State var password = ""
    @State var shouldShowImagePicker = false
    @State var isOn = false
    @State var willMoveToNextScreen = true
    @State var loggedOn = false
    
    var body: some View {
        if(isActive){
            SplashScreenView()
        }else{
            NavigationView {
                
                ScrollView {
                    
                    VStack(spacing: 16) {
                        
                        
                        
                        Group {
                            TextField("testuser@gmail.com", text: $email)
                                .keyboardType(.emailAddress)
                                .autocapitalization(.none)
                            SecureField("(*******)", text: $password)
                        }
                        .padding(12)
                        .background(Color.white)
                        
                        Button {
                            handleAction()
                        } label: {
                            HStack {
                                Spacer()
                                Text("Sign Out")
                                    .foregroundColor(.white)
                                    .padding(.vertical, 10)
                                    .font(.system(size: 14, weight: .semibold))
                                Spacer()
                            }.background(Color.red)
                            
                        }
                   
                        
                        Toggle(isOn: $isOn){
                            Text("Developer Mode")
                        }.frame(width: 300, height: 50)
                    }
                    .padding()
                    
                }
                .navigationTitle(isLoginMode ? "Log In" : "Manage Account").background(Color(red: 0.9, green: 0.9, blue: 0.9).ignoresSafeArea())
                
                
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .fullScreenCover(isPresented: $shouldShowImagePicker, onDismiss: nil) {
                ImagePicker(image: $image)
            }
            
        }
        
    }
    
    @State var image: UIImage?
    
    private func handleAction() {
        if isLoginMode {
            loginUser()
            //            print("Should log into Firebase with existing credentials")
        } else {
            createNewAccount()
            //            print("Register a new account inside of Firebase Auth and then store image in Storage somehow....")
        }
    }
    private func loginUser() {
        FirebaseManager.shared.auth.signIn(withEmail: email, password: password) { result, err in
            if let err = err {
                print("Failed to login user:", err)
                self.loginStatusMessage = "Failed to login user: \(err)"
                return
            }
            
            print("Successfully logged in as user: \(result?.user.uid ?? "")")
            
            self.loginStatusMessage = "Successfully logged in as user: \(result?.user.uid ?? "")"
            self.isActive = true
        }
    }
    
    @State var loginStatusMessage = ""
    
    private func createNewAccount() {
        FirebaseManager.shared.auth.createUser(withEmail: email, password: password) { result, err in
            if let err = err {
                print("Failed to create user:", err)
                self.loginStatusMessage = "Failed to create user: \(err)"
                return
            }
            
            print("Successfully created user: \(result?.user.uid ?? "")")
            
            self.loginStatusMessage = "Successfully created user: \(result?.user.uid ?? "")"
            self.persistImageToStorage()
            
        }
    }
    
    private func persistImageToStorage() {
        //        let filename = UUID().uuidString
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        let ref = FirebaseManager.shared.storage.reference(withPath: uid)
        guard let imageData = self.image?.jpegData(compressionQuality: 0.5) else { return }
        ref.putData(imageData, metadata: nil) { metadata, err in
            if let err = err {
                self.loginStatusMessage = "Failed to push image to Storage: \(err)"
                return
            }
            
            ref.downloadURL { url, err in
                if let err = err {
                    self.loginStatusMessage = "Failed to retrieve downloadURL: \(err)"
                    return
                }
                
                self.loginStatusMessage = "Successfully stored image with url: \(url?.absoluteString ?? "")"
                print(url?.absoluteString ?? "null")
                
                guard let url = url else{  return }
                self.storeUserInformation(imageProfileUrl: url)
            }
        }
    }
    
    private func storeUserInformation(imageProfileUrl: URL) {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        let userData = ["email": self.email, "uid": uid, "profileImageUrl": imageProfileUrl.absoluteString]
        FirebaseManager.shared.firestore.collection("users")
            .document(uid).setData(userData) { err in
                if let err = err {
                    print(err)
                    self.loginStatusMessage = "\(err)"
                    return
                }
                
                print("Success")
                
            }
        }
     }

