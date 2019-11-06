//
//  AttributedViewModel.swift
//  Wunder
//
//  Created by Dima Korolev on 04/11/2019.
//  Copyright © 2019 Dima Korolev. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift

struct AttributedViewModel {
    
    let title: Driver<String?>
    let image: Driver<UIImage?>
    let action: ActionViewModel
    
    init(
        title: Driver<String?> = .just(nil),
        image: Driver<UIImage?> = .just(nil),
        action: ActionViewModel = ActionViewModel()
    ) {
        self.title = title
        self.image = image
        self.action = action
    }
    
    init(
        title: String? = nil,
        image: UIImage? = nil,
        action: ActionViewModel = ActionViewModel()
    ) {
        self.init(
            title: .just(title),
            image: .just(image),
            action: action
        )
    }
}
