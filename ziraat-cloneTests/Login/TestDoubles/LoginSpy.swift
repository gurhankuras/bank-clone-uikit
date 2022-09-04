//
//  LoginSpy.swift
//  ziraat-cloneTests
//
//  Created by Gürhan Kuraş on 9/4/22.
//

import Foundation
@testable import ziraat_clone

class LoginSpy {
    private(set) var results: [LoginViewModel.Result<Error>]

    init(results: [LoginViewModel.Result<Error>] = []) {
        self.results = results

    }
    func callback(_ result: LoginViewModel.Result<Error>) {
        results.append(result)
    }
}
