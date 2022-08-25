//
//  LoginViewModel.swift
//  ziraat-clone
//
//  Created by Gürhan Kuraş on 8/19/22.
//

import Foundation


protocol LoginService {
    func login(_ user: AccountHolder, with password: LoginPassword, completion: @escaping (LoginViewModel.Result<Error>) -> ())
}


class LoginServiceStub: LoginService {
    let result: LoginViewModel.Result<Error>
    init(result: LoginViewModel.Result<Error>) {
        self.result = result
    }
    
    func login(_ user: AccountHolder, with password: LoginPassword, completion: @escaping (LoginViewModel.Result<Error>) -> ()) {
        completion(self.result)
    }
}


struct LoginPassword {
    let value: String
    
    init(_ value: String) {
        self.value = value
    }
    
    var isValid: Bool {
        return value.count == Self.requiredPasswordLength
    }
    
    static var requiredPasswordLength: Int {
        return 6
    }
}

extension LoginPassword {
    static var empty: Self {
        LoginPassword("")
    }
}

class LoginViewModel {
    var onPasswordChange: ((String) -> ())?
    var onSubmitted: ((LoginViewModel.Result<Error>) -> ())?
    var onAutoLoginAttempt: ((LoginViewModel.Result<Error>) -> ())?
    var accountHolder: AccountHolder?

    private let loginService: LoginService
    
    init(service: LoginService, accountHolder: AccountHolder) {
        self.loginService = service
        self.accountHolder = accountHolder
    }
    
    var password: LoginPassword = LoginPassword.empty {
        didSet {
            onPasswordChange?(password.value)
            handleAutoLogin()
        }
    }
    private var isFirstAttempt = true

    
    private func handleAutoLogin() {
        if isFirstAttempt && self.password.isValid {
            let account = AccountHolder(tc: "12345667", firstName: "Tevfik", middleName: "Gurhan", surname: "Kuras")
            attempLogin(with: account) { [weak self] in
                self?.onAutoLoginAttempt?($0)
                self?.isFirstAttempt = false
            }
        }
    }
    
    
    
    func shouldPermitEditing(for password: String) -> Bool {
        return password.count <= LoginPassword.requiredPasswordLength
    }
    
    
    func attempLogin() {
        let account = AccountHolder(tc: "12345667", firstName: "Tevfik", middleName: "Gurhan", surname: "Kuras")
        attempLogin(with: account, completion: { [weak self] in self?.onSubmitted?($0) })
    }
    
    private func attempLogin(with account: AccountHolder, completion: @escaping (LoginViewModel.Result<Error>) -> ()) {
        let submittedPassword = password
        guard submittedPassword.isValid else {
            completion(.error(LoginError.badFormattedPassword(submittedPassword.value)))
            return
        }
        loginService.login(account, with: submittedPassword, completion: { completion($0) })
    }
}

extension LoginViewModel {
    enum Result<E: Error> {
        
        case success
        case error(E)
    }
    
    enum LoginError: LocalizedError {
        case badFormattedPassword(String)
        
        var errorDescription: String? {
            switch self {
            case .badFormattedPassword(let password):
                return "Bad formatted password"
            }
        }
    }
}


