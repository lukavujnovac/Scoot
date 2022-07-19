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
    
    private let emailTextField: UITextField = {
        let field = UITextField()
        field.layer.cornerRadius = 8
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.systemGray.cgColor
        field.autocorrectionType = .no
        field.autocapitalizationType = .none
        field.attributedPlaceholder = NSAttributedString(
            string: "Email Adress",attributes: [ NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14, weight: .regular)])
        field.setLeftPadding(padding: 16)
        
        return field
    }()
    
    private let passwordTextField = UITextField()
    let button = UIButton(type: .custom)
    
    private let loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Login", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.tintColor = .scootPurple500
        button.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
        button.layer.cornerRadius = 8
        button.layer.borderColor = UIColor.black.cgColor
        button.backgroundColor = .scootPurple500
        
        return button
    }()
    
    private var passwordVisibility: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .scootLoginGreen
        
        passwordTextField.rightViewMode = .unlessEditing
        
        configureEmailTF()
        configurePasswordTF()
        self.hideKeyboardWhenTappedAround()
        
        addViews()
    }
    
    @objc private func loginTapped() {
        print("login")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configureConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
       super.viewWillAppear(animated)
       
       AppUtility.lockOrientation(.portrait)
   }

   override func viewWillDisappear(_ animated: Bool) {
       super.viewWillDisappear(animated)
       
       AppUtility.lockOrientation(.all)
   }
    
    private func addViews() {
        view.addSubview(rectangleView)
        view.addSubview(logoImageView)
        
        rectangleView.addSubview(loginLabel)
        rectangleView.addSubview(loginSublabel)
        rectangleView.addSubview(emailTextField)
        rectangleView.addSubview(passwordTextField)
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
        
        loginButton.snp.makeConstraints {
            $0.height.equalTo(56)
            $0.width.equalToSuperview().offset(-64)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(passwordTextField.snp.bottom).offset(141)
        }
    }
}

private extension LoginVC {
    
    func configureEmailTF() {
        emailTextField.addTarget(self, action: #selector(emailDidChange(_:)), for: .editingChanged)
    }
    
    func configurePasswordTF() {
        passwordTextField.addTarget(self, action: #selector(passwordDidChange(_:)), for: .editingChanged)
        passwordTextField.layer.cornerRadius = 8
        passwordTextField.layer.borderWidth = 1
        passwordTextField.autocorrectionType = .no
        passwordTextField.autocapitalizationType = .none
        passwordTextField.layer.borderColor = UIColor.systemGray.cgColor
        passwordTextField.attributedPlaceholder = NSAttributedString(
            string: "Password",attributes: [ NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14, weight: .regular)])
        passwordTextField.rightViewMode = .always
        passwordTextField.setLeftPadding(padding: 16)
        
        button.setImage(UIImage(systemName: "eye"), for: .normal)
        button.tintColor = .systemGray
        button.frame = CGRect(x: 0, y: 0, width: CGFloat(22.5), height: CGFloat(13.5))
        button.addTarget(self, action: #selector(self.btnPasswordVisiblityClicked), for: .touchUpInside)
        
        passwordTextField.setRightView(button, padding: 16.25)
        passwordTextField.isSecureTextEntry = true
    }
    
    @objc func btnPasswordVisiblityClicked(_ sender: Any) {
           (sender as! UIButton).isSelected = !(sender as! UIButton).isSelected
           if (sender as! UIButton).isSelected {
               self.passwordTextField.isSecureTextEntry = false
               button.setImage(UIImage(systemName: "eye"), for: .normal)
           } else {
               self.passwordTextField.isSecureTextEntry = true
               button.setImage(UIImage(systemName: "eye.slash"), for: .normal)
           }
       }
    
    @objc func emailDidChange(_ textField: UITextField) {
        emailTextField.layer.borderColor = UIColor.scootPurple500?.cgColor
        
        if emailTextField.text == "" {
            emailTextField.layer.borderColor = UIColor.systemGray.cgColor
        }
    }
    
    @objc func passwordDidChange(_ textField: UITextField) {
        passwordTextField.layer.borderColor = UIColor.scootPurple500?.cgColor
        
        if passwordTextField.text == "" {
            passwordTextField.layer.borderColor = UIColor.systemGray.cgColor
        }
    }
}
