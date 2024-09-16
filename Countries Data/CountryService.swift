import Foundation

class CountryService {
    let baseURL = "http://localhost:8080/countries/name"
    static let shared = CountryService()
    
    //Getting all the countries
    func fetchCountries(completion: @escaping ([Country]?) -> Void) {
        guard let url = URL(string: baseURL) else {
            print("Invalid URL")
            completion(nil)
            return
        }
        
        //Creating a URL request
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            //Checking the error existance]
            if let error = error {
                print("Error: \(error)")
                completion(nil)
                return
            }
            
            //Checking if the server's response is valid
            guard let httpsResponse = response as? HTTPURLResponse, httpsResponse.statusCode == 200 else {
                print("Invalid server's response")
                completion(nil)
                return
            }
            
            //Checking the data existance
            guard let data = data else {
                print("No data recieved")
                completion(nil)
                return
            }
            
            //JSON parcing
            do {
                let decoder = JSONDecoder()
                let countries = try decoder.decode([Country].self, from: data)
                //Returning the data
                DispatchQueue.main.async {
                    completion(countries)
                }
            } catch {
                print("Failed to decode JSON: \(error)")
                completion(nil)
            }
        }
        
        //Running the request
        task.resume()
    }
    
    //Getting the country by name
    func fetchCountryByName(_ name: String, completion: @escaping (Country?) -> Void) {
        
        let encodedName = name.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? name
        guard let url = URL(string: "\(baseURL)/\(encodedName)") else {
            print("Invalid URL")
            completion(nil)
            return
        }

        //Check URL logging
        print("Fetching URL: \(url)")

        //Creating a URL request
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error: \(error)")
                completion(nil)
                return
            }
            
            //Checking if the server's response is valid
            guard let httpsResponse = response as? HTTPURLResponse, httpsResponse.statusCode == 200 else {
                print("Invalid server's response")
                completion(nil)
                return
            }
            
            //Checking the data existance
            guard let data = data else {
                print("No data recieved")
                completion(nil)
                return
            }
            
            //JSON parcing
            do {
                let decoder = JSONDecoder()
                let country = try decoder.decode(Country.self, from: data)
                DispatchQueue.main.async {
                    completion(country)
                }
            } catch {
                print("Failed to decode JSON: \(error)")
                completion(nil)
            }
        }
        
        //Running the request
        task.resume()
    }
}
