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
}
