//
//  ViewController.swift
//  Pokedex-iOS
//
//  Created by Bruno Gabriel on 17/10/16.
//  Copyright © 2016 Bruno Gabriel. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {

    @IBOutlet weak var collection: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    var pokemons = [Pokemon]()
    var filteredPokemons = [Pokemon]()
    var musicPlayer: AVAudioPlayer!
    var inSearchMode = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collection.dataSource = self
        collection.delegate = self
        searchBar.delegate = self
        searchBar.returnKeyType = .done
        parsePokemonCSV()
        initAudio()
    }
    
    func initAudio() {
        let pathMusicTheme = Bundle.main.path(forResource: "musictheme", ofType: "mp3")!
        do {
            musicPlayer = try AVAudioPlayer(contentsOf: URL(string: pathMusicTheme)!)
            musicPlayer.prepareToPlay()
            musicPlayer.numberOfLoops = -1
            musicPlayer.play()
        } catch let err as NSError {
            print(err.debugDescription)
        }
    }
    
    func parsePokemonCSV() {
        let path = Bundle.main.path(forResource: "pokemon", ofType: "csv")
        
        do {
            let csv = try CSV(contentsOfURL: path!)
            let rows = csv.rows
            
            for row in rows {
                let pokeId = Int(row["id"]!)!
                let pokeName = row["identifier"]!
                let poke = Pokemon(name: pokeName, pokedexId: pokeId)
                pokemons.append(poke)
            }
        } catch let err as NSError {
            print(err.debugDescription)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return inSearchMode ? filteredPokemons.count: pokemons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PokeCellIdentifier", for: indexPath) as? PokeCell {
            cell.configureCell(pokemon: inSearchMode ? filteredPokemons[indexPath.row]: pokemons[indexPath.row])
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 105, height: 105)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var poke: Pokemon!
        poke = inSearchMode ? filteredPokemons[indexPath.row]: pokemons[indexPath.row]
        performSegue(withIdentifier: "PokemonDetailVC", sender: poke)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == "" {
            inSearchMode = false
            view.endEditing(true)
        } else {
            inSearchMode = true
            let lower = searchBar.text!.lowercased()
            filteredPokemons = pokemons.filter({
                $0.name.range(of: lower) != nil
            })
        }

        collection.reloadData()
    }
    
    @IBAction func musicPressed(_ sender: UIButton) {
        if musicPlayer.isPlaying {
            musicPlayer.pause()
            sender.alpha = 0.2
        } else {
            musicPlayer.play()
            sender.alpha = 1.0
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PokemonDetailVC" {
            if let detailsVC = segue.destination as? PokemonDetailViewController {
                if let poke = sender as? Pokemon {
                    detailsVC.pokemon = poke
                }
            }
        }
    }
}
