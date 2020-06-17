import UIKit

struct Person: Decodable {
    var name: String
    var films:[URL]
}

struct Film: Decodable{
    var title: String
    var opening_crawl: String
    var release_date: String
}

class SwapiService {

    static private let baseURL = URL(string: "https://swapi.dev/api/")

    static var personEndPoint = "people"
    
    static var fielEndPoint = "films"

    static func fetchPerson(id: Int, completion: @escaping (Person?) -> Void) {
        let personID = String(id)
        //Prepare URL
        guard let baseURL = baseURL else { return completion(nil) }
        let secondURL = baseURL.appendingPathComponent(personEndPoint)
        let finalURL = secondURL.appendingPathComponent(personID)
       
        print(finalURL)
        
        URLSession.shared.dataTask(with: finalURL) { (data, _, error) in
            if let error = error {
                print("We had an error fetching People -- \(error)")
            }
        
            guard let data = data else {return}
            
            do {
                let person = try JSONDecoder().decode(Person.self, from :data)
                return completion(person)
            }catch{
                    print("Error decoding the data - \(error) - \(error.localizedDescription)")
                    return completion(nil)
            }
        }.resume()
    }

    static func fetchFilm(url: URL, completion: @escaping (Film?) -> Void) {
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                print(error.localizedDescription)
            }
            guard let data = data else {return completion(nil)}
            
            do{
                let film = try JSONDecoder().decode(Film.self, from: data)
                return completion(film)
            }catch {
                print("Decoding error - \(error) --\(error.localizedDescription)")
                return completion(nil)
            }
            
        }.resume()
    }
    
}

func fetchFilm(url: URL) {
    SwapiService.fetchFilm(url: url) { (film) in
        if let film = film {
            print(film.title)
        }
    }
}
    



SwapiService.fetchPerson(id: 1) { (person) in
    if let person = person {
        print(person)
        for film in person.films {
            fetchFilm(url: film)
        }
    }
}



