//
//  GeolocationViewController.swift
//  RxSwiftExamples
//
//  Created by 林　翼 on 2017/06/21.
//  Copyright © 2017年 Tsubasa Hayashi. All rights reserved.
//

import UIKit
import CoreLocation
#if !RX_NO_MODULE
    import RxSwift
    import RxCocoa
#endif

private extension Reactive where Base: UILabel {
    var coordinates: UIBindingObserver<Base, CLLocationCoordinate2D> {
        return UIBindingObserver(UIElement: base) { label, location in
            label.text = "Lat: \(location.latitude)\nLon: \(location.longitude)"
        }
    }
}

class GeolocationViewController: ViewController {

    @IBOutlet var noGeoLocationView: UIView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var button2: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(noGeoLocationView)
        
        let geolocationService = GeolocationService.instance
        
        geolocationService.authorized
            .drive(noGeoLocationView.rx.isHidden)
            .disposed(by: disposeBag)
        
        geolocationService.location
            .drive(label.rx.coordinates)
            .disposed(by: disposeBag)
        
        button.rx.tap
            .bind { [weak self] in
                self?.openAppPreferences()
            }
            .disposed(by: disposeBag)
        
        button2.rx.tap
            .bind { [weak self] in
                self?.openAppPreferences()
            }
            .disposed(by: disposeBag)
    }
    
    private func openAppPreferences() {
        UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!)
    }
    
}
