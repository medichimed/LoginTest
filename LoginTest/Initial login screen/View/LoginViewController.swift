//
//  ViewController.swift
//  LoginTest
//
//  Created by Oksana Kotilevska on 20.01.2021.
//

/*    "email": "junior-ios-developer@mailinator.com",
 "password": "s4m8AJDbVvX4H8aF",
*/

import Combine
import UIKit

class LoginViewController: UIViewController {

    //MARK: - Outlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    @IBOutlet weak var signInButton: RoundedCornerButton!
    //MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
        tabBarController?.tabBar.isHidden = true
    }

    //MARK: - Actions
    @IBAction func signInButtonTapped(_ sender: Any) {
        guard let email = validateUserInput().email, let password = validateUserInput().password else {
            return
        }

        NetworkService.shared.postLogin(for: email, with: password) { (result) in
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    self.clearTextFields()

                    guard let viewController = UIStoryboard(name: "LoggedScreen", bundle: nil).instantiateViewController(identifier: "LoggedScreedViewController") as? LoggedScreedViewController else { return }
                    self.navigationController?.pushViewController(viewController, animated: true)
                }

            case .failure(let error):
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    AlertService.popUpInformAlert(withTitle: "Login Error", withMessage: error.rawValue, on: self)
                    self.clearTextFields()
                }
            }
        }

    }

    //MARK: - Methods
    private func validateUserInput() -> (email: String?, password: String?) {
        let email = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let password = passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

        guard !email.isEmpty && !password.isEmpty else {
            AlertService.popUpInformAlert(withTitle: "Error", withMessage: "Fill out all fields", on: self)
            return(nil, nil)
        }

        guard Validator.isValidEmail(emailTextField.text) else {
            AlertService.popUpInformAlert(withTitle: "Error", withMessage: "Invalid email", on: self)
            return(nil, nil)
        }

        return(email, password)
    }

    private func clearTextFields() {
        emailTextField.text = ""
        passwordTextField.text = ""
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }

}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}
