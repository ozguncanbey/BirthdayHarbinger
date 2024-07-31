//
//  SubscriptionView.swift
//  BirthdayHarbinger
//
//  Created by Özgün Can Beydili on 31.07.2024.
//

import SwiftUI
import StoreKit

struct SubscriptionView: View {
    var body: some View {
        SubscriptionStoreView(productIDs: ["birthdayHarbinger.montly","yearly","lifetime"]) {
            SubscriptionHeaderView()
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
    SubscriptionView()
}
