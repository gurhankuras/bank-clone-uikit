//
//  LoginService.swift
//  ziraat-clone
//
//  Created by Gürhan Kuraş on 9/4/22.
//

import Foundation

protocol LoginService {
    typealias LoginCallback = (LoginViewModel.Result<Error>) -> Void
    func login(_ user: AccountHolder, with password: LoginPassword, completion: @escaping LoginCallback)
}
