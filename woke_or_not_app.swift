import SwiftUI

// Model for a Company
struct Company: Identifiable {
    let id = UUID()
    let name: String
    let logo: String // Use SF Symbols as placeholder for logos
    let isWoke: Bool
    let wokePercentage: Int // Woke alignment percentage
}

// Sample data for WOKE and NOT WOKE companies
let wokeCompanies: [Company] = [
    Company(name: "Apple", logo: "applelogo", isWoke: true, wokePercentage: 90),
    Company(name: "Google", logo: "globe", isWoke: true, wokePercentage: 85),
    Company(name: "Microsoft", logo: "m.square", isWoke: true, wokePercentage: 80),
    Company(name: "Amazon", logo: "a.circle", isWoke: true, wokePercentage: 75),
    Company(name: "Nike", logo: "n.circle", isWoke: true, wokePercentage: 70)
    // Add more as needed
]

let notWokeCompanies: [Company] = [
    Company(name: "Chick-fil-A", logo: "c.circle", isWoke: false, wokePercentage: 30),
    Company(name: "Hobby Lobby", logo: "h.circle", isWoke: false, wokePercentage: 20),
    Company(name: "Goya", logo: "g.circle", isWoke: false, wokePercentage: 25),
    Company(name: "Home Depot", logo: "hammer", isWoke: false, wokePercentage: 40),
    Company(name: "Walmart", logo: "w.circle", isWoke: false, wokePercentage: 35)
    // Add more as needed
]

// ContentView with WOKE and NOT WOKE sections and a search bar
struct ContentView: View {
    @State private var searchText = ""
    @State private var searchResult: Company?

    var body: some View {
        NavigationView {
            VStack {
                // Search Bar
                TextField("Enter company name", text: $searchText, onCommit: searchCompany)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .overlay(
                        Button(action: searchCompany) {
                            Text("WOKE or NOT WOKE?")
                                .padding(.trailing)
                        }, alignment: .trailing
                    )
                    .padding()
                
                // Display search result
                if let result = searchResult {
                    Text("\(result.name) is \(result.isWoke ? "WOKE" : "NOT WOKE")")
                        .font(.headline)
                        .padding()
                    Text("Woke Percentage: \(result.wokePercentage)%")
                        .foregroundColor(result.isWoke ? .green : .red)
                        .padding()
                }

                // WOKE and NOT WOKE sections
                List {
                    Section(header: Text("WOKE Companies")) {
                        ForEach(wokeCompanies) { company in
                            CompanyRow(company: company)
                        }
                    }
                    
                    Section(header: Text("NOT WOKE Companies")) {
                        ForEach(notWokeCompanies) { company in
                            CompanyRow(company: company)
                        }
                    }
                }
                .listStyle(GroupedListStyle())
                .navigationTitle("WOKE or NOT WOKE")
            }
        }
    }
    
    // Search function
    func searchCompany() {
        let allCompanies = wokeCompanies + notWokeCompanies
        searchResult = allCompanies.first { $0.name.lowercased() == searchText.lowercased() }
    }
}

// CompanyRow for displaying company name and logo
struct CompanyRow: View {
    let company: Company
    
    var body: some View {
        HStack {
            Image(systemName: company.logo) // Placeholder for company logo
                .foregroundColor(company.isWoke ? .green : .red)
            Text(company.name)
                .font(.body)
            Spacer()
            Text("\(company.wokePercentage)%")
                .foregroundColor(company.isWoke ? .green : .red)
                .font(.subheadline)
        }
    }
}

// SwiftUI Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
