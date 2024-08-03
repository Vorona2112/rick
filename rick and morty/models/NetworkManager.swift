//
//  NetworkManager.swift
//  rick and morty
//
//  Created by user on 27.07.2024.
//

import Foundation
import CoreData
import UIKit

struct CharacterResponse: Codable {
    let results: [Character]
}

struct Character: Codable {
    let id: Int
    let name: String
    let status: String
    let species: String
    let type: String
    let gender: String
    let image: String
    let url: String
    let created: String
    let origin: Location
    let location: Location
}

struct Location: Codable {
    let name: String
    let url: String
}

class NetworkManager {
    static let shared = NetworkManager()
        
        private let baseURL = "https://rickandmortyapi.com/api/"
        private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        private init() {}
    
    func fetchCharacters(completion: @escaping (Result<[Character], Error>) -> Void) {
        let url = URL(string: "\(baseURL)character")!
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Нет данных"])))
                return
            }
            
            do {
                let response = try JSONDecoder().decode(CharacterResponse.self, from: data)
                self.saveCharacters(response.results)
                completion(.success(response.results))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    private func saveCharacters(_ characters: [Character]) {
        clearCharacters() //сохранить полученных персонажей в Core Data.
        
        for character in characters {
            let characterEntity = CharacterEntity(context: context)
            characterEntity.id = Int64(character.id)
            characterEntity.name = character.name
            characterEntity.status = character.status
            characterEntity.species = character.species
            characterEntity.type = character.type
            characterEntity.gender = character.gender
            characterEntity.image = character.image
            characterEntity.url = character.url
            characterEntity.created = character.created
            characterEntity.originName = character.origin.name
            characterEntity.locationName = character.location.name
            characterEntity.isFavorite = false // Инициализируем значение по умолчанию
        }
        
        do {
            try context.save()
        } catch {
            print("Не удалось сохранить персонажей: \(error)")
        }
    }
    // удалить существующих персонажей перед сохранением новых данных.
    private func clearCharacters() {
        let fetchRequest: NSFetchRequest<CharacterEntity> = CharacterEntity.fetchRequest()
        do {
            let characters = try context.fetch(fetchRequest)
            for character in characters {
                context.delete(character)
            }
            try context.save()
        } catch {
            print("Не удалось очистить персонажей: \(error)")
        }
    }
    //загрузить сохраненных персонажей из Core Data.
    func loadCharacters() -> [CharacterEntity] {
        let fetchRequest: NSFetchRequest<CharacterEntity> = CharacterEntity.fetchRequest()
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Не удалось загрузить персонажей: \(error)")
            return []
        }
        }
}



