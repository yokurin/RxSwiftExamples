//
//  ViewController.swift
//  RxSwiftExamples
//
//  Created by 林　翼 on 2017/06/02.
//  Copyright © 2017年 Tsubasa Hayashi. All rights reserved.
//

import UIKit
#if !RX_NO_MODULE
    import RxSwift
#endif


class ViewController: UIViewController {
    #if TRACE_RESOURCES
    #if !RX_NO_MODULE
    private let startResourceCount = RxSwift.Resources.total
    #else
    private let startResourceCount = Resources.total
    #endif
    #endif
    
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        #if TRACE_RESOURCES
            print("Number of start resources = \(Resources.total)")
        #endif
    }
    
    deinit {
        #if TRACE_RESOURCES
            print("View controller disposed with \(Resources.total) resources")
            
            
            let numberOfResourcesThatShouldRemain = startResourceCount
            let mainQueue = DispatchQueue.main
            
            
            mainQueue.asyncAfter (deadline: when) {
                assert(Resources.total <= numberOfResourcesThatShouldRemain, "Resources weren't cleaned properly, \(Resources.total) remained, \(numberOfResourcesThatShouldRemain) expected")
            }
        #endif
    }
}
