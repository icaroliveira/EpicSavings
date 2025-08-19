import UIKit
import Combine // Importe para usar os recursos do @Published

class DashboardViewController: UIViewController {

    private let viewModel: DashboardViewModel
    // 'cancellables' armazena as "inscrições" que fazemos nos publishers do ViewModel.
    // Quando a ViewController for destruída, essas inscrições são canceladas para evitar memory leaks.
    private var cancellables = Set<AnyCancellable>()

    // MARK: - UI Components
    private let characterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        // Usamos tintColor para ícones do sistema, mas a cor pode ser sobrescrita.
        imageView.tintColor = .systemGreen
        return imageView
    }()
    
    private let levelLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .bold)
        return label
    }()
    
    private let xpProgressView: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .default)
        progressView.progressTintColor = .systemYellow
        progressView.trackTintColor = .systemGray5
        return progressView
    }()

    private let xpLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textAlignment = .center
        return label
    }()
    
    private let coinsLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .bold)
        return label
    }()
    
    private let coinsIcon: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "dollarsign.circle.fill"))
        imageView.tintColor = .systemYellow
        return imageView
    }()

    // MARK: - Initializer
    // A ViewModel é injetada aqui.
    init(viewModel: DashboardViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Sempre que a tela for aparecer, pede para a ViewModel recarregar os dados.
        viewModel.refreshUserData()
    }

    // MARK: - Binding
    private func bindViewModel() {
        // 'sink' se "inscreve" no publisher '$user' da ViewModel.
        // O bloco de código dentro do sink será executado imediatamente
        // e, depois, toda vez que a propriedade 'user' for alterada.
        viewModel.$user
            .receive(on: RunLoop.main) // Garante que a atualização da UI ocorra na thread principal
            .sink { [weak self] user in
                self?.updateUI(with: user)
            }
            .store(in: &cancellables)
    }

    // MARK: - UI Update
    private func updateUI(with user: User) {
        nameLabel.text = user.name
        levelLabel.text = "Nível \(user.level)"
        
        let progress = Float(user.xp) / Float(user.xpToNextLevel)
        xpProgressView.setProgress(progress, animated: true)
        xpLabel.text = "\(user.xp) / \(user.xpToNextLevel) XP"
        
        coinsLabel.text = "\(user.coins)"
        
        // Configura a imagem do sistema com um tamanho grande.
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 100, weight: .bold)
        characterImageView.image = UIImage(systemName: user.characterSpriteName, withConfiguration: symbolConfig)
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        // StackViews são ótimas para organizar elementos em linha ou coluna.
        let headerStack = UIStackView(arrangedSubviews: [nameLabel, levelLabel])
        headerStack.axis = .vertical
        headerStack.alignment = .center
        headerStack.spacing = 4
        
        let coinsStack = UIStackView(arrangedSubviews: [coinsIcon, coinsLabel])
        coinsStack.spacing = 8
        coinsStack.alignment = .center

        let mainStack = UIStackView(arrangedSubviews: [characterImageView, headerStack, xpProgressView, xpLabel])
        mainStack.axis = .vertical
        mainStack.alignment = .center
        mainStack.spacing = 16
        mainStack.setCustomSpacing(24, after: headerStack) // Espaço maior depois do nome/nível
        
        [mainStack, coinsStack].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        // Definindo as constraints (posição e tamanho) dos elementos.
        NSLayoutConstraint.activate([
            mainStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mainStack.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50),
            mainStack.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            
            xpProgressView.widthAnchor.constraint(equalTo: mainStack.widthAnchor),
            
            coinsStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            coinsStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            characterImageView.heightAnchor.constraint(equalToConstant: 120)
        ])
    }
}
