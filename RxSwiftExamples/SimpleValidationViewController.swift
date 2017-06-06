//
//  SimpleValidationViewController.swift
//  RxSwiftExamples
//
//  Created by 林　翼 on 2017/06/05.
//  Copyright © 2017年 Tsubasa Hayashi. All rights reserved.
//

import UIKit
#if !RX_NO_MODULE
    import RxSwift
    import RxCocoa
#endif

let minimalUsernameLength = 5
let minimalPasswordLength = 8

class SimpleValidationViewController: ViewController {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var usernameCaution: UILabel!
    
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet var passwordCaution: UILabel!
    
    @IBOutlet weak var sendButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameCaution.text = "Username has to be at least \(minimalUsernameLength) characters"
        passwordCaution.text = "Password has to be at least \(minimalPasswordLength) characters"
        
        let usernameValid = usernameField.rx.text.orEmpty
            .map{ $0.characters.count >= minimalUsernameLength }
            .shareReplay(1) // ストリーム1つ (shareReplay(1) にしないとバインディングごとに1回実行されてしまう)
        
        let passwordValid = passwordField.rx.text.orEmpty
            .map { $0.characters.count >= minimalPasswordLength }
            .shareReplay(1)
        
        let sendBtnValid = Observable
            .combineLatest(usernameValid, passwordValid) { $0 && $1 }
            .shareReplay(1)

//        // フォーカスが当たったタイミングのハンドリングをしたかった
//        let usernameEditingValid = usernameField.rx.controlEvent(UIControlEvents.editingDidBegin)
//            .asObservable()
//            .map { (a) -> R in }
//            .bind(to: usernameCaution.isHidden)
//            .subscribe(onNext: { self.usernameCaution.isHidden = false })
//            .disposed(by: disposeBag)

        
        usernameValid
            .bind(to: passwordField.rx.isEnabled)
            .disposed(by: disposeBag)
        
        usernameValid
            .bind(to: usernameCaution.rx.isHidden)
            .disposed(by: disposeBag)
        
        passwordValid
            .bind(to: passwordCaution.rx.isHidden)
            .disposed(by: disposeBag)
        
        sendBtnValid
            .bind(to: sendButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        sendButton.rx.tap
            .subscribe(onNext: { [weak self] in self?.showAlert() })
            .disposed(by: disposeBag)
        
        self.usernameCaution.isHidden = true
        self.passwordCaution.isHidden = true
        self.passwordField.isSecureTextEntry = true
        
    }

    
    func showAlert() {
        let alertView = UIAlertView(
            title: "RxExample",
            message: "This is wonderful",
            delegate: nil,
            cancelButtonTitle: "OK"
        )
        alertView.show()
    }

}
