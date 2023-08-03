//
//  ConstantsCameraScreen.swift
//  TestTask_YehorNechvola
//
//  Created by Егор on 02.08.2023.
//

import UIKit

//MARK: - Constants for UI elements

enum ConstantsCameraScreen {
    
    //MARK: - Images
    
    static let switchButtonImage = UIImage(named: "switchCamera")
    
    //MARK: - Constraints
    
    static let switchCameraButtonWidth: CGFloat = 45
    static let switchCameraButtonHeight: CGFloat = 40
    static let switchCameraButtonBottom: CGFloat = -40
    static let switchCameraButtonTrailing: CGFloat = -40
    
    static let captureImageButtonBottom: CGFloat = -20
    static let captureImageButtonWidth: CGFloat = 80
    static let captureImageButtonCornerRadiusWhenRecording: CGFloat = 10
    
    static let photoVideoSegmentedControlWidth: CGFloat = 150
    static let photoVideoSegmentedControlHeight: CGFloat = 40
    static let photoVideoSegmentedControlBottom: CGFloat = -10
}
