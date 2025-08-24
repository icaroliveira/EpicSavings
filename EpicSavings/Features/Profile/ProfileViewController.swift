import UIKit
import Combine

class ProfileViewController: UIViewController {

    private let viewModel: ProfileViewModel
    private var cancellables = Set<AnyCancellable>()
    
    weak var coordinator: AppCoordinator?
    
    // MARK: - UI Components
    private let nameLabel = UILabel()
    private let levelLabel = UILabel()
    private let nameTextField = UITextField()
    private let saveButton = UIButton(type: .system)

    private let logoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sair (Logout)", for: .normal)
        button.tintColor = .white
        button.backgroundColor = .systemRed
        button.layer.cornerRadius = 8
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        return button
    }()

    init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        logoutButton.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
        bindViewModel()
        viewModel.loadUser()
    }
    
    @objc private func logoutButtonTapped() {
        viewModel.logout { [weak self] in
            self?.coordinator?.userDidLogout()
        }
    }
    
    private func bindViewModel() {
        viewModel.$user
            .compactMap { $0 }
            .receive(on: RunLoop.main)
            .sink { [weak self] user in
                self?.nameLabel.text = "Nome: \(user.name)"
                self?.levelLabel.text = "Nível: \(user.level)"
                self?.nameTextField.placeholder = user.name
            }
            .store(in: &cancellables)
            
        viewModel.saveSuccessPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] in
                self?.showAlert(title: "Sucesso!", message: "Seu nome foi salvo.")
                self?.nameTextField.text = ""
            }
            .store(in: &cancellables)
    }
    
    @objc private func saveButtonTapped() {
        viewModel.saveUserName(newName: nameTextField.text ?? "")
    }

    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        nameLabel.font = .systemFont(ofSize: 20)
        levelLabel.font = .systemFont(ofSize: 20)
        
        nameTextField.placeholder = "Digite seu novo nome"
        nameTextField.borderStyle = .roundedRect
        nameTextField.font = .systemFont(ofSize: 18)
        
        saveButton.setTitle("Salvar Nome", for: .normal)
        saveButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        saveButton.backgroundColor = .systemBlue
        saveButton.tintColor = .white
        saveButton.layer.cornerRadius = 8
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        
        let infoStack = UIStackView(arrangedSubviews: [nameLabel, levelLabel])
        infoStack.axis = .vertical
        infoStack.spacing = 12
        
        let mainStack = UIStackView(arrangedSubviews: [infoStack, nameTextField, saveButton, logoutButton])
        mainStack.axis = .vertical
        mainStack.spacing = 24
        mainStack.setCustomSpacing(40, after: saveButton)
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mainStack)
        
        NSLayoutConstraint.activate([
            mainStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mainStack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            mainStack.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            
            saveButton.heightAnchor.constraint(equalToConstant: 50),
            logoutButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    // A função que estava faltando!
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
} // <--- A chave final que provavelmente estava faltando
