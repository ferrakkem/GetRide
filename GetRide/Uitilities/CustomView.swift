//
//  CustomView.swift
//  Giphy
//
//  Created by Ferrakkem Bhuiyan on 2020-11-24.
//

import UIKit

class CustomView: UIView {
    
    
    func customView(userview: UIView){
        userview.layer.shadowColor = UIColor.gray.cgColor
        userview.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        userview.layer.shadowOpacity = 2.0
        userview.layer.masksToBounds = false
        userview.layer.cornerRadius = 10.0
    }
    
    func shadowDecorate(userview: UIView) {
        let radius: CGFloat = 10
        userview.layer.cornerRadius = radius
        userview.layer.borderWidth = 1
        userview.layer.borderColor = UIColor.clear.cgColor
        userview.layer.masksToBounds = true
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 1.0)
        layer.shadowRadius = 2.0
        layer.shadowOpacity = 0.5
        layer.masksToBounds = true

        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: radius).cgPath
        layer.cornerRadius = radius
    }
    
}

extension UICollectionView {
    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center;
        messageLabel.font = UIFont(name: "TrebuchetMS", size: 15)
        messageLabel.sizeToFit()

        self.backgroundView = messageLabel;
    }

    func restore() {
        self.backgroundView = nil
    }
}
