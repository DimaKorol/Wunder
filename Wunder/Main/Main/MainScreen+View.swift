//
//  MainScreen+View.swift
//  Wunder
//
//  Created by Dima Korolev on 05/11/2019.
//  Copyright © 2019 Dima Korolev. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class MainScreenViewController: UIViewController {
    
    private let listButton = UIButton().mutate {
        $0.setTitleColor(.black, for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 16)
    }
    
    private let mapButton = UIButton().mutate {
        $0.setTitleColor(.black, for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 16)
    }
    
    private let topBar = TopBarView().mutate {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backButton.isHidden = true
        $0.title.text = Strings.localized(.mainScreenTitle)
    }
    
    private let mainImage = UIImageView().mutate {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.image = Images.bundleImage(.mainPlaceholder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        let buttons = UIStackView()
            .mutate {
                $0.translatesAutoresizingMaskIntoConstraints = false
                $0.setContentHuggingPriority(.defaultLow, for: .vertical)
                $0.axis = .vertical
                $0.alignment = .center
                $0.spacing = 16
                [listButton, mapButton].forEach($0.addArrangedSubview)
            }
        
        [topBar, buttons, mainImage].forEach(view.addSubview)
        
        NSLayoutConstraint.activate([
            topBar.topAnchor.constraint(equalTo: view.topAnchor),
            topBar.leftAnchor.constraint(equalTo: view.leftAnchor),
            topBar.rightAnchor.constraint(equalTo: view.rightAnchor),
            
            mainImage.leftAnchor.constraint(greaterThanOrEqualTo: view.leftAnchor),
            mainImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mainImage.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor, constant: -80),
            
            buttons.leftAnchor.constraint(equalTo: view.leftAnchor),
            buttons.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttons.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -48)
        ])
    }
}

extension MainScreenViewController: MainScreenView {
    
    func bind(_ viewModel: MainScreenViewModel) -> Disposable {
        let disposable = CompositeDisposable()
        _ = disposable.insert(listButton.bind(viewModel.listAction))
        _ = disposable.insert(mapButton.bind(viewModel.mapAction))
        return disposable
    }
}
