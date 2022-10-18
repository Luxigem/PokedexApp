//
//  DetailsViewController.swift
//  PokedexApp
//
//  Created by Miguel on 10/17/22.
//

import UIKit


class DetailsViewController: UIViewController {

    @IBOutlet weak var pokemonImageView: UIImageView!
    @IBOutlet weak var pokemonNameLabel: UILabel!
    @IBOutlet weak var pokemonDescriptionLabel: UILabel!
    @IBOutlet weak var pokemonAbility1Label: UILabel!
    @IBOutlet weak var pokemonAbility2Label: UILabel!
    @IBOutlet weak var pokemonHiddenAbilityLabel: UILabel!
    
    var pokemonDetailsManager = PokemonDetailsManager()
    
    var pokemonName: String?
    var pokemonId: Int?
    var pokemonImage: UIImage?
    var pokemonDescription: String?
    var pokemonAbility1: String?
    var pokemonAbility2: String?
    var pokemonHiddenAbility: String?
    
    var pokemonDescriptionInfo: PokemonDescriptionModel?
    var pokemonAbilitiesInfo: PokemonAbilitiesModel?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let id = pokemonId {
            pokemonDetailsManager.performRequestDespription(id: id)
            pokemonDetailsManager.performRequestAbilities(id: id)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        updatePokemonDetailsSegue()
        pokemonDetailsManager.delegate = self
    }

    func updatePokemonDetailsSegue() {
        pokemonNameLabel.text = pokemonName?.capitalized
        pokemonImageView.image = pokemonImage
    }
    
    func updatePokemonDescription() {
        pokemonDescriptionLabel.text = pokemonDescription
    }
    
    func updatePokemonAbilities() {
        pokemonAbility1Label.text = pokemonAbility1?.capitalized ?? "--"
        pokemonAbility2Label.text = pokemonAbility2?.capitalized ?? "--"
        pokemonHiddenAbilityLabel.text = pokemonHiddenAbility?.capitalized ?? "--"
    }
}

extension DetailsViewController: PokemonDetailsManagerDelegate {
    func didObtainPokemonDescription(pokemonDescriptionModel: PokemonDescriptionModel) {
        
        pokemonDescriptionInfo = pokemonDescriptionModel
        pokemonDescription = pokemonDescriptionInfo?.pokemonDetails
        DispatchQueue.main.async {
            self.updatePokemonDescription()
        }
    }
    
    func didObtainPokemonAbilities(pokemonAbilitiesModel: PokemonAbilitiesModel) {
        pokemonAbilitiesInfo = pokemonAbilitiesModel
        pokemonAbility1 = pokemonAbilitiesInfo?.pokemonAbility1
        pokemonAbility2 = pokemonAbilitiesInfo?.pokemonAbility2
        pokemonHiddenAbility = pokemonAbilitiesInfo?.pokemonHiddenAbility
        DispatchQueue.main.async {
            self.updatePokemonAbilities()
        }
    }
    
    func didFailWithError(error: Error) {
        
    }
    
    
}
