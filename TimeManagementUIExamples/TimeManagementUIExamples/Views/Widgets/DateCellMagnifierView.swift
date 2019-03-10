//
//  DateCellMagnifierView.swift
//  TimeManagementUIExamples
//
//  Created by Jonas Maier on 09.03.19.
//  Copyright © 2019 adabay GmbH. All rights reserved.
//

import Foundation
import UIKit

class DateCellMagnifierView: UIView {
    
    let mainContainer: UIView
    let arrowView: UIView
    let dateLabel: UILabel
    
    init() {
        mainContainer = UIView()
        arrowView = UIView()
        dateLabel = UILabel()
        
        super.init(frame: .zero)
        
        setupSubviews()
        addSubviews()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        layer.shadowOpacity = 0.5
        
        mainContainer.backgroundColor = .white
        mainContainer.layer.cornerRadius = 5.0
        
        arrowView.backgroundColor = .white
        arrowView.transform = CGAffineTransform(rotationAngle: .pi / 4.0)
        arrowView.layer.cornerRadius = 3.0
        
        dateLabel.text = "test"
    }
    
    private func addSubviews() {
        addSubview(arrowView)
        addSubview(mainContainer)
        mainContainer.addSubview(dateLabel)
    }
    
    private func setupConstraints() {
        (subviews + mainContainer.subviews).forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        NSLayoutConstraint.activate([
            mainContainer.topAnchor.constraint(equalTo: topAnchor),
            mainContainer.trailingAnchor.constraint(equalTo: trailingAnchor),
            mainContainer.leadingAnchor.constraint(equalTo: leadingAnchor),
            arrowView.centerYAnchor.constraint(equalTo: mainContainer.bottomAnchor, constant: -5),
            arrowView.centerXAnchor.constraint(equalTo: mainContainer.centerXAnchor),
            arrowView.widthAnchor.constraint(equalToConstant: 20),
            arrowView.widthAnchor.constraint(equalTo: arrowView.heightAnchor),
            arrowView.bottomAnchor.constraint(equalTo: bottomAnchor),
            dateLabel.topAnchor.constraint(equalTo: mainContainer.topAnchor, constant: 8),
            dateLabel.trailingAnchor.constraint(equalTo: mainContainer.trailingAnchor, constant: -8),
            dateLabel.bottomAnchor.constraint(equalTo: mainContainer.bottomAnchor, constant: -8),
            dateLabel.leadingAnchor.constraint(equalTo: mainContainer.leadingAnchor, constant: 8)
        ])
    }
}
