//
//  PokemonCardView.swift
//  PokemonDictionary
//
//  Created by Ibrahim Alperen Kurum on 15.10.2025.
//

import UIKit

class PokemonCardView: UIView {
    
    private let frontPokeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let imageContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.layer.cornerRadius = 16
        view.layer.shadowColor = UIColor.black.cgColor
        //view.layer.shadowOpacity = 0.15
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowRadius = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let labelsContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray5
        view.layer.cornerRadius = 16
        view.layer.shadowColor = UIColor.black.cgColor
        //view.layer.shadowOpacity = 0.15
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowRadius = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let nameContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemMint
        view.layer.cornerRadius = 12
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowRadius = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let backPokeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let pokeNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 30, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let pokeWeightLabel: PaddedLabel = {
        let label = PaddedLabel()
        label.font = .systemFont(ofSize: 22, weight: .regular)
        label.textAlignment = .left
        label.clipsToBounds = true
        label.layer.cornerRadius = 8
        label.textInsets = UIEdgeInsets(top: 5, left: 5, bottom:5, right: 5)
        label.backgroundColor = .systemGray4
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let pokeHeightLabel: PaddedLabel = {
        let label = PaddedLabel()
        label.font = .systemFont(ofSize: 22, weight: .regular)
        label.textAlignment = .left
        label.clipsToBounds = true
        label.layer.cornerRadius = 8
        label.textInsets = UIEdgeInsets(top: 5, left: 5, bottom:5, right: 5)
        label.backgroundColor = .systemGray4
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let pokeHiddenAbilityLabel: PaddedLabel = {
        let label = PaddedLabel()
        label.font = .systemFont(ofSize: 22, weight: .regular)
        label.textAlignment = .left
        label.clipsToBounds = true
        label.layer.cornerRadius = 8
        label.textInsets = UIEdgeInsets(top: 5, left: 5, bottom:5, right: 5)
        label.backgroundColor = .systemGray4
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let pokeAbilityLabel: PaddedLabel = {
        let label = PaddedLabel()
        label.font = .systemFont(ofSize: 22, weight: .regular)
        label.textAlignment = .left
        label.layer.cornerRadius = 8
        label.clipsToBounds = true
        label.textInsets = UIEdgeInsets(top: 5, left: 5, bottom:5, right: 5)
        label.backgroundColor = .systemGray4
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageContainerView)
        imageContainerView.addSubview(frontPokeImageView)
        imageContainerView.addSubview(backPokeImageView)
        addSubview(nameContainerView)
        nameContainerView.addSubview(pokeNameLabel)
        nameContainerView.addSubview(pokeHeightLabel)
        nameContainerView.addSubview(pokeWeightLabel)
        addSubview(labelsContainerView)
        labelsContainerView.addSubview(pokeAbilityLabel)
        labelsContainerView.addSubview(pokeHiddenAbilityLabel)
        
        NSLayoutConstraint.activate([
            imageContainerView.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            imageContainerView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageContainerView.heightAnchor.constraint(equalTo: frontPokeImageView.heightAnchor, multiplier: 1),
            imageContainerView.widthAnchor.constraint(equalTo: frontPokeImageView.widthAnchor, multiplier: 2),
            
            frontPokeImageView.topAnchor.constraint(equalTo: imageContainerView.topAnchor),
            frontPokeImageView.leadingAnchor.constraint(equalTo: imageContainerView.leadingAnchor),
            frontPokeImageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.45),
            frontPokeImageView.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 0.45),
            
            backPokeImageView.topAnchor.constraint(equalTo: imageContainerView.topAnchor),
            backPokeImageView.leadingAnchor.constraint(equalTo: frontPokeImageView.trailingAnchor),
            backPokeImageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.45),
            backPokeImageView.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 0.45),
            
            nameContainerView.topAnchor.constraint(equalTo: imageContainerView.bottomAnchor, constant: 10),
            nameContainerView.heightAnchor.constraint(equalToConstant: 30),
            nameContainerView.centerXAnchor.constraint(equalTo: centerXAnchor),
            nameContainerView.widthAnchor.constraint(equalTo: imageContainerView.widthAnchor),
            
            pokeNameLabel.centerXAnchor.constraint(equalTo: nameContainerView.centerXAnchor),
            pokeNameLabel.topAnchor.constraint(equalTo: nameContainerView.topAnchor),
            pokeNameLabel.bottomAnchor.constraint(equalTo: nameContainerView.bottomAnchor),
            
            labelsContainerView.topAnchor.constraint(equalTo: nameContainerView.bottomAnchor, constant: 10),
            labelsContainerView.centerXAnchor.constraint(equalTo: centerXAnchor),
            labelsContainerView.widthAnchor.constraint(equalTo: imageContainerView.widthAnchor),
            labelsContainerView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            
            pokeWeightLabel.topAnchor.constraint(equalTo: labelsContainerView.topAnchor, constant: 10),
            pokeWeightLabel.leadingAnchor.constraint(equalTo: labelsContainerView.leadingAnchor, constant: 10),
            pokeWeightLabel.trailingAnchor.constraint(equalTo: labelsContainerView.centerXAnchor, constant: -2),
            
            pokeHeightLabel.topAnchor.constraint(equalTo: labelsContainerView.topAnchor, constant: 10),
            pokeHeightLabel.leadingAnchor.constraint(equalTo: labelsContainerView.centerXAnchor, constant: 10),
            pokeHeightLabel.trailingAnchor.constraint(equalTo: labelsContainerView.trailingAnchor, constant: -2),
            
            pokeAbilityLabel.topAnchor.constraint(equalTo: pokeWeightLabel.bottomAnchor, constant: 10),
            pokeAbilityLabel.centerXAnchor.constraint(equalTo: labelsContainerView.centerXAnchor),
            
            pokeHiddenAbilityLabel.topAnchor.constraint(equalTo: pokeAbilityLabel.bottomAnchor, constant: 10),
            pokeHiddenAbilityLabel.centerXAnchor.constraint(equalTo: labelsContainerView.centerXAnchor),
            
        ])
    }
    
    func configure(with pokemon: PokemonDetail) {
        pokeNameLabel.text = pokemon.name.capitalizingFirstLetter()
        pokeHeightLabel.text = "Height: \(pokemon.height) m"
        pokeWeightLabel.text = "Weight: \(pokemon.weight) g"
        pokemon.abilities.forEach { ability in
            if !ability.isHidden {
                pokeAbilityLabel.text = ("\(ability.ability.name)\n").capitalizingFirstLetter()
            } else{
                pokeHiddenAbilityLabel.text = ("\(ability.ability.name)\n").capitalizingFirstLetter()
            }
        }
    }
    
    func setImage(Pokemon pokemon: PokemonDetail, apiCaller: ApiCaller) async {
        do{
            let resultFrontImage = try await apiCaller.getImage(urlString: pokemon.sprites.frontDefault)
            let resultBackImage = try await apiCaller.getImage(urlString: pokemon.sprites.backDefault)
            switch resultBackImage{
            case .success(let image):
                self.backPokeImageView.image = image
            case .failure(let error):
                print(error)
            }
            switch resultFrontImage{
                case .success(let image):
                self.frontPokeImageView.image = image
            case .failure(let error):
                print(error)
            }
        }catch{
            printContent(error.localizedDescription)
        }
    }
}

