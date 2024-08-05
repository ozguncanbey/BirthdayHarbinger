//
//  BiometricAuthView.swift
//  BirthdayHarbinger
//
//  Created by Özgün Can Beydili on 5.08.2024.
//

import SwiftUI
import LocalAuthentication

struct BiometricAuthView: View {
    @Binding var isPresented: Bool
    @Binding var isSuccess: Bool
    
    var body: some View {
        VStack {
            Text("Gizli kişileri görmek için kimlik doğrulama yapın")
                .font(.headline)
            Button("Kimlik Doğrulama") {
                authenticate()
            }
            .padding()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 20)
    }
    
    private func authenticate() {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: "Kimliğinizi doğrulamanız gerekiyor.") { success, authenticationError in
                DispatchQueue.main.async {
                    if success {
                        isSuccess = true
                    } else {
                        isSuccess = false
                    }
                    isPresented = false
                }
            }
        } else {
            isSuccess = false
            isPresented = false
        }
    }
}


//#Preview {
//    BiometricAuthView(isPresented: <#Binding<Bool>#>, isSuccess: <#Binding<Bool>#>)
//}
