//
//  RxHistory.swift
//  WunderTests
//
//  Created by Dima Korolev on 05/11/2019.
//  Copyright © 2019 Dima Korolev. All rights reserved.
//

import RxSwift

final class RxHistory<Value> {
    
    let disposeBag = DisposeBag()
    
    private(set) var isCompleted = false
    private(set) var isDisposed = false
    private(set) var error: Error! = nil
    private(set) var values: [Value] = []
    
    var value: Value! {
        return values.last
    }
    
    init(_ observable: Observable<Value>) {
        disposeBag.insert(observable.subscribe(
            onNext: { [weak self] in self?.values.append($0) },
            onError: { [weak self] in self?.error = $0 },
            onCompleted: { [weak self] in self?.isCompleted = true },
            onDisposed: { [weak self] in self?.isCompleted = true }
        ))
    }
}

extension ObservableType {
    
    func history() -> RxHistory<Element> {
        return RxHistory(self.asObservable())
    }
}
