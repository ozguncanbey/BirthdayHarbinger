//
//  SubscriptionScreen.swift
//  BirthdayHarbinger
//
//  Created by Özgün Can Beydili on 31.07.2024.
//

import SwiftUI
import StoreKit

struct SubscriptionScreen: View {
    
    @AppStorage("language") private var language = LocaleManager.shared.language
    
    var body: some View {
        SubscriptionStoreView(productIDs: ["birthdayHarbinger.montly","yearly","lifetime"]) {
            SubscriptionHeaderView(language: language)
        }
        .subscriptionStorePolicyDestination(for: .termsOfService) {
            Text("Terms of Service")
        }
        .subscriptionStorePolicyDestination(for: .privacyPolicy) {
            Text("Privacy Policy")
        }
        .subscriptionStorePolicyForegroundStyle(.black)
        .subscriptionStorePickerItemBackground(.thinMaterial)
        .subscriptionStoreControlStyle(.prominentPicker)
        .subscriptionStoreControlBackground(.gradientMaterial)
        .storeButton(.visible, for: .redeemCode)
        .storeButton(.visible, for: .restorePurchases)
        .storeButton(.visible, for: .cancellation)
    }
}

#Preview {
    SubscriptionScreen()
}
