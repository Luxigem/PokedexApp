//
//  PokedexViewController.swift
//  PokedexApp
//
//  Created by Miguel on 10/17/22.
//

import UIKit

class PokedexViewController: UIViewController {

    @IBOutlet weak var pokedexTableView: UITableView!
    @IBOutlet weak var pokedexCollectionView: UICollectionView!
    @IBOutlet weak var columnSwitch: UISwitch!
    var pokedexListManager = PokedexListManager()
    var pokedexArray: [PokedexListModel] = []
    var selectedPokemon: PokedexListModel? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        pokedexListManager.delegate = self
        pokedexListManager.performRequest()
        
        pokedexCollectionView.delegate = self
        pokedexCollectionView.dataSource = self
        pokedexCollectionView.register(UINib(nibName: "PokedexListCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PokedexListCollectionViewCell")
        let margin: CGFloat = 10
        guard let collectionView = pokedexCollectionView,
              let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        flowLayout.minimumInteritemSpacing = margin
        flowLayout.minimumLineSpacing = margin
        flowLayout.sectionInset = UIEdgeInsets(top: margin, left: margin, bottom: margin, right: margin)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! DetailsViewController
        if let selectedPokemon = selectedPokemon {
            destinationVC.pokemonName = selectedPokemon.pokemonName
            destinationVC.pokemonId = selectedPokemon.pokemonId
            let updatedId = String(format: "%03d", selectedPokemon.pokemonId!)
            destinationVC.pokemonImage = UIImage(named: updatedId)
        }
    }
    
    @IBAction func switchToggle(_ sender: UISwitch) {
        pokedexCollectionView.reloadData()
    }
}

extension PokedexViewController: PokedexListManagerDelegate {
    func didObtainPokedexList(pokedexList: [PokedexListModel]) {
        pokedexArray = pokedexList
        DispatchQueue.main.async {
            self.pokedexCollectionView.reloadData()
        }
    }
    
    func didFailWithError(error: Error) {
        DispatchQueue.main.async {
            let errorAlert = UIAlertController(title: "Error!", message: "The following error has occurred: \(error)", preferredStyle: UIAlertController.Style.alert)
            self.present(errorAlert, animated: true, completion: nil)
        }
    }
}

extension PokedexViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pokedexArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let pokemonInfo: PokedexListModel = pokedexArray[indexPath.row]
        let cell: PokedexListCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "PokedexListCollectionViewCell", for: indexPath) as! PokedexListCollectionViewCell
        cell.pokemonSideName.text = pokemonInfo.pokemonName?.capitalized
        cell.pokemonBottomName.text = pokemonInfo.pokemonName?.capitalized
        cell.pokemonSideName.isHidden = columnSwitch.isOn
        cell.pokemonBottomName.isHidden = !columnSwitch.isOn
        let updatedId = String(format: "%03d", pokemonInfo.pokemonId!)
        cell.pokemonImage.image = UIImage(named: updatedId)
        return cell
    }
}

extension PokedexViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedPokemon = pokedexArray[indexPath.row]
        self.performSegue(withIdentifier: "detailsSegue", sender: self)
    }
}

extension PokedexViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let noOfCellsInRow = columnSwitch.isOn ? 2 : 1
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let totalSpace = flowLayout.sectionInset.left
            + flowLayout.sectionInset.right
            + (flowLayout.minimumInteritemSpacing * CGFloat(noOfCellsInRow - 1))
        let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(noOfCellsInRow))

        return CGSize(width: size, height: 100)
    }
}
