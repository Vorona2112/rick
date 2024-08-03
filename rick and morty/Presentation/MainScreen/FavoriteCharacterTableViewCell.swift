//
//  FavoriteCharacterTableViewCell.swift
//  rick and morty
//
//  Created by user on 27.07.2024.
//

import UIKit

class FavoriteCharacterTableViewCell: UITableViewCell {
    
    var characterImageView: UIImageView!
    var nameLabel: UILabel!
    var starButton: UIButton!
    var infoButton: UIButton!
    var character: CharacterEntity?
    
    // Инициализатор ячейки
        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            // Настраиваем пользовательский интерфейс
            setupUI()
        }
    // Инициализатор, необходимый для использования ячейки из интерфейс билдера
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    // Метод для настройки пользовательского интерфейса
        func setupUI() {
            // Настраиваем изображение персонажа
            characterImageView = UIImageView()
            characterImageView.translatesAutoresizingMaskIntoConstraints = false
            characterImageView.contentMode = .scaleAspectFit
            contentView.addSubview(characterImageView)

            // Настраиваем метку имени персонажа
            nameLabel = UILabel()
            nameLabel.translatesAutoresizingMaskIntoConstraints = false
            nameLabel.textColor = .black
            contentView.addSubview(nameLabel)

            // Настраиваем кнопку избранного
            starButton = UIButton(type: .system)
            starButton.setTitle("★", for: .normal)
            starButton.addTarget(self, action: #selector(toggleFavorite), for: .touchUpInside)
            starButton.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(starButton)

            // Настраиваем кнопку информации
            infoButton = UIButton(type: .infoLight)
            infoButton.addTarget(self, action: #selector(showDetails), for: .touchUpInside)
            infoButton.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(infoButton)

            // Устанавливаем ограничения для элементов интерфейса
            NSLayoutConstraint.activate([
                characterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
                characterImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
                characterImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
                characterImageView.widthAnchor.constraint(equalTo: characterImageView.heightAnchor),

                nameLabel.leadingAnchor.constraint(equalTo: characterImageView.trailingAnchor, constant: 10),
                nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

                starButton.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 10),
                starButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

                infoButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
                infoButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
            ])
        }
    // Метод для настройки ячейки с данными персонажа
        func configure(with character: CharacterEntity) {
            self.character = character
            // Устанавливаем имя персонажа
            nameLabel.text = "Name: \(character.name ?? "")"
            // Загружаем изображение персонажа асинхронно
            if let imageUrl = character.image, let url = URL(string: imageUrl) {
                URLSession.shared.dataTask(with: url) { data, response, error in
                    if let data = data {
                        DispatchQueue.main.async {
                            self.characterImageView.image = UIImage(data: data)
                        }
                    }
                }.resume()
            }
            // Обновляем статус избранного
            updateFavoriteStatus()
        }
    // Метод для переключения статуса избранного
        @objc func toggleFavorite() {
            guard let character = character else { return }
            character.isFavorite.toggle()
            // Обновляем статус избранного
            updateFavoriteStatus()
            // Сохраняем изменения в контексте Core Data
            saveContext()
        }
    
    
    // Метод для обновления статуса избранного
        func updateFavoriteStatus() {
            guard let character = character else { return }
            let title = character.isFavorite ? "★" : "☆"
            starButton.setTitle(title, for: .normal)
        }

        // Метод для отображения деталей персонажа
        @objc func showDetails() {
//            guard let character = character else { return }
//            // Получаем родительский контроллер
//            if let parentVC = parentViewController as? UINavigationController {
//                // Создаем контроллер деталей персонажа
//                let detailVC = CharacterDetailViewController()
//                detailVC.characterEntity = character
//                // Переходим к экрану деталей персонажа
//                parentVC.pushViewController(detailVC, animated: true)
          //  }
        }

        // Метод для сохранения изменений в контексте Core Data
        func saveContext() {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            do {
                try context.save()
            } catch {
                print("Failed to save context: \(error)")
            }
        }
    }

    // Расширение для получения родительского контроллера
    extension UIView {
        var parentViewController2: UIViewController? {
            var parentResponder: UIResponder? = self
            while parentResponder != nil {
                parentResponder = parentResponder?.next
                if let viewController = parentResponder as? UIViewController {
                    return viewController
                }
            }
            return nil
        }
    }
