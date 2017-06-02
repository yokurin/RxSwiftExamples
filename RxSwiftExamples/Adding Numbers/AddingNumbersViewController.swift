//
//  AddingNumbersViewController.swift
//  RxSwiftExamples
//
//  Created by 林　翼 on 2017/06/02.
//  Copyright © 2017年 Tsubasa Hayashi. All rights reserved.
//

import UIKit
#if !RX_NO_MODULE
    import RxSwift
    import RxCocoa
#endif

class AddingNumbersViewController: ViewController {

    @IBOutlet weak var number1: UITextField!
    @IBOutlet weak var number2: UITextField!
    @IBOutlet weak var number3: UITextField!
    
    @IBOutlet weak var resultLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Adding Numbers"
        Observable.combineLatest(number1.rx.text.orEmpty, number2.rx.text.orEmpty, number3.rx.text.orEmpty) { val1, val2, val3 -> Int in
                return (Int(val1) ?? 0) + (Int(val2) ?? 0) + (Int(val3) ?? 0)
            }
            .map { $0.description }
            .bind(to: self.resultLabel.rx.text)
            .disposed(by: disposeBag)
    }

}
