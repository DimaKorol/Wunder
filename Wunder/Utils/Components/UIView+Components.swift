//
//  UIView+Components.swift
//  Wunder
//
//  Created by Dima Korolev on 04/11/2019.
//  Copyright © 2019 Dima Korolev. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift

extension UIButton {
    
    func bind(_ actionViewModel: ActionViewModel) -> Disposable {
        let disposable = CompositeDisposable()
        _ = disposable.insert(rx.tap.subscribe(actionViewModel.tapped))
        _ = disposable.insert(actionViewModel.enable.drive(rx.isEnabled))
        return disposable
    }
    
    func bind(_ attributedViewModel: AttributedViewModel) -> Disposable {
        let disposable = CompositeDisposable()
        _ = disposable.insert(bind(attributedViewModel.action))
        _ = disposable.insert(attributedViewModel.title.drive(rx.title()))
        _ = disposable.insert(attributedViewModel.image.drive(rx.image()))
        return disposable
    }
}
