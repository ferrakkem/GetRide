//
//  ViewController.swift
//  GetRide
//
//  Created by Ferrakkem Bhuiyan on 2021-01-06.
//

import UIKit


extension UIViewController{
    
    //MARK: - Custom alert
    public func openAlert(title: String,
                          message: String,
                          alertStyle:UIAlertController.Style,
                          actionTitles:[String],
                          actionStyles:[UIAlertAction.Style],
                          actions: [((UIAlertAction) -> Void)]){
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: alertStyle)
        for(index, indexTitle) in actionTitles.enumerated(){
            //print("\(index) \(indexTitle)")
            let action = UIAlertAction(title: indexTitle, style: actionStyles[index], handler: actions[index])
            alertController.addAction(action)
        }
        
        DispatchQueue.main.async { [weak self] in
            self?.present(alertController, animated: true)
        }
    }
    
    
    //MARK: - Open Settings view
    public func createSettingsAlertController(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)

        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil)
        let settingsAction = UIAlertAction(title: NSLocalizedString("Settings", comment: ""), style: .default) { (UIAlertAction) in
            
            if let bundleId = Bundle.main.bundleIdentifier,
                let url = URL(string: "\(UIApplication.openSettingsURLString)&path=LOCATION/\(bundleId)")
            {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(settingsAction)
        
        DispatchQueue.main.async { [weak self] in
            self?.present(alertController, animated: true, completion: nil)
        }
        
    }
}
