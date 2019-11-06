//
//  Story.swift
//  Wunder
//
//  Created by Dima Korolev on 05/11/2019.
//  Copyright © 2019 Dima Korolev. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

enum StoryStep<Screen> {
    case push(Screen)
    case pop
    case popToRoot
    case replaceAll(with: Screen)
}

protocol StoryProtocol {
    associatedtype Screen
    func handle(step: StoryStep<Screen>)
}

final class Story<Screen>: StoryProtocol {
    
    var screen: Driver<Screen> {
        return screenSubject.asDriver().ignoreNil()
    }
    
    var step: Driver<StoryStep<Screen>> {
        return stepSubject.asDriver()
    }
    
    private var screens: [Screen] = [] {
        didSet { screenSubject.accept(screens.last.expectedValue()) }
    }
    
    private let stepSubject: BehaviorRelay<StoryStep<Screen>>
    private let screenSubject = BehaviorRelay<Screen?>(value: nil)
    private let disposableBag = DisposeBag()
    
    init(initial screen: Screen) {
        stepSubject = BehaviorRelay(value: .replaceAll(with: screen))
        
        disposableBag.insert(
            stepSubject.subscribe(onNext: { [weak self] in
                guard let sself = self.expectedValue() else { return }
                switch $0 {
                case let .push(screen):
                    sself.screens = sself.screens + [screen]
                case .pop:
                    sself.screens = sself.screens.dropLast()
                case .popToRoot:
                    sself.screens = sself.screens.first.map { [$0] } ?? []
                case let .replaceAll(with: screen):
                    sself.screens = [screen]
                }
            })
        )
    }
    
    func handle(step: StoryStep<Screen>) {
        stepSubject.accept(step)
    }
}

protocol StoryScreenView {
    var controller: UIViewController { get }
}

protocol StoryView: class, StoryProtocol where Screen == UIViewController {}

extension StoryView {
    
    func handle<Screen: StoryScreenView>(step: StoryStep<Screen>) {
        handle(step: step.map { $0.controller })
    }
}

extension StoryStep {
    
    func map<T>(_ transform: (Screen) -> T) -> StoryStep<T> {
        switch self {
        case let .push(screen): return .push(transform(screen))
        case .pop: return .pop
        case .popToRoot: return .popToRoot
        case let .replaceAll(with: screen): return .replaceAll(with: transform(screen))
        }
    }
}

extension UINavigationController: StoryView {
    
    func handle(step: StoryStep<UIViewController>) {
        switch step {
        case let .push(screen):
            pushViewController(screen, animated: true)
        case .pop:
            popViewController(animated: true)
        case .popToRoot:
            popToRootViewController(animated: true)
        case let .replaceAll(with: screen):
            setViewControllers([screen], animated: true)
        }
    }
}

extension StoryView {
    
    func bind<View: StoryScreenView, ViewModel>(
        _ steps: Driver<StoryStep<ViewModel>>,
        _ bind: @escaping (ViewModel) -> (View, Disposable)
    ) -> Disposable {
        let compositeDisposable = CompositeDisposable()
        
        var disposables: [Disposable] = []
        _ = compositeDisposable.insert(
            steps.drive(onNext: { [weak self] step in
                guard let sself = self else { return }
                
                // unbind if needed
                switch step {
                case .pop:
                    disposables.last.expectedValue()?.dispose()
                    disposables = disposables.dropLast()
                case .popToRoot:
                    disposables.dropFirst().forEach { $0.dispose() }
                    disposables = disposables.first.expectedValue().map { [$0] } ?? []
                case .replaceAll:
                    disposables.forEach { $0.dispose() }
                    disposables = []
                case .push: break
                }
                
                sself.handle(step: step.map { viewModel in
                    let (view, viewDisposable) = bind(viewModel)
                    disposables.append(viewDisposable)
                    return view.controller
                })
            })
        )
        
        _ = compositeDisposable.insert(Disposables.create {
            disposables.forEach { $0.dispose() }
        })
        
        return compositeDisposable
    }
}
