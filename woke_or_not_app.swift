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
]

let notWokeCompanies: [Company] = [
    Company(name: "Chick-fil-A", logo: "c.circle", isWoke: false, wokePercentage: 30),
    Company(name: "Hobby Lobby", logo: "h.circle", isWoke: false, wokePercentage: 20),
    Company(name: "Goya", logo: "g.circle", isWoke: false, wokePercentage: 25),
    Company(name: "Home Depot", logo: "hammer", isWoke: false, wokePercentage: 40),
    Company(name: "Walmart", logo: "w.circle", isWoke: false, wokePercentage: 35)
]

struct ContentView: View {
    @State private var searchText = ""
    @State private var searchResult: Company?

    var body: some View {
        NavigationView {
            VStack {
                // Başlık (Woke or Not?)
                Text("Woke or Not?")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.purple)
                    .padding()
                
                // Search Bar
                TextField("Woke or Not", text: $searchText, onCommit: searchCompany)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .overlay(
                        Button(action: searchCompany) {
                            Text("Search")
                                .foregroundColor(.white)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(Color.blue)
                                .cornerRadius(8)
                        }, alignment: .trailing
                    )
                    .padding()
                
                // Search Result
                if let result = searchResult {
                    Text("\(result.name) is \(result.isWoke ? "WOKE" : "NOT WOKE")")
                        .font(.headline)
                        .foregroundColor(result.isWoke ? .blue : .red)
                        .padding()
                    Text("Woke Percentage: \(result.wokePercentage)%")
                        .foregroundColor(result.isWoke ? .blue : .red)
                        .padding()
                }

                // WOKE and NOT WOKE sections
                List {
                    Section(header: Text("WOKE COMPANIES").foregroundColor(.blue)) {
                        ForEach(wokeCompanies) { company in
                            CompanyRow(company: company)
                        }
                    }
                    
                    Section(header: Text("NOT WOKE COMPANIES").foregroundColor(.red)) {
                        ForEach(notWokeCompanies) { company in
                            CompanyRow(company: company)
                        }
                    }
                }
                .listStyle(GroupedListStyle())
                .navigationTitle("Woke or Not?")
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
                .foregroundColor(company.isWoke ? .blue : .red)
            Text(company.name)
                .font(.body)
            Spacer()
            Text("\(company.wokePercentage)%")
                .foregroundColor(company.isWoke ? .blue : .red)
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
    }
}
