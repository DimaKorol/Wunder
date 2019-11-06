//
//  CarListItem+View.swift
//  Wunder
//
//  Created by Dima Korolev on 05/11/2019.
//  Copyright © 2019 Dima Korolev. All rights reserved.
//

import UIKit

import RxSwift

public protocol Reusable {
    static var reuseIdentifier: String { get }
}

extension Reusable {
    public static var reuseIdentifier: String { return String(describing: self) }
}

final class CarListItemCell: UITableViewCell, Reusable {
    
    private let carLabel = UILabel().mutate {
        $0.textColor = .title
        $0.font = UIFont.systemFont(ofSize: 14)
    }
    
    private let carDescription = UILabel().mutate {
        $0.textColor = .secondaryTitle
        $0.font = UIFont.systemFont(ofSize: 12)
    }
    
    private let taps = PublishSubject<Void>()
    
    private let disposable = SerialDisposable()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        assertionFailure("init(coder:) has not been implemented")
        return nil
    }
    
    deinit {
        disposable.dispose()
    }
    
    private func setup() {
        let content = UIStackView()
            .margins(t: 8, l: 24, b: 8, r: 24)
            .mutate {
                $0.translatesAutoresizingMaskIntoConstraints = false
                $0.axis = .vertical
                $0.spacing = 4
                [carLabel, carDescription].forEach($0.addArrangedSubview)
            }
        
        self.contentView.addSubview(content)
        NSLayoutConstraint.activate([
            content.topAnchor.constraint(equalTo: contentView.topAnchor),
            content.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            content.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            content.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        let tapRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(handlePan))
        self.contentView.addGestureRecognizer(tapRecognizer)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        unbind()
    }
    
    func bind(_ viewModel: CarListItemViewModel) {
        carLabel.text = viewModel.title
        carDescription.text = viewModel.details
        
        let disposable = CompositeDisposable()
        _ = disposable.insert(taps.subscribe(viewModel.action.tapped))
        self.disposable.disposable = disposable
    }
    
    func unbind() {
        disposable.disposable = Disposables.create()
    }
    
    @objc private func handlePan() {
        taps.onNext(Void())
    }
}

extension UIStackView {
    
    func margins(t: CGFloat = 0, l: CGFloat = 0, b: CGFloat = 0, r: CGFloat = 0, insetsFromSafeArea: Bool = false) -> Self {
        return mutate {
            $0.isLayoutMarginsRelativeArrangement = true
            $0.insetsLayoutMarginsFromSafeArea = insetsFromSafeArea
            $0.layoutMargins = UIEdgeInsets(top: t, left: l, bottom: b, right: r)
        }
    }
}
