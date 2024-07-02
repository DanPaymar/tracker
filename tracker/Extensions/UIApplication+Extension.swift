//
//  UIApplication+Extension.swift
//  tracker
//
//  Created by Daniel Paymar on 7/1/24.
//

import UIKit

extension UIApplication {
    func endEditing() {
        sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil,
            from: nil,
            for: nil
        )
    }
}
