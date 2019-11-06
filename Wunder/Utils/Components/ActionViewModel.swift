//
//  ActionViewModel.swift
//  Wunder
//
//  Created by Dima Korolev on 05/11/2019.
//  Copyright © 2019 Dima Korolev. All rights reserved.
//

import RxCocoa
import RxSwift

struct ActionViewModel {
    
    let tapped: AnyObserver<Void>
    let enable: Driver<Bool>
    
    var values: Observable<Void> {
        return tapSubject.asObservable()
    }
    
    private let tapSubject = PublishSubject<Void>()
    
    init(enable: Driver<Bool> = .just(true)) {
        self.tapped = tapSubject.asObserver()
        self.enable = enable
    }
}
