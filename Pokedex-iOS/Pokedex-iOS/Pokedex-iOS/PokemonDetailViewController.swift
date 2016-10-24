//
//  PokemonDetailViewController.swift
//  Pokedex-iOS
//
//  Created by Bruno Gabriel on 18/10/16.
//  Copyright © 2016 Bruno Gabriel. All rights reserved.
//

import UIKit

class PokemonDetailViewController: UIViewController {
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var defenseLbl: UILabel!
    @IBOutlet weak var heightLbl: UILabel!
    @IBOutlet weak var pokedexLbl: UILabel!
    @IBOutlet weak var weightLbl: UILabel!
    @IBOutlet weak var attackLbl: UILabel!
    @IBOutlet weak var evolLbl: UILabel!
    @IBOutlet weak var currentPokeImageView: UIImageView!
    @IBOutlet weak var evolutionPokeImageView: UIImageView!
    
    var pokemon: Pokemon!

    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    func initView() {
        nameLbl.text = pokemon.name
        mainImageView.image = UIImage(named: "\(pokemon.pokedexId)" )
        currentPokeImageView.image = UIImage(named: "\(pokemon.pokedexId)" )
        
        pokemon.downloadPokemonDetail {
            self.updateUI()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func updateUI() {
        defenseLbl.text = pokemon.defense
        heightLbl.text = pokemon.height
        pokedexLbl.text = "\(pokemon.pokedexId)"
        weightLbl.text = pokemon.weight
        attackLbl.text = pokemon.attack
        typeLbl.text = pokemon.type
        evolLbl.text = pokemon.nextEvolutionText
        descriptionLbl.text = pokemon.description
        
        if pokemon.nextEvolutionId != 0 {
            evolutionPokeImageView.image = UIImage(named: "\(pokemon.nextEvolutionId)")
        } else {
            evolutionPokeImageView.isHidden = true
        }
    }

    @IBAction func onBackPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
