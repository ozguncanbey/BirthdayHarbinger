//
//  Locale+Ext.swift
//  BirthdayHarbinger
//
//  Created by Özgün Can Beydili on 15.07.2024.
//

import Foundation

extension Locale {
    var isTurkish: Bool {
        return self.language.languageCode?.identifier == "tr"
    }
}
