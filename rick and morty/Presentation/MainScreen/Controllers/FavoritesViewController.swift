//
//  FavoritesViewController.swift
//  rick and morty
//
//  Created by user on 27.07.2024.
//

import UIKit
class FavoritesViewController: UIViewController {
    var tableView: UITableView!
    var favoriteCharacters: [CharacterEntity] = []
    
    // Метод, вызываемый при загрузке представления
        override func viewDidLoad() {
            super.viewDidLoad()
            // Устанавливаем белый цвет фона представления
            let backgroundImage = UIImage (named: "background")
            let backGroundImageView = UIImageView(image: backgroundImage)
            backGroundImageView.frame = view.bounds
            backGroundImageView.contentMode = .scaleAspectFill //выводим экран
            view.addSubview(backGroundImageView) // переводим назад
            view.sendSubviewToBack(backGroundImageView)
            // Устанавливаем заголовок представления
            title = "Favorites"
            // Настраиваем таблицу
            setupTableView()
        }
    // Метод, вызываемый перед появлением представления на экране
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            // Загружаем избранные персонажи
            loadFavorites()
        }
    // Метод для настройки таблицы
        func setupTableView() {
            // Инициализируем таблицу с размером представления
            tableView = UITableView(frame: view.bounds)
            // Устанавливаем делегата таблицы
            tableView.delegate = self
            // Устанавливаем источник данных для таблицы
            tableView.dataSource = self
            // Регистрируем ячейку для повторного использования
            tableView.register(FavoriteCharacterTableViewCell.self, forCellReuseIdentifier: "FavoriteCharacterCell")
            // Добавляем таблицу в представление
            view.addSubview(tableView)
        }
    // Метод для загрузки избранных персонажей
        func loadFavorites() {
            // Фильтруем персонажей, оставляя только избранных
            favoriteCharacters = NetworkManager.shared.loadCharacters().filter { $0.isFavorite }
            // Перезагружаем данные таблицы
            tableView.reloadData()
        }
    }

// Расширение для реализации делегата и источника данных таблицы
extension FavoritesViewController: UITableViewDelegate, UITableViewDataSource {
    // Метод для указания количества строк в секции
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Возвращаем количество избранных персонажей
        return favoriteCharacters.count
    }

    // Метод для создания ячейки таблицы
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Декьюим ячейку с идентификатором "FavoriteCharacterCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteCharacterCell", for: indexPath) as! FavoriteCharacterTableViewCell
        // Получаем персонажа для текущей строки
        let character = favoriteCharacters[indexPath.row]
        // Настраиваем ячейку с данными персонажа
        cell.configure(with: character)
        // Возвращаем настроенную ячейку
        return cell
    }

    // Метод, вызываемый при выборе строки таблицы
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Получаем выбранного персонажа
        let character = favoriteCharacters[indexPath.row]
        // Создаем экземпляр контроллера деталей персонажа
        let detailVC = CharacterDetailViewController()
        // Устанавливаем выбранного персонажа в контроллере деталей
        detailVC.characterEntity = character
        // Переходим к экрану деталей персонажа
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
}
