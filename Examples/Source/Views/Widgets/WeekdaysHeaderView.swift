//
//  WeekdaysHeaderView.swift
//  TimeManagementUIExamples
//
//  Created by Jonas Maier on 22.02.19.
//  Copyright © 2019 Jonas Maier. All rights reserved.
//

import Foundation
import UIKit

class WeekdaysHeaderView: UIView {
    
    let stackView = UIStackView()
    
    init() {
        super.init(frame: .zero)
        
        setupSubviews()
        addSubviews()
        setupLayoutConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        backgroundColor = UIColor(red: 40/255, green: 146/255, blue: 215/255, alpha: 1.0)
        
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 0
    }
    
    private func addSubviews() {
        addSubview(stackView)
        
        ["M", "D", "M", "D", "F", "S", "S"]
            .map {
                let label = UILabel()
                label.textAlignment = .center
                label.textColor = .white
                label.text = $0
                return label
            }.forEach {
                stackView.addArrangedSubview($0)
        }
    }
    
    private func setupLayoutConstraints() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 8),
            stackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -8),
            stackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor)
        ])
    }
}
