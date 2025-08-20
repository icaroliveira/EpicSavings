//
//  RankingTableViewCell.swift
//  EpicSavings
//
//  Created by Ícaro Rangel on 19/08/25.
//

import UIKit

class RankingTableViewCell: UITableViewCell {
    
    static let identifier = "RankingTableViewCell"
    
    private let rankLabel = UILabel()
    private let nameLabel = UILabel()
    private let scoreLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Recebe a entrada do ranking e sua posição na lista.
    public func configure(with entry: RankingEntry, rank: Int) {
        rankLabel.text = "#\(rank)"
        nameLabel.text = entry.userName
        scoreLabel.text = "\(entry.score) XP"
        
        // Se for o usuário atual, destaca a célula.
        if entry.isCurrentUser {
            backgroundColor = .systemYellow.withAlphaComponent(0.2)
            nameLabel.font = .systemFont(ofSize: 18, weight: .bold)
            rankLabel.font = .systemFont(ofSize: 18, weight: .bold)
        } else {
            backgroundColor = .systemBackground
            nameLabel.font = .systemFont(ofSize: 18, weight: .regular)
            rankLabel.font = .systemFont(ofSize: 18, weight: .regular)
        }
    }
    
    private func setupUI() {
        rankLabel.font = .systemFont(ofSize: 18)
        rankLabel.textAlignment = .center
        nameLabel.font = .systemFont(ofSize: 18)
        scoreLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        scoreLabel.textAlignment = .right
        
        let stackView = UIStackView(arrangedSubviews: [rankLabel, nameLabel, scoreLabel])
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            // Define larguras específicas para as colunas.
            rankLabel.widthAnchor.constraint(equalToConstant: 60),
            scoreLabel.widthAnchor.constraint(equalToConstant: 100),
            
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }
}
