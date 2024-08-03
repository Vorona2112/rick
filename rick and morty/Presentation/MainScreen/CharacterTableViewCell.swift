//
//  CharacterTableViewCell.swift
//  rick and morty
//
//  Created by user on 27.07.2024.
//

import UIKit

class CharacterTableViewCell: UITableViewCell {
    var characterImageView: UIImageView! // Создаем переменную для изображения персонажа
        var nameLabel: UILabel! // Создаем переменную для метки имени персонажа
        var starButton: UIButton! // Создаем переменную для кнопки добавления в избранное
        var infoButton: UIButton! // Создаем переменную для кнопки информации
        var character: CharacterEntity? // Переменная для хранения данных о персонаже
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            setupUI() // Настраиваем пользовательский интерфейс
        }
    required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        func setupUI() {
            characterImageView = UIImageView()
            characterImageView.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(characterImageView)
            
            nameLabel = UILabel()
            nameLabel.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(nameLabel)
            
            starButton = UIButton(type: .system)
            starButton.setTitle("☆", for: .normal)
            starButton.addTarget(self, action: #selector(toggleFavorite), for: .touchUpInside)
            starButton.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(starButton)
            
            infoButton = UIButton(type: .infoLight)
            infoButton.addTarget(self, action: #selector(showDetails), for: .touchUpInside)
            infoButton.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(infoButton)
            
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

        func configure(with character: CharacterEntity) {
            self.character = character
            nameLabel.text = character.name
            if let imageUrl = character.image, let url = URL(string: imageUrl) {
                URLSession.shared.dataTask(with: url) { data, response, error in
                    if let data = data {
                        DispatchQueue.main.async {
                            self.characterImageView.image = UIImage(data: data)
                        }
                    }
                }.resume()
            }
            updateFavoriteStatus()
        }
    
    @objc func toggleFavorite() {
            guard let character = character else { return }
            character.isFavorite.toggle() // Переключаем статус избранного
            updateFavoriteStatus() // Обновляем статус избранного
            saveContext() // Сохраняем изменения в контексте
        }
    
    func updateFavoriteStatus() {
            guard let character = character else { return }
            let title = character.isFavorite ? "★" : "☆" // Обновляем текст кнопки в зависимости от статуса избранного
            starButton.setTitle(title, for: .normal)
        }
    
    @objc func showDetails() {
            guard let character = character else { return }
            let detailVC = CharacterDetailViewController() // Инициализируем контроллер для отображения деталей персонажа
            detailVC.characterEntity = character // Передаем данные выбранного персонажа в контроллер деталей
            parentViewController?.navigationController?.pushViewController(detailVC, animated: true) // Переходим на экран деталей
        }
    
    func saveContext() {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            do {
                try context.save() // Сохраняем изменения в контексте
            } catch {
                print("Failed to save context: \(error)") // Обрабатываем ошибку сохранения
            }
        }
    }

    extension UIView {
        var parentViewController: UIViewController? {
            var parentResponder: UIResponder? = self
            while parentResponder != nil {
                parentResponder = parentResponder?.next
                if let viewController = parentResponder as? UIViewController {
                    return viewController // Возвращаем родительский контроллер, если он найден
                }
            }
            return nil
        }
    }
