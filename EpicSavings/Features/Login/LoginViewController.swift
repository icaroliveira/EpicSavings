//
//  LoginViewController.swift
//  EpicSavings
//
//  Created by Ícaro Rangel on 21/08/25.
//

import UIKit
import Combine
import GoogleSignIn
class LoginViewController: UIViewController {

    private let viewModel: LoginViewModel
    private var cancellables = Set<AnyCancellable>()
    
    weak var coordinator: AppCoordinator?
    
    // MARK: - UI Components
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "EpicSavings"
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    private let emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.keyboardType = .emailAddress
        tf.borderStyle = .roundedRect
        tf.autocapitalizationType = .none
        return tf
    }()
    
    private let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Senha (mínimo 6 caracteres)"
        tf.isSecureTextEntry = true
        tf.borderStyle = .roundedRect
        return tf
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Entrar", for: .normal)
        button.tintColor = .white
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 8
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        return button
    }()
    
    private let registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Registrar", for: .normal)
        button.tintColor = .white
        button.backgroundColor = .systemGreen
        button.layer.cornerRadius = 8
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        return button
    }()
    
    // 1. A criação do botão de Login com Google
    private let googleButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Entrar com Google", for: .normal)
        button.tintColor = .darkGray
        button.backgroundColor = .white
        button.layer.cornerRadius = 8
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.systemGray4.cgColor
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        // Opcional: Adicionar o ícone do Google
        // button.setImage(UIImage(named: "google_logo"), for: .normal)
        return button
    }()
    
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
        bindViewModel()
    }
    
    private func bindViewModel() {
        viewModel.errorPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] errorMessage in
                self?.showAlert(title: "Erro", message: errorMessage)
            }
            .store(in: &cancellables)
            
        viewModel.authStatePublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] state in
                if state == .signedIn {
                    self?.coordinator?.userDidLogin()
                }
            }
            .store(in: &cancellables)
    }
    
    private func setupActions() {
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        registerButton.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
        //2. Conectar a ação do botão do Google
        googleButton.addTarget(self, action: #selector(googleButtonTapped), for: .touchUpInside)
    }
    
    @objc private func loginButtonTapped() {
        guard let email = emailTextField.text, let pass = passwordTextField.text else { return }
        viewModel.login(email: email, pass: pass)
    }
    
    @objc private func registerButtonTapped() {
        guard let email = emailTextField.text, let pass = passwordTextField.text else { return }
        viewModel.register(email: email, pass: pass)
    }
    
    //A função que é chamada quando o botão do Google é tocado
    @objc private func googleButtonTapped() {
        AuthService.shared.signInWithGoogle(viewController: self) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self?.coordinator?.userDidLogin()
                case .failure(let error):
                    //Evita mostrar um erro se o usuário simplesmente cancelar o login
                    if (error as NSError).code != GIDSignInError.Code.canceled.rawValue {
                        self?.showAlert(title: "Erro de Login", message: error.localizedDescription)
                    }
                }
            }
        }
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        // Adicionar o googleButton na lista de elementos da StackView
        let stackView = UIStackView(arrangedSubviews: [titleLabel, emailTextField, passwordTextField, loginButton, registerButton, googleButton])
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.setCustomSpacing(30, after: passwordTextField) // Espaço maior depois da senha
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            
            loginButton.heightAnchor.constraint(equalToConstant: 50),
            registerButton.heightAnchor.constraint(equalToConstant: 50),
            //Adicionar a constraint de altura para o botão do Google
            googleButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true)
    }
}
