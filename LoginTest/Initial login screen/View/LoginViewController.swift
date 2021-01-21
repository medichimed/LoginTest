//
//  ViewController.swift
//  LoginTest
//
//  Created by Oksana Kotilevska on 20.01.2021.
//

import Combine
import UIKit

class LoginViewController: UIViewController {

    //MARK: - Outlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    @IBOutlet weak var signInButton: RoundedCornerButton!

    //MARK: - Properties
    private var firstCancellable: AnyCancellable?
    private var secondCancellable: AnyCancellable?
    //MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setSubscriptions()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
        disableLoginButton()
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

        guard Validator.isValidEmail(emailTextField.text) else {
            AlertService.popUpInformAlert(withTitle: "Error", withMessage: "Invalid input", on: self)
            clearTextFields()
            disableLoginButton()
            return(nil, nil)
        }

        return(email, password)
    }

    private func setSubscriptions() {
        firstCancellable = NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: passwordTextField)
            .map{$0.object as? UITextField}
            .compactMap{$0?.text}
            .map{ str -> Bool in
                if self.emailTextField.text!.isEmpty {
                    self.signInButton.alpha = 0.5
                } else {
                    self.signInButton.alpha = 1.0
                }
                return !self.emailTextField.text!.isEmpty
            }
            .assign(to: \.isEnabled, on: signInButton)

        secondCancellable = NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: emailTextField)
            .map{$0.object as? UITextField}
            .compactMap{$0?.text}
            .map{ str -> Bool in
                if self.passwordTextField.text!.isEmpty {
                    self.signInButton.alpha = 0.5
                } else {
                    self.signInButton.alpha = 1.0
                }
                return !self.passwordTextField.text!.isEmpty
            }
            .assign(to: \.isEnabled, on: signInButton)
    }

    private func clearTextFields() {
        emailTextField.text = ""
        passwordTextField.text = ""
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }

    private func disableLoginButton() {
        signInButton.alpha = 0.5
        signInButton.isEnabled = false
    }

}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}
