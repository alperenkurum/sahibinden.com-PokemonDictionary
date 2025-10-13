//
//  DetailViewController.swift
//  sahibindenVitrin
//
//  Created by Ibrahim Alperen Kurum on 7.10.2025.
//

import UIKit

class DetailViewController: UIViewController {
    private var id : Int!
    private var apiCaller = ApiCaller()
    private var pokemon: PokemonDetail!
    private var abilitiews: [String] = []
    
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
        //view.layer.shadowOpacity = 0.15
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Task{
            await fetchPokemonData()
            await getImage()
        }
        configureUI()
    }
    
    func set(ID id: Int) {
        self.id = id
    }
    
    private func fetchPokemonData() async {
        do{
            pokemon = try await apiCaller.getPokemonDetails(ID: id)
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
        }catch {
            print(error)
        }
    }
    
    private func getImage() async {
        do{
            self.frontPokeImageView.image = try await apiCaller.getImage(urlString: pokemon.sprites.frontDefault)
            self.backPokeImageView.image = try await apiCaller.getImage(urlString: pokemon.sprites.backDefault)
        }catch{
            printContent(error.localizedDescription)
        }
    }
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
        
        configureImageViews()
        configureLabels()
    }
    
    private func configureImageViews() {
        view.addSubview(imageContainerView)
        imageContainerView.addSubview(frontPokeImageView)
        imageContainerView.addSubview(backPokeImageView)
        
        NSLayoutConstraint.activate([
            imageContainerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            imageContainerView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            imageContainerView.heightAnchor.constraint(equalTo: frontPokeImageView.heightAnchor, multiplier: 1),
            imageContainerView.widthAnchor.constraint(equalTo: frontPokeImageView.widthAnchor, multiplier: 2),
            
            frontPokeImageView.topAnchor.constraint(equalTo: imageContainerView.topAnchor),
            frontPokeImageView.leadingAnchor.constraint(equalTo: imageContainerView.leadingAnchor),
            frontPokeImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.45),
            frontPokeImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.25),
            
            backPokeImageView.topAnchor.constraint(equalTo: imageContainerView.topAnchor),
            backPokeImageView.leadingAnchor.constraint(equalTo: frontPokeImageView.trailingAnchor),
            backPokeImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.45),
            backPokeImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.25)
        ])
    }
    
    private func configureLabels(){
        view.addSubview(labelsContainerView)
        view.addSubview(nameContainerView)
        nameContainerView.addSubview(pokeNameLabel)
        nameContainerView.addSubview(pokeHeightLabel)
        nameContainerView.addSubview(pokeWeightLabel)
        labelsContainerView.addSubview(pokeAbilityLabel)
        labelsContainerView.addSubview(pokeHiddenAbilityLabel)
        
        NSLayoutConstraint.activate([
            nameContainerView.topAnchor.constraint(equalTo: imageContainerView.bottomAnchor, constant: 10),
            nameContainerView.heightAnchor.constraint(equalToConstant: 30),
            nameContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nameContainerView.widthAnchor.constraint(equalTo: imageContainerView.widthAnchor),
            
            pokeNameLabel.centerXAnchor.constraint(equalTo: nameContainerView.centerXAnchor),
            pokeNameLabel.topAnchor.constraint(equalTo: nameContainerView.topAnchor),
            pokeNameLabel.bottomAnchor.constraint(equalTo: nameContainerView.bottomAnchor),
            
            labelsContainerView.topAnchor.constraint(equalTo: nameContainerView.bottomAnchor, constant: 10),
            labelsContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            labelsContainerView.widthAnchor.constraint(equalTo: imageContainerView.widthAnchor),
            labelsContainerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
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
}
