//
//  ViewController.swift
//  PokemonGo
//
//  Created by Burak Firik on 12/13/17.
//  Copyright © 2017 Burak Firik. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
  
  @IBOutlet weak var mapView: MKMapView!
  var manager = CLLocationManager()
  var updateCount = 0
  
  var pokemons: [Pokemon] = []
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    pokemons = getAllPokemon()
    
    getAllPokemon()
    
    manager.delegate = self
    if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
      setup()
    } else {
      manager.requestWhenInUseAuthorization()
    }
    
    
  }
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    if status == .authorizedWhenInUse {
      setup()
    }
  }
  
  func setup() {
    mapView.showsUserLocation = true
    manager.startUpdatingLocation()
    mapView.delegate = self
    Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { (timer) in
      let anno = MKPointAnnotation()
      if let center = self.manager.location?.coordinate {
        var  annoCoordinate = center
        annoCoordinate.latitude += (Double(arc4random_uniform(200)) - 100.0) / 100000.0
        annoCoordinate.longitude += (Double(arc4random_uniform(200)) - 100.0) / 100000.0
        let randomIndex = Int(arc4random_uniform(UInt32(self.pokemons.count)))
        let randomPokemon = self.pokemons[randomIndex]
        let anno = PokeAnnotation(coord: center, pokemon: randomPokemon)
        anno.coordinate = annoCoordinate
        self.mapView.addAnnotation(anno)
      }
      
    }
  }
  
  func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
    mapView.deselectAnnotation(view.annotation, animated: true)
    if view.annotation is MKUserLocation {
      // It is the trainer
    } else {
      if let center = manager.location?.coordinate {
        if let pokemonCenter = view.annotation?.coordinate {
          let region = MKCoordinateRegionMakeWithDistance(pokemonCenter, 200, 200)
          mapView.setRegion(region, animated: false)
          if MKMapRectContainsPoint(mapView.visibleMapRect, MKMapPointForCoordinate(center)) {
            print("Yes you can catch it!")
            
            
            if let pokeAnnotation = view.annotation as? PokeAnnotation {
              pokeAnnotation.pokemon.caught = true
              if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
                try? context.save()
                if let name = pokeAnnotation.pokemon.name {
                  let alertVC = UIAlertController(title: "Congrats", message: "You caught a \(name)", preferredStyle: .alert)
                  let pokeDexAction = UIAlertAction(title: "PokeDex", style: .default, handler: { (action) in
                    self.performSegue(withIdentifier: "moveToPokeDex", sender: nil)
                  })
                  
                  let okAction = UIAlertAction(title: "Ok", style: .default, handler: { (alert) in
                    alertVC.dismiss(animated: true, completion: nil)
                  })
                  
                  alertVC.addAction(pokeDexAction)
                  alertVC.addAction(okAction)
                  present(alertVC, animated: true, completion: nil)
                }
                
              }
            }
            
            
          } else {
            if let pokeAnnotation = view.annotation as? PokeAnnotation {
              if let name = pokeAnnotation.pokemon.name {
                let alertVC = UIAlertController(title: "Unfortunate!!", message: "You cannot catch \(name)", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok", style: .default, handler: { (alert) in
                  alertVC.dismiss(animated: true, completion: nil)
                })
                alertVC.addAction(okAction)
                present(alertVC, animated: true, completion: nil)
              }
            }
          }
          
        }
        
      }
    }
    
    
  }
  
  @IBAction func centerTapped(_ sender: Any) {
    if let center = manager.location?.coordinate {
      let region = MKCoordinateRegionMakeWithDistance(center, 400, 400)
      mapView.setRegion(region, animated: false)
    }
  }
  
  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    let annoView = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
    
    if annotation is MKUserLocation {
      annoView.image = UIImage(named: "player")
      var frame = annoView.frame
      frame.size.height = 50
      frame.size.width = 50
      annoView.frame = frame
    } else {
      if let pokeAnno = annotation as? PokeAnnotation {
        if let imageName = pokeAnno.pokemon.imageName {
          annoView.image = UIImage(named: imageName)
          var frame = annoView.frame
          frame.size.height = 50
          frame.size.width = 50
          annoView.frame = frame
        }
        
      }
      
    }
    
    
    return annoView
  }
  
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    if updateCount < 3  {
      if let center = manager.location?.coordinate {
        let region = MKCoordinateRegionMakeWithDistance(center, 400, 400)
        mapView.setRegion(region, animated: false)
      }
      updateCount += 1
    } else {
      manager.stopUpdatingLocation()
    }
  }
}

