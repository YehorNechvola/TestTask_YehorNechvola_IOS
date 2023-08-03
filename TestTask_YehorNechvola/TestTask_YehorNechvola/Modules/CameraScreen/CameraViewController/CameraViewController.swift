//
//  CameraViewController.swift
//  TestTask_YehorNechvola
//
//  Created by Егор on 01.08.2023.
//

import UIKit


final class CameraViewController: UIViewController {
    
    //MARK: - UI Properties
    
    let switchCameraButton: UIButton = {
        let button = UIButton()
        let image = ConstantsCameraScreen.switchButtonImage
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(switchCameraButtonPressed), for: .touchUpInside)
        return button
    }()

    let captureImageButton: UIButton = {
        let width = ConstantsCameraScreen.captureImageButtonWidth
        let button = UIButton(frame: .init(x: 0, y: 0, width: width, height: width))
        button.backgroundColor = .white
        button.tintColor = .white
        button.layer.cornerRadius = button.frame.height / 2
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(captureImageButtonPressed), for: .touchUpInside)
        return button
    }()
    
    let photoVideoSegmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["PHOTO", "VIDEO"])
        segmentedControl.layer.cornerRadius = 10
        segmentedControl.setTitle("PHOTO", forSegmentAt: 0)
        segmentedControl.setTitle("VIDEO", forSegmentAt: 1)
        segmentedControl.backgroundColor = .gray
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged), for: .valueChanged)
        return segmentedControl
    }()
    
    //MARK: - ViewModel
    
    let cameraViewModel = CameraScreenViewModel()
    
    //MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addObserversForTerminateOrResignActiveState()
        cameraViewModel.setupCamera(view: view!)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        setupUI()
        cameraViewModel.setupPreviewLayerFrame(view: view!)
    }
    
    //MARK: - Methods
    
    private func setupUI() {
        view.backgroundColor = .black
        view.addSubview(switchCameraButton)
        view.addSubview(captureImageButton)
        view.addSubview(photoVideoSegmentedControl)

        switchCameraButton.widthAnchor.constraint(equalToConstant: ConstantsCameraScreen.switchCameraButtonWidth).isActive = true
        switchCameraButton.heightAnchor.constraint(equalToConstant: ConstantsCameraScreen.switchCameraButtonHeight).isActive = true
        switchCameraButton.bottomAnchor.constraint(equalTo: view.bottomAnchor,
                                                   constant: ConstantsCameraScreen.switchCameraButtonBottom).isActive = true
        switchCameraButton.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                     constant: ConstantsCameraScreen.switchCameraButtonTrailing).isActive = true

        captureImageButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        captureImageButton.bottomAnchor.constraint(equalTo: view.bottomAnchor,
                                                   constant: ConstantsCameraScreen.captureImageButtonBottom).isActive = true
        captureImageButton.widthAnchor.constraint(equalToConstant: ConstantsCameraScreen.captureImageButtonWidth).isActive = true
        captureImageButton.heightAnchor.constraint(equalToConstant: ConstantsCameraScreen.captureImageButtonWidth).isActive = true
        
        
        photoVideoSegmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        photoVideoSegmentedControl.widthAnchor.constraint(equalToConstant: ConstantsCameraScreen.photoVideoSegmentedControlWidth).isActive = true
        photoVideoSegmentedControl.heightAnchor.constraint(equalToConstant: ConstantsCameraScreen.photoVideoSegmentedControlHeight).isActive = true
        photoVideoSegmentedControl.bottomAnchor.constraint(equalTo: captureImageButton.topAnchor,
                                                           constant: ConstantsCameraScreen.photoVideoSegmentedControlBottom).isActive = true
    }
    
    private func addObserversForTerminateOrResignActiveState() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleUIWhenAppCloseOrBackground),
                                               name: UIApplication.willResignActiveNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleUIWhenAppCloseOrBackground),
                                               name: UIApplication.willTerminateNotification, object: nil)
    }
    
    //MARK: - Actions
    
    @objc private func switchCameraButtonPressed() {
        switchCameraButton.disableButtonFor(time: 0.7)
        cameraViewModel.switchCamera()
    }

    @objc private func captureImageButtonPressed() {
        cameraViewModel.capturePhotoOrVideo { [weak self] isRecordingVideo in
            self?.animateUI(isRecordingVideo)
        }
    }
    
    //MARK: - Animate UI
    
    private func animateUI(_ isRecordingVideo: Bool) {
        if isRecordingVideo {
            captureImageButton.disableButtonFor(time: 0.7)
            UIView.animate(withDuration: 0.5) {
                self.photoVideoSegmentedControl.isEnabled = false
                self.photoVideoSegmentedControl.alpha = 0
                self.captureImageButton.layer.cornerRadius = ConstantsCameraScreen.captureImageButtonCornerRadiusWhenRecording
                self.switchCameraButton.isEnabled = false
                self.switchCameraButton.alpha = 0
            }
        } else {
            UIView.animate(withDuration: 0.5) {
                self.photoVideoSegmentedControl.isEnabled = true
                self.switchCameraButton.isEnabled = true
                self.switchCameraButton.alpha = 1
                self.captureImageButton.layer.cornerRadius = self.captureImageButton.frame.width / 2
            }
        }
    }
    
    @objc private func segmentedControlValueChanged() {
        cameraViewModel.switchCameraButtonType { [weak self] captureButtonType in
            switch captureButtonType {
            case .forPhotoCapture:
                self?.captureImageButton.backgroundColor = .white
            case .forVideoRecording:
                self?.captureImageButton.backgroundColor = .red
            }
        }
    }
    
    @objc private func handleUIWhenAppCloseOrBackground() {
        cameraViewModel.stopRecording()
        captureImageButton.layer.cornerRadius = captureImageButton.frame.width / 2
        photoVideoSegmentedControl.isEnabled = true
        switchCameraButton.isEnabled = true
        switchCameraButton.alpha = 1
    }
}

