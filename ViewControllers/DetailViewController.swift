//
//  DetailViewController.swift
//  sahibindenVitrin
//
//  Created by Ibrahim Alperen Kurum on 7.10.2025.
//

import UIKit

class DetailViewController: UIViewController {
    private var ids: [Int] = []
    private var id: Int = -1
    private var apiCaller = ApiCaller()
    private var pokemon: [PokemonDetail] = []
    private var abilitiews: [String] = []
    
    private var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.alwaysBounceVertical = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private var pokemonCardView1: PokemonCardView = {
        let view = PokemonCardView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var pokemonCardView2: PokemonCardView = {
        let view = PokemonCardView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var pokemonCardView3: PokemonCardView = {
        let view = PokemonCardView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = 200
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Task{
            await fetchPokemonData()
            configureUI()
        }
        
    }
    
    func setSingle(ID id: Int) {
        self.id = id
    }
    
    func setMultiple(IDs ids: [Int]) {
        self.ids = ids
        self.id = -1
    }
    
    private func fetchPokemonData() async {
        if id != -1 {
            await apiCall(ID: id)
        }else{
            for id in ids {
                await apiCall(ID: id)
            }
        }
    }
    
    private func apiCall(ID id: Int) async{
        do{
            let result = try await apiCaller.getPokemonDetails(ID: id)
            switch result {
            case .success(let pokemon):
                self.pokemon.append(pokemon)
            case .failure(let error):
                print(error)
            }
        }catch {
            print(error)
        }
    }
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
        
        Task{
            configureScrollView()
            await configureScrollItems()
        }
    }
    
    private func configureScrollItems() async {
        stackView.addArrangedSubview(pokemonCardView1)
        if id != -1{
            pokemonCardView1.configure(with: pokemon[0])
            await pokemonCardView1.setImage(Pokemon: pokemon[0], apiCaller: apiCaller)
        }else{
            stackView.addArrangedSubview(pokemonCardView2)
            stackView.addArrangedSubview(pokemonCardView3)
            pokemonCardView1.configure(with: pokemon[0])
            pokemonCardView2.configure(with: pokemon[1])
            pokemonCardView3.configure(with: pokemon[2])
            await pokemonCardView1.setImage(Pokemon: pokemon[0], apiCaller: apiCaller)
            await pokemonCardView2.setImage(Pokemon: pokemon[1], apiCaller: apiCaller)
            await pokemonCardView3.setImage(Pokemon: pokemon[2], apiCaller: apiCaller)
        }
    }

    private func configureScrollView() {
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            stackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
            stackView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor)
        ])
    }
    
}
