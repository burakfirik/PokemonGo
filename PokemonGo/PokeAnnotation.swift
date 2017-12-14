//
//  PokeAnnotation.swift
//  PokemonGo
//
//  Created by Burak Firik on 12/13/17.
//  Copyright © 2017 Burak Firik. All rights reserved.
//

import UIKit
import MapKit

class PokeAnnotation: NSObject, MKAnnotation{
  var coordinate: CLLocationCoordinate2D
  var pokemon: Pokemon
  
  init(coord: CLLocationCoordinate2D, pokemon: Pokemon) {
    self.coordinate = coord
    self.pokemon = pokemon
  }
  
}
