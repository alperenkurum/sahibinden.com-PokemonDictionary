//
//  MainViewController.swift
//  sahibindenVitrin
//
//  Created by Ibrahim Alperen Kurum on 26.09.2025.
//

import UIKit

class MainViewController: UIViewController {
    private var pokemonUrls: PokemonURL?
    private var rotationChanged: Bool = false
    private var pokemons: [Pokemon] = []
    private var filteredPokemons: [Pokemon] = []
    private var apiCaller = ApiCaller()
    private let searchController = UISearchController()
    private var refreshControl = UIRefreshControl()
    private var collectionViewPokemon: UICollectionView!
    private var isComparing: Bool = false
    private var isChecked: Bool = false
    private var selectedIndexList: [Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
        configureNavigationBar()
        configureCollectionView()
        configureSearchController()
        Task { await loadData() }
    }
    
    private func configureNavigationBar() {
        navigationItem.title = "Pokemon Dictionary"
        navigationItem.rightBarButtonItem = isComparing ? UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(goComparing)) : UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(startComparing))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelComparing))
        navigationItem.leftBarButtonItem?.isHidden = !isComparing
    }
    
    @objc private func startComparing() {
        isComparing.toggle()
        configureNavigationBar()
        collectionViewPokemon.reloadData()
    }
    
    @objc private func goComparing() {
        if(selectedIndexList.count < 2){
            return
        }else if (selectedIndexList.count == 2){
            
        }else{
            
        }
        
        isComparing.toggle()
    }
    
    @objc private func cancelComparing() {
        isComparing.toggle()
        configureNavigationBar()
        collectionViewPokemon.reloadData()
    }
    
    private func configureSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Name Search ..."
        searchController.searchBar.sizeToFit()
        searchController.searchBar.searchBarStyle = .prominent
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    private func filterContentForSearchText(_ searchText: String) {
        guard !searchText.isEmpty else {
            collectionViewPokemon.reloadData()
            return }
        filteredPokemons = pokemons.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        collectionViewPokemon.reloadData()
    }
    
    private var isFiltering: Bool {
        searchController.isActive && !searchController.searchBar.text!.isEmpty
    }
    
    private func loadData() async {
        if(!apiCaller.isLoading){
            do{
                pokemonUrls = try await apiCaller.getPokemonURLs()
                let tmpPokemons = try await apiCaller.getPokemonDatas(URLs: pokemonUrls!)
                pokemons.append(contentsOf: tmpPokemons)
                collectionViewPokemon.reloadData()
                apiCaller.isLoading.toggle()
                collectionViewPokemon.reloadSections(IndexSet(integer: 0))
            }catch{
                fatalError("blap")
            }
        }
        
    }
    
    private func configureCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let size = (self.view.frame.width / 2) - 10
        layout.itemSize = CGSize(width: size, height: size)
        collectionViewPokemon = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionViewPokemon.backgroundColor = .systemBackground
        collectionViewPokemon.translatesAutoresizingMaskIntoConstraints = false
        collectionViewPokemon.register(MainCollectionViewCell.self, forCellWithReuseIdentifier: MainCollectionViewCell.identifier)
        collectionViewPokemon.delegate = self
        collectionViewPokemon.dataSource = self
        view.addSubview(collectionViewPokemon)//layout
        collectionViewPokemon.pin(to: view)
        collectionViewPokemon.register(LoadingFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: LoadingFooterView.identifier)

    }
}

extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isFiltering {//nill colla
            return filteredPokemons.count
        }
        return pokemons.count
        }
}

extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainCollectionViewCell.identifier, for: indexPath) as? MainCollectionViewCell else {
            fatalError("Failed to dequeue MainCollectionViewCell")
        }
        Task {
            do{
                let pokemon = isFiltering ? filteredPokemons[indexPath.row] : pokemons[indexPath.row]
                let image = try await apiCaller.getImage(urlString: pokemon.sprites.frontDefault)
                cell.set(with: image, with: pokemon.name.capitalizingFirstLetter(),check: isChecked, index: indexPath.row, selectionStarted: isComparing, count: 0)
                
            }catch{
                fatalError("ERROR")
            }
        }
    
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailViewController = createDetailViewController(ID: pokemons[indexPath.row].id)
        navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    private func createDetailViewController(ID id: Int) -> DetailViewController {
        let detailViewController = DetailViewController()
        detailViewController.set(ID: id)
        return detailViewController
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: any UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        if UIDevice.current.orientation.isLandscape,
            let layout = collectionViewPokemon.collectionViewLayout as? UICollectionViewFlowLayout {
            let size = (self.view.frame.width/2) + 7//layout.minimumInteritemSpacing
            layout.itemSize = CGSize(width: size, height: size)
            layout.invalidateLayout()
        } else if UIDevice.current.orientation.isPortrait,
            let layout = collectionViewPokemon.collectionViewLayout as? UICollectionViewFlowLayout {
            let size = (self.view.frame.width / 2) - 250
            layout.itemSize = CGSize(width: size, height: size)
            layout.invalidateLayout()
        }
    }
}

extension MainViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 5, bottom: 0, right: 5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 50)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionFooter {
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: LoadingFooterView.identifier, for: indexPath) as! LoadingFooterView
            let position = collectionView.contentOffset.y
            let maxPosition = collectionView.contentSize.height - collectionView.frame.height
            if position >= maxPosition-50 && apiCaller.currentPage < 66 && !apiCaller.isLoading{
                footer.startAnimating()
            } else {
                footer.stopAnimating()
            }
            return footer
        }
        return UICollectionReusableView()
    }
}

extension MainViewController: UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        let maxPosition = scrollView.contentSize.height - scrollView.frame.height
        if(position >= maxPosition && apiCaller.currentPage < 66 && !apiCaller.isLoading && position > 0){
            Task{
                await loadData()
            }
        }
    }
}

// MARK: - UISearchResultsUpdating
extension MainViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}

//extension MainViewController: OnSelectionDelegate{
//    func selectionChanged(index: Int) {
//        <#code#>
//    }
//}
