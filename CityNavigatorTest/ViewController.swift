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
    

// MARK:
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setConstraints()
        
        addAdressButton.addAction(UIAction { [weak self] _ in
            self?.addAdressButtonTapped() }, for: .touchUpInside)
        
        routeAdressButton.addAction(UIAction { [weak self] _ in
            self?.routeAdressButtonTapped() }, for: .touchUpInside)
        
        resetAdressButton.addAction(UIAction { [weak self] _ in
            self?.resetAdressButtonTapped() }, for: .touchUpInside)
        
    }

    
    @objc func addAdressButtonTapped() {
        print("Tap Add")
        alertAddAdress(title: "Добавить", placeholder: "Введите адрес") { (text) in
            print(text)
        }
//        alertError(title: "Ошибка", message: "Сервер недоступен")
    }
    
    @objc func routeAdressButtonTapped() {
        print("Tap Route")
    }
    
    @objc func resetAdressButtonTapped() {
        print("Tap Reset")
    }
    
    
}

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
