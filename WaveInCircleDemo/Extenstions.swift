//
//  Extenstions.swift
//  RDWaveDemo
//
//  Created by 鞠汶成 on 04/08/2017.
//  Copyright © 2017 鞠汶成. All rights reserved.
//

import UIKit

extension UIView {
    func addLayoutConstraint(with format: String, views: UIView...) {
        var viewsDictionary: [String: UIView] = [:]
        for (index, view) in views.enumerated() {
            let key: String = "v\(index)"
            viewsDictionary[key] = view
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: .alignAllLeading, metrics: nil, views: viewsDictionary as [String : Any]))
    }
    
    func addLayoutConstraint(with format: String, views: UIView..., metrics: [String : Any]?) {
        var viewsDictionary: [String: UIView] = [:]
        for (index, view) in views.enumerated() {
            let key: String = "v\(index)"
            viewsDictionary[key] = view
        }
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: .alignAllLeading, metrics: metrics, views: viewsDictionary as [String : Any]))
    }
}
