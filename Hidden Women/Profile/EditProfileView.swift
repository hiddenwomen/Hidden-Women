//
//  EditProfileView.swift
//  Hidden Women
//
//  Created by Claudia Marzal Polop on 19/3/21.
//

import SwiftUI
import Firebase

struct EditProfileView: View {
    @EnvironmentObject var profile: Profile
    @AppStorage ("userID") var userID: String = ""

    @State var editedProfile: Profile = Profile()
    @Binding var profilePage: ProfilePages

    @State var showImagePicker = false
    @State var showActionScheet = false
    @State var showCamera = false
    
    @State var showError = false
    @State var errorTitle = ""
    @State var errorMessage = ""
        
    var body: some View {
        VStack {
            Image(uiImage: editedProfile.picture ?? UIImage())
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
                .onTapGesture {
                    showActionScheet = true
                }
                .sheet(isPresented: $showImagePicker) {
                    SUImagePickerView(
                        sourceType: showCamera ? .camera : .photoLibrary,
                        image: $editedProfile.picture,
                        isPresented: $showImagePicker
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
                        errorTitle = "Error saving picture"
                        errorMessage = "\(error.localizedDescription)"
                        showError = true
                    }
                }
                Firestore.firestore()
                    .collection("users")
                    .document(userID)
                    .updateData(["name": editedProfile.name]) { error in
                    if let error = error {
                        errorTitle = "Error saving profile data"
                        errorMessage = "\(error.localizedDescription)"
                        showError = true
                    }
                }
                profilePage = .profile
            }) {
                Text("Save")
                    .fontWeight(.bold)
                    .importantButtonStyle()
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
        .actionSheet(isPresented: $showActionScheet) { () -> ActionSheet in
            ActionSheet(
                title: Text("Choose mode"),
                message: Text("Please choose your preferred mode to set your profile image"),
                buttons: [
                    ActionSheet.Button.default(
                        Text("Camera"),
                        action: {
                            self.showImagePicker = true
                            self.showCamera = true
                        }
                    ),
                    ActionSheet.Button.default(
                        Text("Photo Library"),
                        action: {
                            self.showImagePicker = true
                            self.showCamera = false
                        }
                    ),
                    ActionSheet.Button.cancel()
                ]
            )
        }
        .alert(isPresented: $showError) {
            Alert(
                title: Text(errorTitle),
                message: Text(errorMessage),
                dismissButton: .default(Text("OK"))
            )
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



