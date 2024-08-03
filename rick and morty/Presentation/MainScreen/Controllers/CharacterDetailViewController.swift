//
//
//  CharacterDetailViewController.swift
//  rick and morty
//
//  Created by user on 27.07.2024.
//

import UIKit

class CharacterDetailViewController: UIViewController {
    var characterEntity: CharacterEntity?
    
    override func viewDidLoad() {
            super.viewDidLoad()
            
            // Устанавливаем белый цвет фона представления
        let backgroundImage = UIImage (named: "background")
        let backGroundImageView = UIImageView(image: backgroundImage)
        backGroundImageView.frame = view.bounds
        backGroundImageView.contentMode = .scaleAspectFill //выводим экран
        view.addSubview(backGroundImageView) // переводим назад
        view.sendSubviewToBack(backGroundImageView)
            // Устанавливаем заголовок представления с именем персонажа
        title = characterEntity?.name
        
        
            // Настраиваем пользовательский интерфейс
            setupUI()
        }
    // Метод для настройки пользовательского интерфейса
        func setupUI() {
            // Проверяем, что characterEntity не равен nil
            guard let character = characterEntity else { return }
            
            // Создаем UIImageView для отображения изображения персонажа
            let imageView = UIImageView()
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.contentMode = .scaleAspectFit
            view.addSubview(imageView)

            // Создаем UILabel для отображения имени персонажа
            let nameLabel = UILabel()
            nameLabel.translatesAutoresizingMaskIntoConstraints = false
            nameLabel.text = "Name: \(character.name ?? "")"
            view.addSubview(nameLabel)

            // Создаем UILabel для отображения статуса персонажа
            let statusLabel = UILabel()
            statusLabel.translatesAutoresizingMaskIntoConstraints = false
            statusLabel.text = "Status: \(character.status ?? "")"
            view.addSubview(statusLabel)

            // Создаем UILabel для отображения вида персонажа
            let speciesLabel = UILabel()
            speciesLabel.translatesAutoresizingMaskIntoConstraints = false
            speciesLabel.text = "Species: \(character.species ?? "")"
            view.addSubview(speciesLabel)

            // Создаем UILabel для отображения местоположения персонажа
            let locationLabel = UILabel()
            locationLabel.translatesAutoresizingMaskIntoConstraints = false
            locationLabel.text = "Location: \(character.locationName ?? "")"
            view.addSubview(locationLabel)

            // Асинхронно загружаем изображение персонажа
            if let imageUrl = character.image, let url = URL(string: imageUrl) {
                URLSession.shared.dataTask(with: url) { data, response, error in
                    if let data = data {
                        DispatchQueue.main.async {
                            imageView.image = UIImage(data: data)
                        }
                    }
                }.resume()
            }

            // Активируем ограничения для элементов интерфейса
            NSLayoutConstraint.activate([
                imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
                imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                imageView.heightAnchor.constraint(equalToConstant: 47),
                imageView.widthAnchor.constraint(equalToConstant: 208),

                nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
                nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

                statusLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
                statusLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                statusLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

                speciesLabel.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 10),
                speciesLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                speciesLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

                locationLabel.topAnchor.constraint(equalTo: speciesLabel.bottomAnchor, constant: 10),
                locationLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                locationLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            ])
        }
}

