//
//  UIButton+Extension.swift
//  TestTask_YehorNechvola
//
//  Created by Егор on 03.08.2023.
//

import UIKit

extension UIButton {
    
    //MARK: - Disable button after tap
    
    func disableButtonFor(time: Double) {
        self.isEnabled = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + time) {
            self.isEnabled = true
        }
    }
}
