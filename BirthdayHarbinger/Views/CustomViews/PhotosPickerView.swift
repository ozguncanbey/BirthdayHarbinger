//
//  PhotosPickerView.swift
//  BirthdayHarbinger
//
//  Created by Özgün Can Beydili on 16.07.2024.
//

import SwiftUI
import PhotosUI

struct PhotosPickerView: View {
    @Binding var selectedImage: PhotosPickerItem?
    @Binding var selectedImageData: Data?
    
    @State private var isShowingImagePicker = false
    
    var body: some View {
        VStack {
            Group {
                if let selectedImageData = selectedImageData, let uiImage = UIImage(data: selectedImageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .clipShape(.circle)
                } else {
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .scaledToFill()
                        .clipShape(.circle)
                        .tint(.secondary)
                }
            }
            .frame(width: 100, height: 100, alignment: .center)
            .onTapGesture {
                isShowingImagePicker = true
            }
            .sheet(isPresented: $isShowingImagePicker) {
                ImagePicker(selectedImageData: $selectedImageData)
            }
        }
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImageData: Data?
    @Environment(\.presentationMode) private var presentationMode
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        var parent: ImagePicker
        
        init(parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.editedImage] as? UIImage {
                parent.selectedImageData = uiImage.pngData()
            }
            
            parent.presentationMode.wrappedValue.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
}
