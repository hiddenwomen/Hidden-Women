//
//  EditProfileView.swift
//  Hidden Women
//
//  Created by Claudia Marzal Polop on 19/3/21.
//

import SwiftUI

struct EditProfileView: View {
    @EnvironmentObject var profile: Profile

    @State var editedProfile: Profile = Profile(userId: "")
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
                .scaledToFill()
                .clipShape(Circle())
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
                .padding(.top, 40)
            Text("Tap on the picture to change it")
                .font(.caption)
            HStack {
                Image(systemName: "person")
                TextField("User name...", text: $editedProfile.name)
            }
            .frame(height: 60)
            .padding(.horizontal, 20)
            .background(Color("Hueso"))
            .cornerRadius(16)
            .padding(20)
            Button(action: {
                profile.updateName(name: editedProfile.name) { error in
                    errorTitle = "Error saving profile data"
                    errorMessage = "\(error.localizedDescription)"
                    showError = true
                }
                profile.updatePicture(newPicture: editedProfile.picture) { error in
                    errorTitle = "Error saving picture"
                    errorMessage = "\(error.localizedDescription)"
                    showError = true
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
            .padding(.top, 40)
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
    static var editedProfile: Profile = Profile(userId: "")
    @State static var profilePage: ProfilePages = .editProfile
    
    
    static var previews: some View {
        EditProfileView(profilePage: $profilePage)
            .environmentObject(editedProfile)
    }
}



