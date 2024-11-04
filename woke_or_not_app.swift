import SwiftUI

// Main View - ContentView for Woke or Not App
struct ContentView: View {
    @State private var searchText = ""
    @State private var selectedCategory: CategoryType = .companies
    @State private var selectedItem: CategoryItem?
    
    var body: some View {
        NavigationView {
            VStack {
                // Title Section
                HStack(spacing: 4) {
                    Text("WOKE")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.blue)
                    Text("OR")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.white)
                    Text("NOT")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.red)
                    Text("?")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.white)
                }
                .padding(.top, 20)
                
                // Category Tabs Section
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 15) {
                        ForEach(CategoryType.allCases, id: \.self) { category in
                            Button(action: {
                                selectedCategory = category
                                searchText = ""  // Reset search text when switching categories
                            }) {
                                Text(category.rawValue)
                                    .font(.headline)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 5)
                                    .foregroundColor(selectedCategory == category ? .blue : .gray)
                                    .background(selectedCategory == category ? Color.blue.opacity(0.1) : Color.clear)
                                    .cornerRadius(10)
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 10)
                }
                
                // Search Bar
                HStack {
                    TextField("Woke or Not", text: $searchText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                    Button("Search") {
                        // Search action, filtering items based on searchText
                    }
                    .padding(.trailing)
                    .foregroundColor(.blue)
                }
                .padding(.horizontal)
                
                // Content Display
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        // WOKE Section
                        VStack(alignment: .leading, spacing: 10) {
                            Text("WOKE \(selectedCategory.rawValue.uppercased())")
                                .font(.title2)
                                .foregroundColor(.blue)
                                .padding(.leading)
                            
                            ForEach(topItems(isWoke: true), id: \.id) { item in
                                Button(action: {
                                    selectedItem = item
                                }) {
                                    CategoryRow(item: item)
                                        .padding(.horizontal)
                                }
                            }
                        }
                        
                        Divider().background(Color.gray)
                        
                        // NOT WOKE Section
                        VStack(alignment: .leading, spacing: 10) {
                            Text("NOT WOKE \(selectedCategory.rawValue.uppercased())")
                                .font(.title2)
                                .foregroundColor(.red)
                                .padding(.leading)
                            
                            ForEach(topItems(isWoke: false), id: \.id) { item in
                                Button(action: {
                                    selectedItem = item
                                }) {
                                    CategoryRow(item: item)
                                        .padding(.horizontal)
                                }
                            }
                        }
                    }
                    .padding(.top, 10)
                }
            }
            .background(Color.black.edgesIgnoringSafeArea(.all))
            .sheet(item: $selectedItem) { item in
                DetailView(item: item) // Opening detail view for selected item
            }
        }
    }
    
    // Function to fetch top 5 items based on Woke or Not Woke status, category, and search text
    func topItems(isWoke: Bool) -> [CategoryItem] {
        sampleData
            .filter { $0.category == selectedCategory && $0.isWoke == isWoke &&
                (searchText.isEmpty || $0.name.lowercased().contains(searchText.lowercased()))
            }
            .prefix(5)
            .map { $0 }
    }
}

// Detail View for displaying detailed information about each item
struct DetailView: View {
    var item: CategoryItem
    
    var body: some View {
        VStack(spacing: 20) {
            // Logo or Placeholder Image
            AsyncImage(url: item.logoURL) { image in
                image.resizable().scaledToFit()
            } placeholder: {
                Image(systemName: "photo") // Placeholder if image cannot be loaded
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.gray)
            }
            .frame(width: 100, height: 100)
            
            // Item Name
            Text(item.name)
                .font(.largeTitle)
                .padding()
            
            // Woke Status
            Text(item.isWoke ? "WOKE" : "NOT WOKE")
                .font(.title)
                .foregroundColor(item.isWoke ? .blue : .red)
            
            // Woke Percentage
            Text("Woke Percentage: \(item.isWoke ? item.wokePercentage : (100 - item.wokePercentage))%")
                .font(.title2)
            
            // Evidence Link (if available)
            if let evidenceURL = item.evidenceURL {
                Link("Best Evidence", destination: evidenceURL)
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            
            Spacer()
        }
        .padding()
        .background(Color.black.edgesIgnoringSafeArea(.all))
    }
}

// Row Component for displaying each item in the main list with dynamic image loading
struct CategoryRow: View {
    let item: CategoryItem
    
    var body: some View {
        HStack {
            // Dynamically loaded logo or placeholder icon
            AsyncImage(url: item.logoURL) { image in
                image.resizable().scaledToFit()
            } placeholder: {
                Image(systemName: "photo") // Placeholder if logo URL fails
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.gray)
            }
            .frame(width: 40, height: 40)
            
            // Item Name
            Text(item.name)
                .foregroundColor(item.isWoke ? .blue : .red)
                .font(.headline)
            
            Spacer()
            
            // Woke Percentage
            Text("\(item.isWoke ? item.wokePercentage : (100 - item.wokePercentage))%")
                .foregroundColor(item.isWoke ? .blue : .red)
                .font(.headline)
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(8)
    }
}

// Data Models and Fully Populated Sample Data including all categories
struct CategoryItem: Identifiable {
    let id = UUID()
    let name: String
    let category: CategoryType
    let isWoke: Bool
    let wokePercentage: Int
    let logoURL: URL?       // URL for the logo or image
    let evidenceURL: URL?   // URL for supporting evidence
}

enum CategoryType: String, CaseIterable {
    case companies = "Companies"
    case countries = "Countries"
    case nonProfits = "Non-Profits"
    case media = "Media"
    case educational = "Educational"
    case government = "Government"
}

let sampleData = [
    // Companies - Vogue
    CategoryItem(name: "Apple", category: .companies, isWoke: true, wokePercentage: 90, logoURL: URL(string: "https://cdn.jsdelivr.net/gh/company-logos/apple.png"), evidenceURL: URL(string: "https://example.com/apple-evidence")),
    CategoryItem(name: "Google", category: .companies, isWoke: true, wokePercentage: 85, logoURL: URL(string: "https://cdn.jsdelivr.net/gh/company-logos/google.png"), evidenceURL: URL(string: "https://example.com/google-evidence")),
    CategoryItem(name: "Microsoft", category: .companies, isWoke: true, wokePercentage: 80, logoURL: URL(string: "https://cdn.jsdelivr.net/gh/company-logos/microsoft.png"), evidenceURL: URL(string: "https://example.com/microsoft-evidence")),
    CategoryItem(name: "Amazon", category: .companies, isWoke: true, wokePercentage: 75, logoURL: URL(string: "https://cdn.jsdelivr.net/gh/company-logos/amazon.png"), evidenceURL: URL(string: "https://example.com/amazon-evidence")),
    CategoryItem(name: "Nike", category: .companies, isWoke: true, wokePercentage: 70, logoURL: URL(string: "https://cdn.jsdelivr.net/gh/company-logos/nike.png"), evidenceURL: URL(string: "https://example.com/nike-evidence")),
    
    // Companies - Not Vogue
    CategoryItem(name: "Chick-fil-A", category: .companies, isWoke: false, wokePercentage: 30, logoURL: URL(string: "https://cdn.jsdelivr.net/gh/company-logos/chickfila.png"), evidenceURL: URL(string: "https://example.com/chickfila-evidence")),
    CategoryItem(name: "Hobby Lobby", category: .companies, isWoke: false, wokePercentage: 20, logoURL: URL(string: "https://cdn.jsdelivr.net/gh/company-logos/hobbylobby.png"), evidenceURL: URL(string: "https://example.com/hobbylobby-evidence")),
    CategoryItem(name: "Goya", category: .companies, isWoke: false, wokePercentage: 25, logoURL: URL(string: "https://cdn.jsdelivr.net/gh/company-logos/goya.png"), evidenceURL: URL(string: "https://example.com/goya-evidence")),
    CategoryItem(name: "Home Depot", category: .companies, isWoke: false, wokePercentage: 40, logoURL: URL(string: "https://cdn.jsdelivr.net/gh/company-logos/homedepot.png"), evidenceURL: URL(string: "https://example.com/homedepot-evidence")),
    CategoryItem(name: "Walmart", category: .companies, isWoke: false, wokePercentage: 35, logoURL: URL(string: "https://cdn.jsdelivr.net/gh/company-logos/walmart.png"), evidenceURL: URL(string: "https://example.com/walmart-evidence")),
    
    // Countries - Vogue
    CategoryItem(name: "Canada", category: .countries, isWoke: true, wokePercentage: 88, logoURL: URL(string: "https://cdn.jsdelivr.net/gh/country-flags/canada.png"), evidenceURL: URL(string: "https://example.com/canada-evidence")),
    CategoryItem(name: "Sweden", category: .countries, isWoke: true, wokePercentage: 82, logoURL: URL(string: "https://cdn.jsdelivr.net/gh/country-flags/sweden.png"), evidenceURL: URL(string: "https://example.com/sweden-evidence")),
    CategoryItem(name: "Germany", category: .countries, isWoke: true, wokePercentage: 78, logoURL: URL(string: "https://cdn.jsdelivr.net/gh/country-flags/germany.png"), evidenceURL: URL(string: "https://example.com/germany-evidence")),
    CategoryItem(name: "New Zealand", category: .countries, isWoke: true, wokePercentage: 85, logoURL: URL(string: "https://cdn.jsdelivr.net/gh/country-flags/newzealand.png"), evidenceURL: URL(string: "https://example.com/newzealand-evidence")),
    CategoryItem(name: "Norway", category: .countries, isWoke: true, wokePercentage: 80, logoURL: URL(string: "https://cdn.jsdelivr.net/gh/country-flags/norway.png"), evidenceURL: URL(string: "https://example.com/norway-evidence")),
    
    // Countries - Not Vogue
    CategoryItem(name: "Russia", category: .countries, isWoke: false, wokePercentage: 40, logoURL: URL(string: "https://cdn.jsdelivr.net/gh/country-flags/russia.png"), evidenceURL: URL(string: "https://example.com/russia-evidence")),
    CategoryItem(name: "China", category: .countries, isWoke: false, wokePercentage: 30, logoURL: URL(string: "https://cdn.jsdelivr.net/gh/country-flags/china.png"), evidenceURL: URL(string: "https://example.com/china-evidence")),
    CategoryItem(name: "Saudi Arabia", category: .countries, isWoke: false, wokePercentage: 25, logoURL: URL(string: "https://cdn.jsdelivr.net/gh/country-flags/saudiarabia.png"), evidenceURL: URL(string: "https://example.com/saudiarabia-evidence")),
    CategoryItem(name: "Iran", category: .countries, isWoke: false, wokePercentage: 15, logoURL: URL(string: "https://cdn.jsdelivr.net/gh/country-flags/iran.png"), evidenceURL: URL(string: "https://example.com/iran-evidence")),
    CategoryItem(name: "North Korea", category: .countries, isWoke: false, wokePercentage: 10, logoURL: URL(string: "https://cdn.jsdelivr.net/gh/country-flags/northkorea.png"), evidenceURL: URL(string: "https://example.com/northkorea-evidence")),
    
    // Non-Profits - Vogue
    CategoryItem(name: "Greenpeace", category: .nonProfits, isWoke: true, wokePercentage: 85, logoURL: URL(string: "https://cdn.jsdelivr.net/gh/nonprofit-logos/greenpeace.png"), evidenceURL: URL(string: "https://example.com/greenpeace-evidence")),
    CategoryItem(name: "Amnesty International", category: .nonProfits, isWoke: true, wokePercentage: 82, logoURL: URL(string: "https://cdn.jsdelivr.net/gh/nonprofit-logos/amnesty.png"), evidenceURL: URL(string: "https://example.com/amnesty-evidence")),
    CategoryItem(name: "Doctors Without Borders", category: .nonProfits, isWoke: true, wokePercentage: 90, logoURL: URL(string: "https://cdn.jsdelivr.net/gh/nonprofit-logos/doctors.png"), evidenceURL: URL(string: "https://example.com/doctors-evidence")),
    CategoryItem(name: "Oxfam", category: .nonProfits, isWoke: true, wokePercentage: 78, logoURL: URL(string: "https://cdn.jsdelivr.net/gh/nonprofit-logos/oxfam.png"), evidenceURL: URL(string: "https://example.com/oxfam-evidence")),
    CategoryItem(name: "Red Cross", category: .nonProfits, isWoke: true, wokePercentage: 80, logoURL: URL(string: "https://cdn.jsdelivr.net/gh/nonprofit-logos/redcross.png"), evidenceURL: URL(string: "https://example.com/redcross-evidence")),
    
    // Non-Profits - Not Vogue
    CategoryItem(name: "Heritage Foundation", category: .nonProfits, isWoke: false, wokePercentage: 35, logoURL: URL(string: "https://cdn.jsdelivr.net/gh/nonprofit-logos/heritage.png"), evidenceURL: URL(string: "https://example.com/heritage-evidence")),
    CategoryItem(name: "NRA Foundation", category: .nonProfits, isWoke: false, wokePercentage: 20, logoURL: URL(string: "https://cdn.jsdelivr.net/gh/nonprofit-logos/nra.png"), evidenceURL: URL(string: "https://example.com/nra-evidence")),
    CategoryItem(name: "Family Research Council", category: .nonProfits, isWoke: false, wokePercentage: 25, logoURL: URL(string: "https://cdn.jsdelivr.net/gh/nonprofit-logos/frc.png"), evidenceURL: URL(string: "https://example.com/frc-evidence")),
    CategoryItem(name: "Turning Point USA", category: .nonProfits, isWoke: false, wokePercentage: 30, logoURL: URL(string: "https://cdn.jsdelivr.net/gh/nonprofit-logos/tpusa.png"), evidenceURL: URL(string: "https://example.com/tpusa-evidence")),
    CategoryItem(name: "PragerU", category: .nonProfits, isWoke: false, wokePercentage: 15, logoURL: URL(string: "https://cdn.jsdelivr.net/gh/nonprofit-logos/prageru.png"), evidenceURL: URL(string: "https://example.com/prageru-evidence")),
    
    // Educational - Vogue
    CategoryItem(name: "Harvard University", category: .educational, isWoke: true, wokePercentage: 90, logoURL: URL(string: "https://cdn.jsdelivr.net/gh/educational-logos/harvard.png"), evidenceURL: URL(string: "https://example.com/harvard-evidence")),
    CategoryItem(name: "Stanford University", category: .educational, isWoke: true, wokePercentage: 88, logoURL: URL(string: "https://cdn.jsdelivr.net/gh/educational-logos/stanford.png"), evidenceURL: URL(string: "https://example.com/stanford-evidence")),
    CategoryItem(name: "MIT", category: .educational, isWoke: true, wokePercentage: 85, logoURL: URL(string: "https://cdn.jsdelivr.net/gh/educational-logos/mit.png"), evidenceURL: URL(string: "https://example.com/mit-evidence")),
    CategoryItem(name: "University of California, Berkeley", category: .educational, isWoke: true, wokePercentage: 80, logoURL: URL(string: "https://cdn.jsdelivr.net/gh/educational-logos/ucberkeley.png"), evidenceURL: URL(string: "https://example.com/ucberkeley-evidence")),
    CategoryItem(name: "Columbia University", category: .educational, isWoke: true, wokePercentage: 82, logoURL: URL(string: "https://cdn.jsdelivr.net/gh/educational-logos/columbia.png"), evidenceURL: URL(string: "https://example.com/columbia-evidence")),
    
    // Educational - Not Vogue
    CategoryItem(name: "Liberty University", category: .educational, isWoke: false, wokePercentage: 25, logoURL: URL(string: "https://cdn.jsdelivr.net/gh/educational-logos/liberty.png"), evidenceURL: URL(string: "https://example.com/liberty-evidence")),
    CategoryItem(name: "Hillsdale College", category: .educational, isWoke: false, wokePercentage: 30, logoURL: URL(string: "https://cdn.jsdelivr.net/gh/educational-logos/hillsdale.png"), evidenceURL: URL(string: "https://example.com/hillsdale-evidence")),
    CategoryItem(name: "Bob Jones University", category: .educational, isWoke: false, wokePercentage: 20, logoURL: URL(string: "https://cdn.jsdelivr.net/gh/educational-logos/bobjones.png"), evidenceURL: URL(string: "https://example.com/bobjones-evidence")),
    CategoryItem(name: "Brigham Young University", category: .educational, isWoke: false, wokePercentage: 28, logoURL: URL(string: "https://cdn.jsdelivr.net/gh/educational-logos/byu.png"), evidenceURL: URL(string: "https://example.com/byu-evidence")),
    CategoryItem(name: "Patrick Henry College", category: .educational, isWoke: false, wokePercentage: 22, logoURL: URL(string: "https://cdn.jsdelivr.net/gh/educational-logos/patrickhenry.png"), evidenceURL: URL(string: "https://example.com/patrickhenry-evidence")),
    
    // Media - Vogue
    CategoryItem(name: "CNN", category: .media, isWoke: true, wokePercentage: 88, logoURL: URL(string: "https://cdn.jsdelivr.net/gh/media-logos/cnn.png"), evidenceURL: URL(string: "https://example.com/cnn-evidence")),
    CategoryItem(name: "BBC", category: .media, isWoke: true, wokePercentage: 84, logoURL: URL(string: "https://cdn.jsdelivr.net/gh/media-logos/bbc.png"), evidenceURL: URL(string: "https://example.com/bbc-evidence")),
    CategoryItem(name: "New York Times", category: .media, isWoke: true, wokePercentage: 80, logoURL: URL(string: "https://cdn.jsdelivr.net/gh/media-logos/nyt.png"), evidenceURL: URL(string: "https://example.com/nyt-evidence")),
    CategoryItem(name: "The Guardian", category: .media, isWoke: true, wokePercentage: 82, logoURL: URL(string: "https://cdn.jsdelivr.net/gh/media-logos/guardian.png"), evidenceURL: URL(string: "https://example.com/guardian-evidence")),
    CategoryItem(name: "Al Jazeera", category: .media, isWoke: true, wokePercentage: 78, logoURL: URL(string: "https://cdn.jsdelivr.net/gh/media-logos/aljazeera.png"), evidenceURL: URL(string: "https://example.com/aljazeera-evidence")),
    
    // Media - Not Vogue
    CategoryItem(name: "Fox News", category: .media, isWoke: false, wokePercentage: 35, logoURL: URL(string: "https://cdn.jsdelivr.net/gh/media-logos/fox.png"), evidenceURL: URL(string: "https://example.com/fox-evidence")),
    CategoryItem(name: "Breitbart", category: .media, isWoke: false, wokePercentage: 20, logoURL: URL(string: "https://cdn.jsdelivr.net/gh/media-logos/breitbart.png"), evidenceURL: URL(string: "https://example.com/breitbart-evidence")),
    CategoryItem(name: "The Daily Wire", category: .media, isWoke: false, wokePercentage: 30, logoURL: URL(string: "https://cdn.jsdelivr.net/gh/media-logos/dailywire.png"), evidenceURL: URL(string: "https://example.com/dailywire-evidence")),
    CategoryItem(name: "Newsmax", category: .media, isWoke: false, wokePercentage: 28, logoURL: URL(string: "https://cdn.jsdelivr.net/gh/media-logos/newsmax.png"), evidenceURL: URL(string: "https://example.com/newsmax-evidence")),
    CategoryItem(name: "OANN", category: .media, isWoke: false, wokePercentage: 25, logoURL: URL(string: "https://cdn.jsdelivr.net/gh/media-logos/oann.png"), evidenceURL: URL(string: "https://example.com/oann-evidence")),
    
    // Government - Vogue
    CategoryItem(name: "European Union", category: .government, isWoke: true, wokePercentage: 85, logoURL: URL(string: "https://cdn.jsdelivr.net/gh/government-logos/eu.png"), evidenceURL: URL(string: "https://example.com/eu-evidence")),
    CategoryItem(name: "United Nations", category: .government, isWoke: true, wokePercentage: 82, logoURL: URL(string: "https://cdn.jsdelivr.net/gh/government-logos/un.png"), evidenceURL: URL(string: "https://example.com/un-evidence")),
    CategoryItem(name: "World Health Organization", category: .government, isWoke: true, wokePercentage: 78, logoURL: URL(string: "https://cdn.jsdelivr.net/gh/government-logos/who.png"), evidenceURL: URL(string: "https://example.com/who-evidence")),
    CategoryItem(name: "World Bank", category: .government, isWoke: true, wokePercentage: 80, logoURL: URL(string: "https://cdn.jsdelivr.net/gh/government-logos/worldbank.png"), evidenceURL: URL(string: "https://example.com/worldbank-evidence")),
    CategoryItem(name: "NATO", category: .government, isWoke: true, wokePercentage: 79, logoURL: URL(string: "https://cdn.jsdelivr.net/gh/government-logos/nato.png"), evidenceURL: URL(string: "https://example.com/nato-evidence")),
    
    // Government - Not Vogue
    CategoryItem(name: "Department of Defense (USA)", category: .government, isWoke: false, wokePercentage: 35, logoURL: URL(string: "https://cdn.jsdelivr.net/gh/government-logos/dod.png"), evidenceURL: URL(string: "https://example.com/dod-evidence")),
    CategoryItem(name: "Department of Justice (USA)", category: .government, isWoke: false, wokePercentage: 30, logoURL: URL(string: "https://cdn.jsdelivr.net/gh/government-logos/doj.png"), evidenceURL: URL(string: "https://example.com/doj-evidence")),
    CategoryItem(name: "CIA", category: .government, isWoke: false, wokePercentage: 28, logoURL: URL(string: "https://cdn.jsdelivr.net/gh/government-logos/cia.png"), evidenceURL: URL(string: "https://example.com/cia-evidence")),
    CategoryItem(name: "FBI", category: .government, isWoke: false, wokePercentage: 27, logoURL: URL(string: "https://cdn.jsdelivr.net/gh/government-logos/fbi.png"), evidenceURL: URL(string: "https://example.com/fbi-evidence")),
    CategoryItem(name: "ICE", category: .government, isWoke: false, wokePercentage: 22, logoURL: URL(string: "https://cdn.jsdelivr.net/gh/government-logos/ice.png"), evidenceURL: URL(string: "https://example.com/ice-evidence")),
]
