//
//  SearchViewController.swift
//  rick and morty
//
//  Created by user on 27.07.2024.
//

import UIKit
class SearchViewController: UIViewController {
    var tableView: UITableView! // Создаем переменную для таблицы
        var searchBar: UISearchBar! // Создаем переменную для поисковой строки
        var characters: [CharacterEntity] = [] // Массив для хранения всех персонажей
        var filteredCharacters: [CharacterEntity] = [] // Массив для хранения отфильтрованных персонажей
    
    override func viewDidLoad() {
            super.viewDidLoad()
            
        let backgroundImage = UIImage (named: "background")
        let backGroundImageView = UIImageView(image: backgroundImage)
        backGroundImageView.frame = view.bounds
        backGroundImageView.contentMode = .scaleAspectFill //выводим экран
        view.addSubview(backGroundImageView) // переводим назад
        view.sendSubviewToBack(backGroundImageView)
        // Устанавливаем заголовок представления
            title = "Search" // Устанавливаем заголовок окна
            
            setupSearchBar() // Настраиваем поисковую строку
            setupTableView() // Настраиваем таблицу
            fetchCharacters() // Загружаем данные персонажей
        }
    
    func setupSearchBar() {
            searchBar = UISearchBar() // Инициализируем поисковую строку
            searchBar.delegate = self // Устанавливаем делегата для обработки событий поисковой строки
            searchBar.placeholder = "Search by Planet" // Устанавливаем текст подсказки
            searchBar.translatesAutoresizingMaskIntoConstraints = false // Отключаем автоматическое создание ограничений
            view.addSubview(searchBar) // Добавляем поисковую строку на экран
            
            // Устанавливаем ограничения для поисковой строки
            NSLayoutConstraint.activate([
                searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor), // Вверх поисковой строки привязываем к безопасной области
                searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor), // Левая граница привязана к левой границе экрана
                searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor) // Правая граница привязана к правой границе экрана
            ])
        }
    
    func setupTableView() {
            tableView = UITableView() // Инициализируем таблицу
            tableView.delegate = self // Устанавливаем делегата для обработки событий таблицы
            tableView.dataSource = self // Устанавливаем источник данных для таблицы
            tableView.register(CharacterTableViewCell.self, forCellReuseIdentifier: "CharacterCell") // Регистрируем ячейку для использования в таблице
            tableView.translatesAutoresizingMaskIntoConstraints = false // Отключаем автоматическое создание ограничений
            view.addSubview(tableView) // Добавляем таблицу на экран
            
            // Устанавливаем ограничения для таблицы
            NSLayoutConstraint.activate([
                tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor), // Верх таблицы привязываем к нижней границе поисковой строки
                tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor), // Левая граница привязана к левой границе экрана
                tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor), // Правая граница привязана к правой границе экрана
                tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor) // Нижняя граница привязана к нижней границе экрана
            ])
        }
    
    func fetchCharacters() {
            NetworkManager.shared.fetchCharacters { [weak self] result in // Загружаем данные персонажей с помощью NetworkManager
                switch result {
                case .success(let characters):
                    DispatchQueue.main.async { // Обновляем интерфейс в главном потоке
                        self?.characters = NetworkManager.shared.loadCharacters() // Загружаем данные персонажей
                        self?.filteredCharacters = self?.characters ?? [] // Инициализируем отфильтрованных персонажей
                        self?.tableView.reloadData() // Обновляем таблицу
                    }
                case .failure(let error):
                    // Обработка ошибки
                    print(error) // Печатаем ошибку в консоль
                }
            }
        }
    
    func filterCharacters(with query: String) {
            filteredCharacters = characters.filter { // Фильтруем персонажей по введенному запросу
                $0.locationName?.lowercased().contains(query.lowercased()) ?? false // Проверяем, содержится ли название локации в запросе
            }
            tableView.reloadData() // Обновляем таблицу
        }
    }
extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredCharacters = characters // Если текст пуст, показываем всех персонажей
        } else {
            filterCharacters(with: searchText) // Иначе фильтруем персонажей по введенному тексту
        }
        tableView.reloadData() // Обновляем таблицу
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredCharacters.count // Возвращаем количество отфильтрованных персонажей
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CharacterCell", for: indexPath) as! CharacterTableViewCell // Инициализируем ячейку таблицы
        let character = filteredCharacters[indexPath.row] // Получаем персонажа для текущей строки
        cell.configure(with: character) // Настраиваем ячейку с данными персонажа
        return cell // Возвращаем ячейку
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let character = filteredCharacters[indexPath.row] // Получаем выбранного персонажа
        let detailVC = CharacterDetailViewController() // Инициализируем контроллер для отображения деталей персонажа
        detailVC.characterEntity = character // Передаем данные выбранного персонажа в контроллер деталей
        navigationController?.pushViewController(detailVC, animated: true) // Переходим на экран деталей
    }
}

