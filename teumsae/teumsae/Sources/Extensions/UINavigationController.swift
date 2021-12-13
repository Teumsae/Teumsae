//
//  UINavigationController.swift
//  teumsae
//
//  Created by Subeen Park on 2021/12/14.
//

import UIKit

extension UINavigationController {
    // Remove back button text
    open override func viewWillLayoutSubviews() {
        navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
}
