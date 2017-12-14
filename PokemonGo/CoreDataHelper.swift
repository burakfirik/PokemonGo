//
//  CoreDataHelper.swift
//  PokemonGo
//
//  Created by Burak Firik on 12/13/17.
//  Copyright © 2017 Burak Firik. All rights reserved.
//

import UIKit
import CoreData

func addAllPokemon() {
  createPokemon(name: "Pikachu", imageName: "pikachu-2")
  createPokemon(name: "Snorlax", imageName: "snorlax")
  createPokemon(name: "Squirtle", imageName: "squirtle")
  createPokemon(name: "Venonat", imageName: "venonat")
  createPokemon(name: "Weedle", imageName: "weedle")
  createPokemon(name: "Zubat", imageName: "zubat")
  createPokemon(name: "Bullbasaur", imageName: "bullbasaur")
  createPokemon(name: "Caterpie", imageName: "caterpie")
  createPokemon(name: "Charmander", imageName: "charmander")
  
}

func createPokemon(name: String, imageName: String) {
  if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
    let pikachu = Pokemon(entity: Pokemon.entity(), insertInto: context)
    pikachu.name = name
    pikachu.imageName = imageName
    try? context.save()
  }
}

func getAllPokemon() -> [Pokemon] {
  if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
    if let pokeData = try? context.fetch(Pokemon.fetchRequest()) as? [Pokemon] {
      if let pokemons = pokeData {
        if pokemons.count == 0 {
          addAllPokemon()
          return getAllPokemon()
        }
        return pokemons
      } 
    }
  }
  return []
}

func getCaughtPokemon() -> [Pokemon] {
  if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
    let fetchRequest = Pokemon.fetchRequest() as NSFetchRequest<Pokemon>
    fetchRequest.predicate = NSPredicate(format: "caught == %@", true as CVarArg)
    if let pokemons = try? context.fetch(fetchRequest) {
      return pokemons
    }
  }
  return []
}

func getUnCaughtPokemon() -> [Pokemon] {
  if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
    let fetchRequest = Pokemon.fetchRequest() as NSFetchRequest<Pokemon>
    fetchRequest.predicate = NSPredicate(format: "caught == %@", false as CVarArg)
    if let pokemons = try? context.fetch(fetchRequest) {
      return pokemons
    }
  }
  return []
}


