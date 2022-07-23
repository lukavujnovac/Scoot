//
//  ViewController.swift
//  Scoot
//
//  Created by Fabijan Mihanović on 17.07.2022..
//

import UIKit
import SnapKit

class LoginVC: UIViewController {
    private let rectangleView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 16
        return view
    }()
    
    private let logoImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: K.logoImageString)
        iv.contentMode = .scaleAspectFit
        
        return iv
    }()
    
    private let loginLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 28, weight: .bold)
        label.textColor = .label
        label.text = "Login"
        
        return label
    }()
    
    private let loginSublabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .label
        label.text = "Login with customer e-mail"
        
        return label
    }()
    
    private let emailTextField = ScootTextField(placeholderText: "Email Adress", type: .emailField)
    private let passwordTextField = ScootTextField(placeholderText: "Password", type: .passwordField)
    private let authManager = AuthService.shared
    private var email: String = ""
    private var password: String = ""
    
    private let passwordVisibillityButton = UIButton(type: .custom)
    
    private var errorMessageLabel: UILabel = {
        let label = UILabel()
        label.text = "Unesena je nepostojeća e-mail adresa ili pogrešna zaporka."
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.numberOfLines = 0
        label.textAlignment = .left
        label.textColor = .systemRed
        label.isHidden = true
        
        return label
    }()
    
    private let loginButton = ScootButton(backgruondColor: UIColor.scootPurple500!, title: "Login", titleColor: .systemBackground)
    
    private var passwordVisibility: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .scootLoginGreen
        
        passwordTextField.rightViewMode = .unlessEditing
        
        configureEmailTF()
        configurePasswordTF()
        configureLoginButton()
        self.hideKeyboardWhenTappedAround()
        
        addViews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configureConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
       super.viewWillAppear(animated)
       
        //fix
       AppUtility.lockOrientation(.portrait)
   }

   override func viewWillDisappear(_ animated: Bool) {
       super.viewWillDisappear(animated)
       
       //fix
       AppUtility.lockOrientation(.all)
   }
    
    private func addViews() {
        view.addSubview(rectangleView)
        view.addSubview(logoImageView)
        
        rectangleView.addSubview(loginLabel)
        rectangleView.addSubview(loginSublabel)
        rectangleView.addSubview(emailTextField)
        rectangleView.addSubview(passwordTextField)
        rectangleView.addSubview(errorMessageLabel)
        rectangleView.addSubview(loginButton)
    }
}

private extension LoginVC {
    func configureConstraints() {
        rectangleView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(228)
            $0.bottom.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
        }
        
        logoImageView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(130.7)
            $0.top.equalToSuperview().offset(69.33)
            $0.height.equalTo(139)
        }
        
        loginLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.top.equalToSuperview().offset(40)
        }
        
        loginSublabel.snp.makeConstraints {
            $0.leading.equalTo(loginLabel.snp.leading)
            $0.top.equalTo(loginLabel.snp.bottom).offset(6)
        }
        
        emailTextField.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.top.equalTo(loginSublabel).offset(48)
            $0.height.equalTo(56)
        }
        
        passwordTextField.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.top.equalTo(emailTextField.snp.bottom).offset(16)
            $0.height.equalTo(56)
        }
        
        errorMessageLabel.snp.makeConstraints {
            $0.leading.equalTo(passwordTextField.snp.leading)
            $0.top.equalTo(passwordTextField.snp.bottom).offset(8)
            $0.trailing.equalTo(passwordTextField.snp.trailing)
        }
        
        loginButton.snp.makeConstraints {
            $0.height.equalTo(56)
            $0.width.equalToSuperview().offset(-64)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(errorMessageLabel).offset(100)
        }
    }
}

private extension LoginVC {
    
    func configureEmailTF() {
        emailTextField.addTarget(self, action: #selector(emailDidChange), for: .editingChanged)
        email = emailTextField.text ?? ""
    }
    
    func configurePasswordTF() {
        passwordTextField.addTarget(self, action: #selector(passwordDidChange), for: .editingChanged)
        
        passwordVisibillityButton.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        passwordVisibillityButton.tintColor = .systemGray
        passwordVisibillityButton.frame = CGRect(x: 0, y: 0, width: CGFloat(22.5), height: CGFloat(13.5))
        passwordVisibillityButton.addTarget(self, action: #selector(self.btnPasswordVisiblityClicked), for: .touchUpInside)
        
        passwordTextField.setRightView(passwordVisibillityButton, padding: 16.25)
        passwordTextField.isSecureTextEntry = true
        password = passwordTextField.text ?? ""
    }
    
    @objc private func loginTapped() {
        showSpinner()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.hideSpinner()
            
            if self.authManager.checkUserInfo(username: self.email, password: self.password) {
                
                let vc = VehicleListVC()
                vc.modalPresentationStyle = .fullScreen
                self.navigationController?.pushViewController(vc, animated: true)
            }else {
                self.errorMessageLabel.isHidden = false
            }
            
           
        }
    }
    
    func configureLoginButton() {
        loginButton.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
    }
    
    @objc func btnPasswordVisiblityClicked(_ sender: Any) {
           (sender as! UIButton).isSelected = !(sender as! UIButton).isSelected
           if (sender as! UIButton).isSelected {
               self.passwordTextField.isSecureTextEntry = false
               passwordVisibillityButton.setImage(UIImage(systemName: "eye"), for: .normal)
           } else {
               self.passwordTextField.isSecureTextEntry = true
               passwordVisibillityButton.setImage(UIImage(systemName: "eye.slash"), for: .normal)
           }
       }
    
    @objc func emailDidChange() {
        emailTextField.layer.borderColor = UIColor.scootPurple500?.cgColor
        emailTextField.clearsOnBeginEditing = false
        
        email = emailTextField.text ?? ""
        if emailTextField.text == "" {
            emailTextField.layer.borderColor = UIColor.systemGray.cgColor
        }
    }
    
    @objc func passwordDidChange() {
        passwordTextField.layer.borderColor = UIColor.scootPurple500?.cgColor
        password = passwordTextField.text ?? ""
        
        if passwordTextField.text == "" {
            passwordTextField.layer.borderColor = UIColor.systemGray.cgColor
        }
    }
}
