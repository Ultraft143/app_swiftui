import SwiftUI

struct pesquisa: View {
    private var listOfCountry = countryList
    @State private var searchText = ""

    var body: some View {
        NavigationView {
            List {
                ForEach(countries, id: \.self) { country in
                    HStack {
                        Text(country.capitalized)
                        Spacer()
                    }
                }
            }
            .searchable(text: $searchText)
            .navigationTitle("Lista")
        }
    }

    var countries: [String] {
        let lcCountries = listOfCountry.map { $0.lowercased() }
        return searchText == "" ? lcCountries : lcCountries.filter {
            $0.contains(searchText.lowercased())
        }
    }
}

struct pesquisa_Previews: PreviewProvider {
    static var previews: some View {
        pesquisa()
    }
}
