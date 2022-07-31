//
//  RideInProgressVC.swift
//  Scoot
//
//  Created by Luka Vujnovac on 27.07.2022..
//

import UIKit
import Reachability

class RideInProgressVC: UIViewController {
    
    private let progressImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "ellipseImage")
        
        return iv
    }()
    
    private var timerLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 32, weight: .semibold)
        label.textColor = .label
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        
        return label
    }()
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "RIDE IN PROGRESS"
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .scootLoginGreen
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        
        return label 
    }()
    
    private var sliderLabel: UILabel = {
        let label = UILabel()
        label.text = "SLIDE TO FINISH RIDE"
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .scootLoginGreen
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        
        return label 
    }()
    
    private var slider = ScootSlider()
    
    private var timer = Timer()
    private var timerCount = 1
    private var rotationAngle: CGFloat = CGFloat(0)
    private let reachability = try! Reachability()
    
    var vehicleId: String
    
    init(vehicle: String) {
        self.vehicleId = vehicle
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubviews()
        
        view.backgroundColor = .systemBackground
        
        navigationItem.hidesBackButton = true
        
        configureTimer()
        
        progressImageView.rotate()
        
        slider.addTarget(self, action: #selector(sliderChanged), for: .valueChanged)
        
        if UserDefaults.standard.getTimerStart() != nil {
            
            let date = UserDefaults.standard.getTimerStart() as! Date
            let difference = Date.getTimeInterval(lhs: Date(), rhs: date)
            timerCount = Int(difference)
        }
       
    }
    
    @objc private func sliderChanged() {
        if slider.value == 1 {
            sliderLabel.text = "COMPLETED!" 
            sliderLabel.textColor = .systemBackground
            titleLabel.text = "COMPLETED!"
            timer.invalidate()
            slider.isEnabled = false
            UserDefaults.standard.setTimer(value: self.timerLabel.text ?? "0s")
            
            reachability.whenReachable = {_ in 
                self.navigationController?.pushViewController(RideCompletedVC(), animated: true)
                
                ApiCaller.shared.cancelRide(vehicleId: self.vehicleId)
            }
            reachability.whenUnreachable = {_ in 
                UserDefaults.standard.setTimerStart(date: nil)
            }
            do {
                try reachability.startNotifier()
            }catch {
                print("unable to start notifier")
            }
            
            
            
        } else {
            sliderLabel.text = "SLIDE TO FINISH RIDE"
            sliderLabel.textColor = .scootLoginGreen
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        configureConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
}

private extension RideInProgressVC {
    func addSubviews() {
        view.addSubview(progressImageView)
        view.addSubview(timerLabel)
        view.addSubview(titleLabel)
        view.bringSubviewToFront(timerLabel)
        view.bringSubviewToFront(titleLabel)
        view.addSubview(slider)
        view.addSubview(sliderLabel)
        view.bringSubviewToFront(sliderLabel)
    }
    
    func configureConstraints() {
        progressImageView.snp.makeConstraints { 
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-45)
            $0.width.height.equalTo(257)
        }
        
        timerLabel.snp.makeConstraints { 
            $0.center.equalTo(progressImageView.snp.center)
        }
        
        titleLabel.snp.makeConstraints { 
            $0.bottom.equalTo(timerLabel.snp.top).offset(-34)
            $0.centerX.equalToSuperview()
        }
        
        slider.snp.makeConstraints { 
            $0.top.equalTo(progressImageView.snp.bottom).offset(192)
            $0.height.equalTo(80)
            $0.leading.trailing.equalToSuperview().inset(36)
        }
        
        sliderLabel.snp.makeConstraints { 
            $0.center.equalTo(slider.snp.center)
        }
    }
}

private extension RideInProgressVC {
    func configureTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(runningTimer), userInfo: nil, repeats: true)
    }
    
    @objc func runningTimer() {
        let minutes = timerCount / 60 % 60
        let seconds = timerCount % 60
        timerCount += 1
        timerLabel.text = String(format:"%02i:%02i", minutes, seconds)
    }
}
