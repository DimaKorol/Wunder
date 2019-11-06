//
//  TopBarView.swift
//  Wunder
//
//  Created by Dima Korolev on 05/11/2019.
//  Copyright © 2019 Dima Korolev. All rights reserved.
//

import UIKit

final class TopBarView: UIView {
    
    @objc let title = UILabel().mutate {
        $0.font = UIFont.boldSystemFont(ofSize: 18)
        $0.textColor = .primary
        $0.textAlignment = .center
    }
    
    @objc let backButton = UIButton().mutate {
        $0.setImage(Images.templateImage(.backArrow), for: .normal)
        $0.tintColor = .black
    }
    
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        assertionFailure("init(coder:) has not been implemented")
        return nil
    }
    
    private func setup() {
        self.backgroundColor = .white
        
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.2
        self.layer.shadowOffset = CGSize(width: 0, height: 1)
        
        [backButton, title].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            backButton.widthAnchor.constraint(equalToConstant: 44),
            backButton.heightAnchor.constraint(equalTo: backButton.widthAnchor),
            backButton.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor),
            backButton.topAnchor.constraint(greaterThanOrEqualTo: safeAreaLayoutGuide.topAnchor),
            backButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).mutate { $0.priority = .defaultHigh },
            backButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 10),
            
            title.centerXAnchor.constraint(equalTo: centerXAnchor),
            title.leftAnchor.constraint(equalTo: backButton.rightAnchor, constant: 8),
            title.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
            title.topAnchor.constraint(greaterThanOrEqualTo: safeAreaLayoutGuide.topAnchor),
            title.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).mutate { $0.priority = .defaultHigh },
        ])
    }
}
