import Foundation

class DogBreedService {
    func fetchBreeds(completion: @escaping (Result<[String], Error>) -> Void) {
        let url = URL(string: "https://dog.ceo/api/breeds/list/all")!
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else { return }
            do {
                let response = try JSONDecoder().decode(BreedResponse.self, from: data)
                let breeds = response.message.keys.sorted()
                completion(.success(breeds))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func fetchRandomImage(for breed: String, completion: @escaping (Result<String, Error>) -> Void) {
        let url = URL(string: "https://dog.ceo/api/breed/\(breed)/images/random")!
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else { return }
            do {
                let response = try JSONDecoder().decode(ImageResponse.self, from: data)
                completion(.success(response.message))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}

struct BreedResponse: Codable {
    let message: [String: [String]]
    let status: String
}

struct ImageResponse: Codable {
    let message: String
    let status: String
}

