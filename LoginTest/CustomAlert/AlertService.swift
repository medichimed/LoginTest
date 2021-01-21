//
//  AlertService.swift
//  LoginTest
//
//  Created by Oksana Kotilevska on 20.01.2021.
//

import UIKit

struct AlertService {

    static func popUpInformAlert(withTitle title: String?, withMessage message: String?, on view: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { _ in
            view.dismiss(animated: true, completion: nil)
        }))
        view.present(alert, animated: true, completion: nil)
    }
    
}
