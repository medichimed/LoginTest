//
//  NetworkService.swift
//  LoginTest
//
//  Created by Oksana Kotilevska on 20.01.2021.
//

import Foundation

final class NetworkService {

    private init(){}

    static let shared = NetworkService()

    func postLogin(for email: String,with password: String, completion: @escaping(Result<String, LoginError>)->()) {
        let url = URL(string: Constants.shared.url + "?email=\(email)&password=\(password)&project_id=\(Constants.shared.projectId)")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let _ = error {
                completion(.failure(.sessionError))
                return
            }

            guard let data = data else {
                completion(.failure(.noData))
                return
            }

            guard let _ = response else {
                completion(.failure(.responseDataCorrupted))
                return
            }

            let responseValue = response as! HTTPURLResponse
                if !(200...299).contains(responseValue.statusCode) {
                    print("Status code => \(responseValue.statusCode)")
                    guard responseValue.statusCode == 401  else {
                        completion(.failure(.unrecognisedError))
                        return
                    }
                    completion(.failure(.unauthorizedUser))
                    return
                }
            
            do {
                let details = try JSONDecoder().decode(LoginResponse.self, from: data)
                print("Details: \(details)")
                self.saveToken(details.accessToken)
                completion(.success("Success"))
            } catch {
                completion(.failure(.decodingError))
            }
        }.resume()
    }

    private func saveToken(_ token: String) {
        UserDefaults.standard.setValue(token, forKeyPath: Constants.shared.tokenKey)
    }

    func removeToken(){
        UserDefaults.standard.setValue(nil, forKeyPath: Constants.shared.tokenKey)
    }
}


enum LoginError: String, Error {
    case sessionError = "Session error"
    case noData = "No data has been retrieved"
    case responseDataCorrupted = "Response data has been corrupted"
    case decodingError = "Decoding error has occured"
    case unrecognisedError = "Unrecognised server error"
    case unauthorizedUser = "Unauthorized user"
}
