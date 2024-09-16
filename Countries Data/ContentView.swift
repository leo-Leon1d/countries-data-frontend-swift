import SwiftUI

struct ContentView: View {
    @State private var searchText: String = ""  //Entering search request
    @State private var country: Country? = nil  //Found country data
    @State private var errorMessage: String? = nil  //Error message
    
    var body: some View {
        VStack {
            HStack {
                //Search Text Field
                TextField("Enter country name", text: $searchText)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                
                //Search Action Button
                Button(action: {
                    searchCountry()
                }) {
                    Text("Search")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
            .padding()
            
            //Search results
            if let country = country {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Country: \(country.name)")
                    Text("Capital: \(country.capital)")
                    Text("Area: \(country.area, specifier: "%.2f") sq km")
                    Text("Population: \(country.population)")
                    Text("GDP: \(country.gdp, specifier: "%.2f")$")
                    Text("Currency: \(country.currency)")
                }
                .padding()
            } else if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }
            
            Spacer()
        }
        .navigationTitle("Country Search")
    }
    
    //Country searching
    func searchCountry() {
        
        //Data clean-up
        country = nil
        errorMessage = nil
        
        //Checking if text exists
        guard !searchText.isEmpty else {
            errorMessage = "Please enter a country name."
            return
        }
        
        CountryService().fetchCountryByName(searchText) { fetchedCountry in
            if let fetchedCountry = fetchedCountry {
                self.country = fetchedCountry
            } else {
                self.errorMessage = "Country not found."
            }
        }
    }
}
