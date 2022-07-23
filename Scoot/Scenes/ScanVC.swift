//
//  ScanVC.swift
//  Scoot
//
//  Created by Profico on 22.07.2022..
//

import UIKit
import AVFoundation

class ScanVC: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Scan to ride"
        label.textColor = .systemBackground
        label.font = .systemFont(ofSize: 28, weight: .bold)
        
        return label
    }()
    
    private var subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Scan the barcode on the side of the vehicle"
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .systemBackground
        label.numberOfLines = 2
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        
        return label
    }()
    
    private let exitButton: UIButton = {
        let button = UIButton()
        button.frame = CGRect(x: 160, y: 100, width: 30, height: 30)
        button.layer.cornerRadius = 0.5 * button.bounds.size.width
        button.clipsToBounds = true
        button.setImage(UIImage(named: "x"), for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.tintColor = .white
        button.backgroundColor = .black
        
        return button
    }()
    
    private let flashButton: UIButton = {
        let button = UIButton()
        button.frame = CGRect(x: 160, y: 100, width: 88, height: 88)
        button.layer.cornerRadius = 0.5 * button.bounds.size.width
        button.clipsToBounds = true
        let origImage = UIImage(named: "flashImage")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.tintColor = .black
        button.backgroundColor = .white
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        reStart()
        addSubviews()
        navigationItem.hidesBackButton = true
        
        view.isUserInteractionEnabled = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configureConstraints()
        configureExitButton()
        configureFlashButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if (captureSession?.isRunning == false) {
            captureSession.startRunning()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if (captureSession?.isRunning == true) {
            captureSession.stopRunning()
        }
    }
}

extension ScanVC {
    private func addSubviews() {
        let overlay = createOverlay(frame: view.frame, xOffset: view.frame.midX, yOffset: view.frame.midY, radius: 50.0)
        view.bringSubviewToFront(overlay)
        view.addSubview(overlay)
        
        view.addSubview(titleLabel)
        view.bringSubviewToFront(titleLabel)
        
        view.addSubview(subtitleLabel)
        view.bringSubviewToFront(subtitleLabel)
        
        view.addSubview(exitButton)
        view.bringSubviewToFront(exitButton)
        
        view.addSubview(flashButton)
        view.bringSubviewToFront(flashButton)
    }
    
    private func configureConstraints() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(98)
            $0.centerX.equalToSuperview()
        }
        
        subtitleLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(100)
            $0.top.equalTo(titleLabel.snp.bottom).offset(7)
        }
        
        exitButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.top.equalToSuperview().offset(98)
            $0.width.height.equalTo(30)
        }
        
        flashButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-52)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(88)
        }
    }
    
    private func configureExitButton() {
        exitButton.addTarget(self, action: #selector(didTapExit), for: .touchUpInside)
    }
    
    @objc private func didTapExit() {
        self.dismiss(animated: true)
    }
    
    private func configureFlashButton() {
        flashButton.addTarget(self, action: #selector(didTapToggleFlash), for: .touchUpInside)
    }
    
    @objc private func didTapToggleFlash() {
        toggleFlash()
    }
    
    func createOverlay(frame: CGRect, xOffset: CGFloat, yOffset: CGFloat, radius: CGFloat) -> UIView {
        
        let overlayView = UIView(frame: frame)
        overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        
        let path = CGMutablePath()
        let framePath = CGMutablePath()
        
        framePath.addRoundedRect(in: CGRect(x: UIScreen.main.bounds.width / 2 - 151, y: UIScreen.main.bounds.height / 2 - 151, width: 302, height: 302), cornerWidth: 16, cornerHeight: 16)
        framePath.closeSubpath()
        
        path.addRoundedRect(in: CGRect(x: UIScreen.main.bounds.width / 2 - 150, y: UIScreen.main.bounds.height / 2 - 150, width: 300, height: 300), cornerWidth: 16, cornerHeight: 16)
        path.closeSubpath()
        
        let size = CGSize(width: UIScreen.main.bounds.size.width + 10, height: UIScreen.main.bounds.size.height + 10)
        path.addRect(CGRect(origin: .zero, size: size))
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = path
        maskLayer.fillRule = .evenOdd
        overlayView.layer.mask = maskLayer
        overlayView.clipsToBounds = false
        
        let borderLayer = CAShapeLayer()
        borderLayer.path = framePath
        borderLayer.lineWidth = 3
        borderLayer.strokeColor = UIColor.white.cgColor
        borderLayer.fillColor = UIColor.clear.cgColor
        
        overlayView.layer.addSublayer(borderLayer)
        
        return overlayView
    }
}

extension ScanVC {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession.stopRunning()
        
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            found(code: stringValue)
            
        }
    }
    
    private func presentModal(vehicle: VehicleModel) {
        let detailViewController = VehicleDetailVC(vehicle: vehicle, afterScan: true)
        let nav = UINavigationController(rootViewController: detailViewController)
        nav.modalPresentationStyle = .overFullScreen
        present(nav, animated: true, completion: nil)
    }
    
    func found(code: String) {
        print("otvori vozilo \(code)")
        
        presentModal(vehicle: VehicleModel(type: .scooter, status: .available, battery: 99, price: 130, location: "0", name: "meepo shuffle s (v4s)", image: "scooterImage", id: "3"))
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    func reStart(){
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = .high
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }
        
        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            failed()
            
            return
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        
        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            failed()
            return
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = self.view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        
        captureSession.startRunning()
    }
    
    func failed() {
        let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        captureSession = nil
    }
    
    func toggleFlash() {
        guard let device = AVCaptureDevice.default(for: AVMediaType.video) else { return }
        guard device.hasTorch else { return }

        do {
            try device.lockForConfiguration()

            if (device.torchMode == AVCaptureDevice.TorchMode.on) {
                device.torchMode = AVCaptureDevice.TorchMode.off
            } else {
                do {
                    try device.setTorchModeOn(level: 1.0)
                } catch {
                    print(error)
                }
            }
            device.unlockForConfiguration()
        } catch {
            print(error)
        }
    }
}
