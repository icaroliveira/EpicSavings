//
//  MissionTableViewCell.swift
//  EpicSavings
//
//  Created by Ícaro Rangel on 18/08/25.
//

import UIKit

class MissionTableViewCell: UITableViewCell {
    
    // Um identificador estático para facilitar o reuso da célula.
    static let identifier = "MissionTableViewCell"
    
    // Um closure (bloco de código) que a ViewController vai implementar.
    // Quando o botão for tocado, a célula vai executar este closure.
    var onCompleteButtonTapped: (() -> Void)?

    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let rewardLabel = UILabel()
    private let completeButton = UIButton(type: .system)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func completeButtonTapped() {
        // Executa o closure quando o botão é pressionado.
        onCompleteButtonTapped?()
    }
    
    public func configure(with mission: Mission) {
        titleLabel.text = mission.title
        descriptionLabel.text = mission.description
        rewardLabel.text = "🏆 \(mission.rewardXP) XP / 💰 \(mission.rewardCoins) Moedas"
        
        // Atualiza a aparência do botão se a missão estiver completa.
        if mission.isCompleted {
            completeButton.setTitle("Concluída", for: .normal)
            completeButton.isEnabled = false
            completeButton.backgroundColor = .systemGreen
            accessoryView = nil // Remove a seta
        } else {
            completeButton.setTitle("Completar", for: .normal)
            completeButton.isEnabled = true
            completeButton.backgroundColor = .systemBlue
        }
    }
    
    private func setupUI() {
        titleLabel.font = .systemFont(ofSize: 18, weight: .bold)
        descriptionLabel.font = .systemFont(ofSize: 14)
        descriptionLabel.textColor = .secondaryLabel
        descriptionLabel.numberOfLines = 0
        rewardLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        
        completeButton.setTitle("Completar", for: .normal)
        completeButton.tintColor = .white
        completeButton.backgroundColor = .systemBlue
        completeButton.layer.cornerRadius = 8
        completeButton.addTarget(self, action: #selector(completeButtonTapped), for: .touchUpInside)
        
        let infoStack = UIStackView(arrangedSubviews: [titleLabel, descriptionLabel, rewardLabel])
        infoStack.axis = .vertical
        infoStack.spacing = 4
        
        let mainStack = UIStackView(arrangedSubviews: [infoStack, completeButton])
        mainStack.axis = .horizontal
        mainStack.spacing = 16
        mainStack.alignment = .center
        
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(mainStack)
        
        NSLayoutConstraint.activate([
            mainStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            mainStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            mainStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            mainStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            
            completeButton.widthAnchor.constraint(equalToConstant: 100)
        ])
    }
}
