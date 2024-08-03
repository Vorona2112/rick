//
//
//
//  CharactersViewController.swift
//  rick and morty
//
//  Created by user on 27.07.2024.
//

import UIKit

final class CharactersViewController: UIViewController {
    var characterImageView: UIImageView! //кнопки
    var nameLabel: UILabel!
    var statusLabel: UILabel!
    var planetLabel: UILabel!
    var createdLabel: UILabel!
    var starButton: UIButton!
    var infoButton: UIButton!
    var leftButton: UIButton!
    var rightButton: UIButton!
    
    var characters: [CharacterEntity] = []
    var currentIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        starButton = UIButton(type: .system)
        starButton.setTitle("☆", for: .normal)
        starButton.addTarget(self, action: #selector(toggleFavorite), for: .touchUpInside)
        let backgroundImage = UIImage (named: "background")
        let backGroundImageView = UIImageView(image: backgroundImage)
        backGroundImageView.frame = view.bounds
        backGroundImageView.contentMode = .scaleAspectFill //выводим экран
        view.addSubview(backGroundImageView) // переводим назад
        view.sendSubviewToBack(backGroundImageView)
        title = "Characters"
        setupUI()
        fetchCharacters()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadCharacters()
        
        
    }
    
    func setupUI() {
            characterImageView = UIImageView()
            characterImageView.translatesAutoresizingMaskIntoConstraints = false
            characterImageView.contentMode = .scaleAspectFit
            view.addSubview(characterImageView)

            planetLabel = UILabel()
            planetLabel.translatesAutoresizingMaskIntoConstraints = false
            planetLabel.textColor = .white
            view.addSubview(planetLabel)

            nameLabel = UILabel()
            nameLabel.translatesAutoresizingMaskIntoConstraints = false
            nameLabel.textColor = .white
            view.addSubview(nameLabel)

            statusLabel = UILabel()
            statusLabel.translatesAutoresizingMaskIntoConstraints = false
            statusLabel.textColor = .white
            view.addSubview(statusLabel)

            createdLabel = UILabel()
            createdLabel.translatesAutoresizingMaskIntoConstraints = false
            createdLabel.textColor = .white
            view.addSubview(createdLabel)

            starButton = UIButton(type: .system)
            starButton.setTitle("☆", for: .normal)
            starButton.addTarget(self, action: #selector(toggleFavorite), for: .touchUpInside)
            starButton.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(starButton)

            infoButton = UIButton(type: .infoLight)
            infoButton.addTarget(self, action: #selector(showDetails), for: .touchUpInside)
            infoButton.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(infoButton)

            leftButton = UIButton(type: .system)
            leftButton.setTitle("←", for: .normal)
            leftButton.addTarget(self, action: #selector(showPreviousCharacter), for: .touchUpInside)
            leftButton.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(leftButton)

            rightButton = UIButton(type: .system)
            rightButton.setTitle("→", for: .normal)
            rightButton.addTarget(self, action: #selector(showNextCharacter), for: .touchUpInside)
            rightButton.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(rightButton)

            NSLayoutConstraint.activate([
                characterImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                characterImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 254),
                characterImageView.heightAnchor.constraint(equalToConstant: 375),
                characterImageView.widthAnchor.constraint(equalToConstant: 300),

                planetLabel.topAnchor.constraint(equalTo: characterImageView.bottomAnchor, constant: 99),
                planetLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                planetLabel.widthAnchor.constraint(equalToConstant: 175),
                planetLabel.heightAnchor.constraint(equalToConstant: 56),

                nameLabel.topAnchor.constraint(equalTo: planetLabel.bottomAnchor, constant: 10),
                nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

                statusLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
                statusLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                statusLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

                createdLabel.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 10),
                createdLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                createdLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

                starButton.topAnchor.constraint(equalTo: createdLabel.bottomAnchor, constant: 20),
                starButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),

                infoButton.topAnchor.constraint(equalTo: createdLabel.bottomAnchor, constant: 500),
                infoButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),


                leftButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
                leftButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),

                rightButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
                rightButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
            ])

        //setupUI()
        //   fetchCharacters()
        
        
        
    }
    
    func fetchCharacters() {
        // Запрашиваем данные о персонажах из сети с помощью NetworkManager.
        NetworkManager.shared.fetchCharacters { [weak self] result in
            // Обрабатываем результат запроса.
            switch result {
            case .success(let characters):
                // Если запрос успешен, обновляем массив characters и пользовательский интерфейс.
                DispatchQueue.main.async {
                    self?.characters = NetworkManager.shared.loadCharacters() // Загружаем персонажей из локального хранилища.
                    self?.updateUI() // Обновляем пользовательский интерфейс.
                }
            case .failure(let error):
                // В случае ошибки выводим сообщение об ошибке.
                print(error)
            }
        }
    }
    func loadCharacters() {
        // Загружаем персонажей из локального хранилища через NetworkManager.
        characters = NetworkManager.shared.loadCharacters()
        // Обновляем пользовательский интерфейс.
        updateUI()
    }
    func updateUI() {
        // Проверяем, есть ли персонажи.
        guard characters.count > 0 else { return }
        // Получаем текущего персонажа.
        let character = characters[currentIndex]
        // Устанавливаем текстовые значения для меток.
        nameLabel.text = "Name: \(character.name ?? "")"
        statusLabel.text = "Status: \(character.status ?? "")"
        planetLabel.text = "Planet: \(character.locationName ?? "")"
        createdLabel.text = "Created: \(character.created ?? "")"
        
        // Проверяем, есть ли URL изображения, и загружаем его асинхронно.
        if let imageUrl = character.image, let url = URL(string: imageUrl) {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    // Обновляем изображение на главном потоке.
                    DispatchQueue.main.async {
                        self.characterImageView.image = UIImage(data: data)
                    }
                }
            }.resume()
        }
        // Устанавливаем текст кнопки избранного (звезда).
        let starTitle = character.isFavorite ? "★" : "☆"
        starButton.setTitle(starTitle, for: .normal)
    }
    
    @objc func toggleFavorite() {
        guard characters.count > 0 else { return }
        let character = characters[currentIndex]
        character.isFavorite.toggle()
        updateUI()
        saveContext()
    }
    
    @objc func showDetails() {
        // Проверяем, есть ли персонажи.
        guard characters.count > 0 else { return }
        // Переходим к экрану деталей персонажа.
        let character = characters[currentIndex]
        let detailVC = CharacterDetailViewController()
        detailVC.characterEntity = character // Устанавливаем текущего персонажа в контроллер деталей.
        navigationController?.pushViewController(detailVC, animated: true) // Навигация к новому контроллеру.
    }
    @objc func showPreviousCharacter() {
        // Проверяем, есть ли персонажи.
        guard characters.count > 0 else { return }
        // Переключаем текущего персонажа на предыдущего в массиве.
        currentIndex = (currentIndex - 1 + characters.count) % characters.count
        // Обновляем пользовательский интерфейс.
        updateUI()
    }
    @objc func showNextCharacter() {
        // Проверяем, есть ли персонажи.
        guard characters.count > 0 else { return }
        // Переключаем текущего персонажа на следующего в массиве.
        currentIndex = (currentIndex + 1) % characters.count
        // Обновляем пользовательский интерфейс.
        updateUI()
    }
    func saveContext() {
        // Получаем контекст из AppDelegate.
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do {
            // Пытаемся сохранить изменения в контексте.
            try context.save()
        } catch {
            // В случае ошибки выводим сообщение об ошибке.
            print("Failed to save context: \(error)")
        }
        
    }
}
