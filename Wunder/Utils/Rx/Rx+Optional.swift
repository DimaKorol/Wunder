//
//  Rx+Optional.swift
//  Wunder
//
//  Created by Dima Korolev on 05/11/2019.
//  Copyright © 2019 Dima Korolev. All rights reserved.
//

import RxSwift
import RxCocoa

extension ObservableType where Element: OptionalProtocol {
    
    func ignoreNil() -> Observable<Element.Wrapped> {
        return flatMapLatest { $0.value.map(Observable.just) ?? .empty() }
    }
}

extension Driver where Element: OptionalProtocol {
    
    func ignoreNil() -> Driver<Element.Wrapped> {
        return flatMapLatest { $0.value.map { .just($0) } ?? .empty() }
    }
}
