//
//  PokedexListCollectionViewCell.swift
//  PokedexApp
//
//  Created by Miguel on 10/17/22.
//

import UIKit

class PokedexListCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var pokemonSideName: UILabel!
    @IBOutlet weak var pokemonBottomName: UILabel!
    @IBOutlet weak var pokemonImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
