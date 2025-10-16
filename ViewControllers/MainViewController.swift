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
    private var selectedIdList: [Int] = []
    private var isLoading: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
        configureNavigationBar()
        configureCollectionView()
        configureSearchController()
        Task {
            await loadData()
            collectionViewPokemon.reloadData()
        }
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
        if(selectedIdList.count < 3){
            return
        }else if (selectedIdList.count == 3){
            let detailViewController = createDetailViewControllerWithMultiple(ID: selectedIdList)
            navigationController?.pushViewController(detailViewController, animated: true)
        }else{
            print("Error occurred, it sohuldnt has more than 3 selection")
        }
        
        isComparing.toggle()
    }
    
    @objc private func cancelComparing() {
        isComparing.toggle()
        selectedIdList.removeAll()
        configureNavigationBar()
        collectionViewPokemon.reloadData()
    }
    
    private func configureSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Name Search ..."
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
        if(isLoading){
            isLoading.toggle()
            do{
                let result = try await apiCaller.getPokemonURLs(Limit: 24)
                switch result {
                    case .success(let pokemonResult):
                        pokemonUrls = pokemonResult
                    
                    case .failure(let error):
                        print(error)
                }
                let resultPoke = try await apiCaller.getPokemonDatas(URLs: pokemonUrls!)
                switch resultPoke {
                case .success(let pokemonResult):
                    pokemons.append(contentsOf: pokemonResult)
                    isLoading.toggle()
                case .failure(let error):
                    print(error)
                }
            }catch{
                fatalError("blap")
            }
        }
    }
    
    private func configureCollectionView() {
        setupCollectionView()
        collectionViewPokemon.backgroundColor = .systemBackground
        collectionViewPokemon.translatesAutoresizingMaskIntoConstraints = false
        collectionViewPokemon.register(MainCollectionViewCell.self, forCellWithReuseIdentifier: MainCollectionViewCell.identifier)
        collectionViewPokemon.delegate = self
        collectionViewPokemon.dataSource = self
        collectionViewPokemon.pin(to: view)
        collectionViewPokemon.register(LoadingFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: LoadingFooterView.identifier)
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        var size : CGFloat = 0
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 12
        layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        
        if UIDevice.current.orientation.isPortrait{
            size = (self.view.frame.width - layout.sectionInset.left - layout.sectionInset.right - layout.minimumInteritemSpacing - self.view.safeAreaInsets.left - self.view.safeAreaInsets.right) / 2
        }else if UIDevice.current.orientation.isLandscape{
            size = (self.view.frame.width - layout.sectionInset.left - layout.sectionInset.right - (2*layout.minimumInteritemSpacing) - self.view.safeAreaInsets.left - self.view.safeAreaInsets.right) / 3
        }
        layout.itemSize = CGSize(width: size, height: size)
        collectionViewPokemon = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.addSubview(collectionViewPokemon)
    }
}

//MARK: - UICollectionViewDataSource
extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isFiltering {//nill colla
            return filteredPokemons.count
        }
        return pokemons.count
        }
}

//MARK: - UICollectionViewDelegate
extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainCollectionViewCell.identifier, for: indexPath) as? MainCollectionViewCell else {
            fatalError("Failed to dequeue MainCollectionViewCell")
        }
        Task {
            do{
                let pokemon = isFiltering ? filteredPokemons[indexPath.row] : pokemons[indexPath.row]
                let resultImage = try await apiCaller.getImage(urlString: pokemon.sprites.frontDefault)
                switch resultImage {
                case .success(let image):
                    cell.set(with: image, with: pokemon.name.capitalizingFirstLetter(),check: isChecked, id: pokemon.id, selectionStarted: isComparing, count: 0)
                    cell.delegateSelection = self
                case .failure(let error):
                    print(error)
                }
            }catch (let error){
                print(error)
            }
        }
    
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailViewController = createDetailViewControllerWithSingle(ID: pokemons[indexPath.row].id);
        navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    private func createDetailViewControllerWithSingle(ID id: Int) -> DetailViewController {
        let detailViewController = DetailViewController()
        detailViewController.setSingle(ID: id)
        return detailViewController
    }
    
    private func createDetailViewControllerWithMultiple(ID ids: [Int]) -> DetailViewController {
        let detailViewController = DetailViewController()
        detailViewController.setMultiple(IDs: ids)
        return detailViewController
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: any UIViewControllerTransitionCoordinator)
    {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate { [weak self] _ in
            guard let self = self else { return }
            guard let layout = collectionViewPokemon.collectionViewLayout as? UICollectionViewFlowLayout else { return }
            switch UIDevice.current.orientation {
            case .portrait, .portraitUpsideDown:
                let size = (collectionViewPokemon.frame.width - layout.sectionInset.left - layout.sectionInset.right - layout.minimumInteritemSpacing) / 2
                layout.itemSize = CGSize(width: size, height: size)
                layout.invalidateLayout()
            case .landscapeLeft, .landscapeRight:
                let size = (collectionViewPokemon.frame.width - layout.sectionInset.left - layout.sectionInset.right - (2 * layout.minimumInteritemSpacing)) / 3
                layout.itemSize = CGSize(width: size, height: size)
                layout.invalidateLayout()
            case .unknown:
                printContent("Unknown orientation")
            case .faceUp:
                printContent("Face up orientation")
            case .faceDown:
                printContent("Face down orientation")
            @unknown default:
                print("default")
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let lastItemIndex = collectionView.numberOfItems(inSection: 0) - 1
        if indexPath.row == lastItemIndex && isLoading{
            let startIndex = pokemons.count
            Task {
                await loadData()
                self.collectionViewPokemon.performBatchUpdates({
                    let endIndex = pokemons.count
                    let newIndexPaths = (startIndex..<endIndex).map {IndexPath(item: $0, section: 0)}
                    self.collectionViewPokemon.insertItems(at: newIndexPaths)
                })
            }
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionFooter {
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: LoadingFooterView.identifier, for: indexPath) as! LoadingFooterView
            if !isLoading {
                footer.startAnimating()
            } else {
                footer.stopAnimating()
            }
            return footer
        }
        return UICollectionReusableView()
    }
}

// MARK: - UISearchResultsUpdating
extension MainViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}

// MARK: - OnSeletionDelegate Protocol
extension MainViewController: OnSelectionDelegate{
    func getCount() -> Int {
        return selectedIdList.count
    }
    func selectionChanged(ID id: Int) {
        if !selectedIdList.contains(id){
            selectedIdList.append(id)
        }else{
            guard let position = selectedIdList.firstIndex(of: id)else{return}
            selectedIdList.remove(at: position)
        }
    }
}

