//
//  ViewController.swift
//  CityNavigatorTest
//
//  Created by Сперанский Никита on 09.02.2022.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController {
    
    // MARK: - Properties
    let mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        return mapView
    }()
    
    let addAdressButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "addAdress"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let routeAdressButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "route"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = true
        return button
    }()
    
    let resetAdressButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "reset"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = true
        return button
    }()
    
    var annotationArray = [MKPointAnnotation]()
    
    // MARK: - Override func viewDidLoad()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        
        setConstraints()
        
        addAdressButton.addAction(UIAction { [weak self] _ in
            self?.addAdressButtonTapped() }, for: .touchUpInside)
        
        routeAdressButton.addAction(UIAction { [weak self] _ in
            self?.routeAdressButtonTapped() }, for: .touchUpInside)
        
        resetAdressButton.addAction(UIAction { [weak self] _ in
            self?.resetAdressButtonTapped() }, for: .touchUpInside)
        
    }

    // MARK: - func
    private func addAdressButtonTapped() {

        alertAddAdress(title: "Добавить", placeholder: "Введите адрес") { [self] (text) in
            setupPlacemarek(adressPlace: text)
        }
    }
    
    private func routeAdressButtonTapped() {
        
        for index in 0...annotationArray.count - 2 {
            createDirectionRequest(startCoordinate: annotationArray[index].coordinate,
                                   destinationCoordinate: annotationArray[index + 1].coordinate)
        }
        mapView.showAnnotations(annotationArray, animated: true)
    }
    private func resetAdressButtonTapped() {
        mapView.removeOverlays(mapView.overlays)
        mapView.removeAnnotations(mapView.annotations)
        annotationArray = []
        routeAdressButton.isHidden = true
        resetAdressButton.isHidden = true
    }
    
    // MARK: - Private func
    private func setupPlacemarek(adressPlace: String) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(adressPlace) { [self] (placemark, error) in
            
            if let error = error {
                print(error)
                alertError(title: "Ошибка", message: "Сервер не доступен, попробуйте добавить адрем еще раз")
                return
            }
            
            guard let placemarks = placemark else { return }
            let placemark = placemarks.first
            
            let annotation = MKPointAnnotation()
            annotation.title = "\(adressPlace)"
            guard let placemarkLocation = placemark?.location else { return }
            annotation.coordinate = placemarkLocation.coordinate
            
            annotationArray.append(annotation)
            
            if annotationArray.count > 2 {
                routeAdressButton.isHidden = false
                resetAdressButton.isHidden = false
            }
            
            mapView.showAnnotations(annotationArray, animated: true)
        }
    }
    
    private func createDirectionRequest(startCoordinate: CLLocationCoordinate2D, destinationCoordinate: CLLocationCoordinate2D) {
        let startLocation = MKPlacemark(coordinate: startCoordinate)
        let destinationLocation = MKPlacemark(coordinate: destinationCoordinate)
        
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: startLocation)
        request.destination = MKMapItem(placemark: destinationLocation)
        request.transportType = .walking  // выбор типа  передвижения
        request.requestsAlternateRoutes = true  // показывать ли альтернативные пути
        
        let direction  = MKDirections(request: request)
        direction.calculate { (responce, error) in
            if let error = error {
                print(error)
                return
            }
            
            guard let responce = responce else {
                self.alertError(title: "Ошибка", message: "Маршрут недоступен")
                return
            }
            

            var minRoute = responce.routes[0]
            for route in responce.routes {
                minRoute = (route.distance < minRoute.distance) ? route : minRoute // поиск самого коротного маршрута
            }
            
            self.mapView.addOverlay(minRoute.polyline) //чтобы отобразилась надо подписать под протокол
            
        }
    }
}
// MARK: -
extension ViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay as! MKPolyline)
        renderer.strokeColor = .red
        return renderer
    }
}


// MARK: - Constraints sets
extension ViewController {
    //установка констрейнтов для карты - на весь экран
    func setConstraints() {
        view.addSubview(mapView)
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0)
        ])
        
        mapView.addSubview(addAdressButton)
        NSLayoutConstraint.activate([
            addAdressButton.topAnchor.constraint(equalTo: mapView.topAnchor, constant: 50),
            addAdressButton.trailingAnchor.constraint(equalTo: mapView.trailingAnchor, constant: -20),
            addAdressButton.heightAnchor.constraint(equalToConstant: 70),
            addAdressButton.widthAnchor.constraint(equalToConstant: 70)
        ])
        
        mapView.addSubview(routeAdressButton)
        NSLayoutConstraint.activate([
            routeAdressButton.leadingAnchor.constraint(equalTo: mapView.leadingAnchor, constant: 30),
            routeAdressButton.bottomAnchor.constraint(equalTo: mapView.bottomAnchor, constant: -20),
            routeAdressButton.heightAnchor.constraint(equalToConstant: 50),
            routeAdressButton.widthAnchor.constraint(equalToConstant: 50)
        ])
        
        mapView.addSubview(resetAdressButton)
        NSLayoutConstraint.activate([
            resetAdressButton.trailingAnchor.constraint(equalTo: mapView.trailingAnchor, constant: -20),
            resetAdressButton.bottomAnchor.constraint(equalTo: mapView.bottomAnchor, constant: -30),
            resetAdressButton.heightAnchor.constraint(equalToConstant: 50),
            resetAdressButton.widthAnchor.constraint(equalToConstant: 50)
        ])
    }
}
// Санкт-Петербург, Некрасова 22
// Санкт-Петербург, Пестеля 2
// Санкт-Петербург, Кондратьевский проспект 1
