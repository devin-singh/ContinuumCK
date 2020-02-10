//
//  UIViewControllerExtension.swift
//  Continuum
//
//  Created by Devin Singh on 2/9/20.
//  Copyright © 2020 Devin Singh. All rights reserved.
//

import UIKit

extension UIViewController {
  func presentSimpleAlertWith(title: String, message: String?) {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let okayAction = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
    alertController.addAction(okayAction)
    present(alertController, animated: true)
  }
}
