//
//  CustomCategoryPicker.swift
//  BirthdayHarbinger
//
//  Created by Özgün Can Beydili on 13.07.2024.
//

import SwiftUI

struct CustomCategoryPicker: View {
    @Binding var selectedCategory: Category
    
    var body: some View {
        HStack {
            ForEach(Category.allCases, id: \.self) { category in
                Button(action: {
                    selectedCategory = category
                }) {
                    VStack {
                        Text(category.rawValue)
                            .foregroundColor(selectedCategory == category ? .blue : .secondary)
                        if selectedCategory == category {
                            Rectangle()
                                .fill(Color.blue)
                                .frame(height: 2)
                                .padding(.top, -4)
                        } else {
                            Rectangle()
                                .fill(Color.clear)
                                .frame(height: 2)
                                .padding(.top, -4)
                        }
                    }
                }
                .buttonStyle(BorderlessButtonStyle())
                Spacer(minLength: 0)
            }
        }
        .padding(.horizontal)
    }
}

//#Preview {
//    CustomCategoryPicker(selectedCategory: )
//}
