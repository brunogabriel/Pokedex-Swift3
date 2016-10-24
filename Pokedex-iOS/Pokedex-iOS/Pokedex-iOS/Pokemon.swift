//
//  Pokemon.swift
//  Pokedex-iOS
//
//  Created by Bruno Gabriel on 17/10/16.
//  Copyright © 2016 Bruno Gabriel. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class Pokemon {
    
    private var _name: String!
    private var _pokedexId: Int!
    private var _description: String!
    private var _type: String!
    private var _defense: String!
    private var _height: String!
    private var _weight: String!
    private var _attack: String!
    private var _nextEvolutionText: String!
    private var _pokemonURL: String!
    private var _nextEvolutionId: Int!
    
    init(name: String, pokedexId: Int) {
        self._name = name
        self._pokedexId = pokedexId
        self._pokemonURL = "\(URL_BASE)\(URL_POKEMON)\(self.pokedexId)/"
    }
    
    var name: String {
        if _name == nil {
            return ""
        }
        
        return _name
    }
    
    var pokedexId: Int{
        if _pokedexId == nil {
            return 1
        }
        
        return _pokedexId
    }
    
    var description: String {
        
        if _description == nil {
            return ""
        }
        
        return _description
    }
    
    var type: String {
        if _type == nil {
            return ""
        }
        
        return _type
    }
    
    var defense: String {
        if _defense == nil {
            return ""
        }
        
        return _defense
    }
    
    var height: String {
        if _height == nil {
            return ""
        }
        
        return _height
    }
    
    var weight: String {
        if _weight == nil {
            return ""
        }
        
        return _weight
    }
    
    var attack: String {
        if _attack == nil {
            return ""
        }
        
        return _attack
    }
    
    var nextEvolutionText: String {
        if _nextEvolutionText == nil {
            return ""
        }
        
        return _nextEvolutionText
    }
    
    var nextEvolutionId: Int {
        if _nextEvolutionId == nil {
            return 0
        }
        
        return _nextEvolutionId
    }
    
    func downloadPokemonDetail(completed: @escaping DownloadComplete) {
        Alamofire.request(self._pokemonURL, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                self._weight = json["weight"].stringValue
                self._height = json["height"].stringValue
                self._attack = json["attack"].stringValue
                self._defense = json["defense"].stringValue

                let nextEvolutionPoke = json["evolutions"][0]["to"].stringValue
                
                if nextEvolutionPoke == "" {
                    self._nextEvolutionText = "No Evolutions"
                } else {
                    self._nextEvolutionText = "Next Evolution: \(nextEvolutionPoke)"
                    self._nextEvolutionId = Int(json["evolutions"][0]["resource_uri"].stringValue.replacingOccurrences(of: "/api/v1/pokemon/", with: "").replacingOccurrences(of: "/", with: ""))
                }
                
                var jsonTypes = json["types"]
                if jsonTypes.count > 0 {
                     self._type = "\(jsonTypes[0]["name"].stringValue)"
                    
                    if jsonTypes.count > 1 {
                        for  i in 1..<jsonTypes.count {
                            let typeName = jsonTypes[i]["name"].stringValue
                            self._type! += "/\(typeName)"
                        }
                    }
                }
                
                if json["descriptions"].count > 0 {
                    let descriptionURL = "\(URL_BASE)\(json["descriptions"][0]["resource_uri"].stringValue)"
                    
                    Alamofire.request(descriptionURL, method: .get).responseJSON { response in
                        
                        self._description = JSON(response.result.value)["description"].stringValue
                        completed()
                    }
                }
                completed()
            case .failure(let error):
                print(error)
            }
        }
    }
    
}
