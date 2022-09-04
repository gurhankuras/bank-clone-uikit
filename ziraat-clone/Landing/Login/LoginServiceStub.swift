//
//  LoginServiceStub.swift
//  ziraat-clone
//
//  Created by Gürhan Kuraş on 9/4/22.
//

import Foundation

class LoginServiceStub: LoginService {
    let result: LoginViewModel.Result<Error>
    init(result: LoginViewModel.Result<Error>) {
        self.result = result
    }

    func login(_ user: AccountHolder, with password: LoginPassword, completion: @escaping LoginService.LoginCallback) {
        completion(self.result)
    }
}
