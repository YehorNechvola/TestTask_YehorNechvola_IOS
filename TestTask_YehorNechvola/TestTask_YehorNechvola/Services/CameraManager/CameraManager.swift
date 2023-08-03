//
//  CameraManager.swift
//  TestTask_YehorNechvola
//
//  Created by Егор on 01.08.2023.
//

import UIKit
import AVFoundation

final class CameraManager: NSObject {
    
    //MARK: - Properties
    
    private var captureSession = AVCaptureSession()
    private var photoOutput = AVCapturePhotoOutput()
    private var previewLayer = AVCaptureVideoPreviewLayer()
    private var movieOutput = AVCaptureMovieFileOutput()
    var isRecording = false
    
    //MARK: - Methods Setup Camera
    
    func setupPreviewLayerFrame(view: Any) {
        let view = view as! UIView
        previewLayer.frame = view.bounds
    }
    
    func setupCamera(view: Any) {
        let view = view as! UIView
        
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        guard let audioDevice = AVCaptureDevice.default(for: .audio) else { return }
        
        do {
            let audioInput = try AVCaptureDeviceInput(device: audioDevice)
            if captureSession.canAddInput(audioInput) {
                captureSession.addInput(audioInput)
            }
        } catch {
            print("Error setting up audio input: \(error.localizedDescription)")
        }
        
        do {
            let input = try AVCaptureDeviceInput(device: videoCaptureDevice)
            captureSession.addInput(input)
            captureSession.addOutput(photoOutput)
        
            if captureSession.canAddOutput(movieOutput) {
                captureSession.addOutput(movieOutput)
            }
            
            previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
            previewLayer.connection?.videoOrientation = .portrait
            view.layer.insertSublayer(previewLayer, at: 0)
            
            DispatchQueue.global(qos: .userInteractive).async {
                self.captureSession.startRunning()
            }
            
        } catch {
            print("Error setting up camera: \(error.localizedDescription)")
        }
    }
    
    func capturePhoto() {
        let settings = AVCapturePhotoSettings()
        photoOutput.capturePhoto(with: settings, delegate: self)
    }
    
    func switchCamera() {
        guard let currentCameraInput = captureSession.inputs.last as? AVCaptureDeviceInput else { return }
        guard let videoCaptureDevice = (currentCameraInput.device.position == .back) ?
                AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) :
                    AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else { return }
        
        do {
            let newInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
            captureSession.beginConfiguration()
            captureSession.removeInput(currentCameraInput)
            
            if captureSession.canAddInput(newInput) {
                captureSession.addInput(newInput)
            }
            
            captureSession.commitConfiguration()
        } catch {
            print("Error switching camera: \(error.localizedDescription)")
        }
    }
    
    func startRecording() {
        if movieOutput.isRecording == false {
            let videoConnection = movieOutput.connection(with: .video)
            
            if videoConnection != nil {
                movieOutput.startRecording(to: newRecordingURL(), recordingDelegate: self)
                isRecording = true
            }
        }
    }
    
    func stopRecording() {
        if movieOutput.isRecording == true {
            movieOutput.stopRecording()
            isRecording = false
        }
    }
    
    private func newRecordingURL() -> URL {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd-HHmmss"
        let dateString = dateFormatter.string(from: Date())
        let fileName = "video-\(dateString).mp4"
        let url = documentsDirectory.appendingPathComponent(fileName)
        return url
    }
}

//MARK: - AVCapturePhotoCaptureDelegate

extension CameraManager: AVCapturePhotoCaptureDelegate {
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let error = error {
            print("Error capturing photo: \(error.localizedDescription)")
            return
        }
        
        if let imageData = photo.fileDataRepresentation() {
            if let image = UIImage(data: imageData) {
                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            }
        }
    }
}

//MARK: - AVCaptureFileOutputRecordingDelegate

extension CameraManager: AVCaptureFileOutputRecordingDelegate {

    func fileOutput(_ output: AVCaptureFileOutput,
                    didFinishRecordingTo outputFileURL: URL,
                    from connections: [AVCaptureConnection],
                    error: Error?) {
        
        if let error = error {
            print("Error recording video: \(error.localizedDescription)")
            return
        }
        
        if UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(outputFileURL.path) {
            UISaveVideoAtPathToSavedPhotosAlbum(outputFileURL.path, nil, nil, nil)
        }
    }
}
