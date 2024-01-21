//
//  alert.swift
//  app_swiftui
//
//  Created by Sysprobs on 1/12/24.
//

import Foundation
import SwiftUI
import UserNotifications

func showAlert(title: String, message: String, completion: @escaping () -> Void) {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let OKAction = UIAlertAction(title: "OK", style: .default) { action in
        completion()
    }
    alertController.addAction(OKAction)
    self.present(alertController, animated: true, completion: nil)
}
