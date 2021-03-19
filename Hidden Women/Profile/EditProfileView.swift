//
//  EditProfileView.swift
//  Hidden Women
//
//  Created by Claudia Marzal Polop on 19/3/21.
//

import SwiftUI
import Firebase

struct EditProfileView: View {
    @State var shouldPresentImagePicker = false
    @State var shouldPresentActionScheet = false
    @State var shouldPresentCamera = false
    
    @EnvironmentObject var profile: Profile
    @AppStorage ("userID") var userID: String = ""
    @State var editedProfile: Profile = Profile()
    @Binding var profilePage: ProfilePages
    
    var body: some View {
        VStack {
            Image(uiImage: editedProfile.picture ?? UIImage())
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
                .onTapGesture {
                    shouldPresentActionScheet = true
                }
                .sheet(isPresented: $shouldPresentImagePicker) {
                    SUImagePickerView(
                        sourceType: shouldPresentCamera ? .camera : .photoLibrary,
                        image: $editedProfile.picture,
                        isPresented: $shouldPresentImagePicker
                    )
                }
            HStack {
                Image(systemName: "person")
                TextField("User name...", text: $editedProfile.name)
            }
            .frame(height: 60)
            .padding(.horizontal, 20)
            .background(Color("Hueso"))
            .cornerRadius(16)
            .padding(.horizontal, 20)
            Button(action: {
                profile.name = editedProfile.name
                profile.picture = editedProfile.picture?.scalePreservingAspectRatio(targetSize: CGSize(width: 200.0, height: 200.0))
                let pictureData = profile.picture?.pngData() ?? Data()
                let metadata = StorageMetadata()
                metadata.contentType = "image/png"
                Storage.storage().reference().child("\(userID)/Profile.png").putData(pictureData, metadata: metadata) { metadata, error in
                    if let error = error {
                     // HAY UN ERROR
                    }
                }
                Firestore.firestore().collection("users").document(userID).updateData(
                    ["name": editedProfile.name]
                ) { error in
                    if let error = error {
                        print("error!!!")
                    } else {
                        print("Ha ido bien!")
                    }
                }
                profilePage = .profile
            }) {
                Text("Save")
                    .fontWeight(.bold)
                    .padding(EdgeInsets(top: 12, leading: 40, bottom: 12, trailing: 40))
                    .foregroundColor(Color.white)
                    .background(Color("Morado"))
                    .cornerRadius(10)
            }
            Button(action: {
                profilePage = .profile
            }) {
                Text("Cancel")
            }
            
        }
        .onAppear {
            editedProfile = profile
        }
        .actionSheet(isPresented: $shouldPresentActionScheet) { () -> ActionSheet in
            ActionSheet(title: Text("Choose mode"), message: Text("Please choose your preferred mode to set your profile image"), buttons: [ActionSheet.Button.default(Text("Camera"), action: {
                self.shouldPresentImagePicker = true
                self.shouldPresentCamera = true
            }), ActionSheet.Button.default(Text("Photo Library"), action: {
                self.shouldPresentImagePicker = true
                self.shouldPresentCamera = false
            }), ActionSheet.Button.cancel()])
        }
    }
}

struct EditProfileView_Previews: PreviewProvider {
    static var editedProfile: Profile = Profile()
    @State static var profilePage: ProfilePages = .editProfile
    
    
    static var previews: some View {
        EditProfileView(profilePage: $profilePage)
            .environmentObject(editedProfile)
    }
}


// from: https://www.advancedswift.com/resize-uiimage-no-stretching-swift/

extension UIImage {
    func scalePreservingAspectRatio(targetSize: CGSize) -> UIImage {
        // Determine the scale factor that preserves aspect ratio
        let widthRatio = targetSize.width / size.width
        let heightRatio = targetSize.height / size.height
        
        let scaleFactor = min(widthRatio, heightRatio)
        
        // Compute the new image size that preserves aspect ratio
        let scaledImageSize = CGSize(
            width: size.width * scaleFactor,
            height: size.height * scaleFactor
        )

        // Draw and return the resized UIImage
        let renderer = UIGraphicsImageRenderer(
            size: scaledImageSize
        )

        let scaledImage = renderer.image { _ in
            self.draw(in: CGRect(
                origin: .zero,
                size: scaledImageSize
            ))
        }
        
        return scaledImage
    }
}
