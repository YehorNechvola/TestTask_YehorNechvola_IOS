//
//  CameraScreenViewModel.swift
//  TestTask_YehorNechvola
//
//  Created by Егор on 02.08.2023.
//

import Foundation

final class CameraScreenViewModel: NSObject {
    
    //MARK: - Properties
    
    private let cameraManager = CameraManager()
    private var cameraButtonType: СameraButtonType = .forPhotoCapture
    
    //MARK: - Methods
    
    func setupCamera(view: Any) {
        cameraManager.setupCamera(view: view)
    }
    
    func setupPreviewLayerFrame(view: Any) {
        cameraManager.setupPreviewLayerFrame(view: view)
    }
    
    func switchCamera() {
        cameraManager.switchCamera()
    }
    
    func capturePhotoOrVideo(completion: (Bool) -> Void) {
        
        switch cameraButtonType {
        case .forPhotoCapture:
            cameraManager.capturePhoto()
        case .forVideoRecording:
            cameraManager.isRecording ? cameraManager.stopRecording() : cameraManager.startRecording()
            completion(cameraManager.isRecording)
        }
    }
    
    func switchCameraButtonType(completion: (СameraButtonType) -> Void) {
        cameraButtonType == .forPhotoCapture ? (cameraButtonType = .forVideoRecording) : (cameraButtonType = .forPhotoCapture)
        completion(cameraButtonType)
    }
    
     func stopRecording() {
        cameraManager.stopRecording()
    }
}
