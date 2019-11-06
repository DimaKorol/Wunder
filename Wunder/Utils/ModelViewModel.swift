//
//  ModelViewModel.swift
//  Wunder
//
//  Created by Dima Korolev on 05/11/2019.
//  Copyright © 2019 Dima Korolev. All rights reserved.
//

import Foundation
import RxSwift

protocol ViewProtocol {
    associatedtype ViewModel
    func bind(_ viewModel: ViewModel) -> Disposable
}
