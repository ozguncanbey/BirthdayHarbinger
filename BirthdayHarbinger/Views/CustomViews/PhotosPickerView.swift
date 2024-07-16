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
    
    var body: some View {
        PhotosPicker(selection: $selectedImage, matching: .images, photoLibrary: .shared()) {
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
        }
    }
}
