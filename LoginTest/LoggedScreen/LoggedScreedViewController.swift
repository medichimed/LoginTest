//
//  LoggedScreedViewController.swift
//  LoginTest
//
//  Created by Oksana Kotilevska on 21.01.2021.
//

import UIKit

class LoggedScreedViewController: UIViewController {

    //MARK: - Outlets
    @IBOutlet weak var logOutButton: UIButton!

    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureButtonUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
    }

    //MARK: - Actions

    @IBAction func logOutButtonTapped(_ sender: Any) {
        NetworkService.shared.removeToken()
        navigationController?.popViewController(animated: true)
    }

    private func configureButtonUI() {
        let attributedString = NSAttributedString(string: "Log out", attributes: [
            .strokeColor : UIColor.systemGray5,
            .foregroundColor: UIColor(named: "logOutButtonTextColor")!,
            .strokeWidth : -3.0
            ])
        logOutButton.setAttributedTitle(attributedString, for: .normal)
    }

}
