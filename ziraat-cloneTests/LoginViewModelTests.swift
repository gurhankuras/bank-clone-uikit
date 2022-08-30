//
//  LoginViewModelTests.swift
//  ziraat-cloneTests
//
//  Created by Gürhan Kuraş on 8/19/22.
//

import XCTest
@testable import ziraat_clone

class LoginViewModelTests: XCTestCase {
    func test_startsWithEmptyPassword() throws {
        let loginAPI = LoginServiceStub(result: .success)
        let sut = LoginViewModel(service: loginAPI, accountHolder: AccountHolder.stub)

        XCTAssertEqual(sut.password.value, "")
    }

    func test_attempLogin_FailsWhenPasswordIsShort() throws {
        let loginAPI = LoginServiceStub(result: .success)
        let sut = LoginViewModel(service: loginAPI, accountHolder: AccountHolder.stub)
        var result: LoginViewModel.Result<Error>?
        sut.onSubmitted = { res in
            result = res
        }
        sut.password = LoginPassword("123")
        sut.attempLogin()

        XCTAssertNotNil(result)
        if case let .error(e) = result {
            XCTAssertTrue(e is LoginViewModel.LoginError)
        }
    }

    func test_attempLogin_FailsWhenPasswordRespectsToRules() throws {
        let loginAPI = LoginServiceStub(result: .success)
        let sut = LoginViewModel(service: loginAPI, accountHolder: AccountHolder.stub)
        var result: LoginViewModel.Result<Error>?
        sut.onSubmitted = { res in
            result = res
        }
        sut.password = LoginPassword("123456")
        sut.attempLogin()

        XCTAssertNotNil(result)
        guard case let .success = result else {
            XCTFail("")
            return
        }
    }

    func test_attempLogin_TriesToLogin_WhenTheFirstTimePasswordFormatIsCorrect() throws {
        let loginAPI = LoginServiceStub(result: .success)
        let sut = LoginViewModel(service: loginAPI, accountHolder: AccountHolder.stub)

        let spy = LoginSpy()
        sut.onAutoLoginAttempt = spy.callback(_:)
        sut.password = LoginPassword("123456")

        let result = spy.results.first!
        XCTAssertEqual(spy.results.count, 1)
        XCTAssertNotNil(result)
        guard case let .success = result else {
            XCTFail("")
            return
        }
    }

    func test_attempLogin_AttemptsManualLoginAfterFirstTime() throws {
        let loginAPI = LoginServiceStub(result: .success)
        let sut = LoginViewModel(service: loginAPI, accountHolder: AccountHolder.stub)

        let spy = LoginSpy()
        sut.onAutoLoginAttempt = spy.callback(_:)
        sut.password = LoginPassword("123456") // automatically attempts login because password format is correct
        sut.password = LoginPassword("123451") // does nothing unless press login button

        XCTAssertEqual(spy.results.count, 1)
    }
}

private extension LoginViewModel.Result {
    var isError: Bool {
        switch self {
        case .success:
            return false
        case .error:
            return true
        }
    }

    var isSuccess: Bool {
        switch self {
        case .success:
            return true
        case .error:
            return false
        }
    }
}

class LoginSpy {
    private(set) var results: [LoginViewModel.Result<Error>]

    init(results: [LoginViewModel.Result<Error>] = []) {
        self.results = results

    }
    func callback(_ result: LoginViewModel.Result<Error>) {
        results.append(result)
    }
}
