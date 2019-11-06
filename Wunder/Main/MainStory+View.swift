//
//  MainStory+View.swift
//  Wunder
//
//  Created by Dima Korolev on 05/11/2019.
//  Copyright © 2019 Dima Korolev. All rights reserved.
//

import UIKit
import RxSwift

final class MainStoryViewController: UINavigationController {
    
    enum Screen: StoryScreenView {
        case main(MainScreenViewController)
        case map(MapScreenViewController)
        case list(CarListScreenViewController)
        
        var controller: UIViewController {
            switch self {
            case let .main(controller): return controller
            case let .map(controller): return controller
            case let .list(controller): return controller
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isNavigationBarHidden = true
    }
}

extension MainStoryViewController: MainStoryView {
    
    func bind(_ viewModel: MainStoryViewModel) -> Disposable {
        return self.bind(viewModel.storyStep) { viewModel -> (Screen, Disposable) in
            switch viewModel {
            case let .main(viewModel):
                let controller = MainScreenViewController()
                return (.main(controller), controller.bind(viewModel))
            case let .map(viewModel):
                let controller = MapScreenViewController()
                return (.map(controller), controller.bind(viewModel))
            case let .list(viewModel):
                let controller = CarListScreenViewController()
                return (.list(controller), controller.bind(viewModel))
            }
        }
    }
}
