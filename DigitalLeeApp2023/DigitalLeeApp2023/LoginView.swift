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

enum States{
    case Loading, detection
}
class FirebaseManager: NSObject {
    
    let auth: Auth
    let storage: Storage
    let firestore: Firestore
    static let shared = FirebaseManager()
    
    override init() {
        FirebaseApp.configure()
        
        self.auth = Auth.auth()
        self.storage = Storage.storage()
        self.firestore = Firestore.firestore()
        
        super.init()
    }
    
}
struct LoginView: View {
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
                        
                        Picker(selection: $isLoginMode, label: Text("Picker here")) {
                            Text("Login")
                                .tag(true)
                            Text("Create Account")
                                .tag(false)
                        }.pickerStyle(SegmentedPickerStyle())
                        
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
                                        Image(systemName: "person.fill")
                                            .font(.system(size: 64))
                                            .padding()
                                            .foregroundColor(Color(.label))
                                    }
                                }
                                .overlay(RoundedRectangle(cornerRadius: 64)
                                    .stroke(Color.black, lineWidth: 3)
                                )
                            }
                            
                        }
                        Group {
                            TextField("Email", text: $email)
                                .keyboardType(.emailAddress)
                                .autocapitalization(.none)
                            SecureField("Password", text: $password)
                        }
                        .padding(12)
                        .background(Color.white)
                        
                        Button {
                            handleAction()
                        } label: {
                            HStack {
                                Spacer()
                                Text(isLoginMode ? "Log In" : "Create Account")
                                    .foregroundColor(.white)
                                    .padding(.vertical, 10)
                                    .font(.system(size: 14, weight: .semibold))
                                Spacer()
                            }.background(Color.blue)
                            
                        }
                   
                        
                        if(isOn && isLoginMode){
                            Text(self.loginStatusMessage).frame(width: 300, height: 313)
                                .foregroundColor(.red)
                        }else if(!isOn && isLoginMode){
                            Text("").frame(width: 300, height: 313)
                        }
                        else if(isOn && !isLoginMode){
                            Text(self.loginStatusMessage).frame(width: 300, height: 200)
                                .foregroundColor(.red)
                        }else{
                            Text("").frame(width: 300, height: 200)
                        }
                        
                        Toggle(isOn: $isOn){
                            Text("Developer Mode").foregroundColor(.white)
                        }.frame(width: 300, height: 50)
                    }
                    .padding()
                    
                }
                .navigationTitle(isLoginMode ? "Log In" : "Create Account").background(Image("loginbackground").resizable().edgesIgnoringSafeArea(.all).frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height + 200))
                
                
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

    struct LoadingView: View{
        var body: some View{
            Text("loading")
        }
        
    }

    struct DetectionView: View{
        var body: some View{
            Text("detection")
        }
        
    }
        
    struct ContentView_Previews1: PreviewProvider {
        static var previews: some View {
            FlowDetection()
        }
    }

