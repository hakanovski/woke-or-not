import SwiftUI

// Main View - ContentView for Woke or Not App with Tablet Optimizations and Animations
struct ContentView: View {
    @State private var searchText = ""
    @State private var selectedCategory: CategoryType = .companies
    @State private var selectedItem: CategoryItem?
    
    var body: some View {
        NavigationView {
            VStack {
                // Title Section with Animation
                HStack(spacing: 4) {
                    Text("WOKE")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.blue)
                        .transition(.scale) // Animates title appearance
                    Text("OR")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.white)
                        .transition(.scale)
                    Text("NOT")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.red)
                        .transition(.scale)
                    Text("?")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.white)
                        .transition(.scale)
                }
                .padding(.top, 20)
                .animation(.easeIn(duration: 0.5), value: selectedCategory) // Adds animation on category change
                
                // Category Tabs Section
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 15) {
                        ForEach(CategoryType.allCases, id: \.self) { category in
                            Button(action: {
                                withAnimation(.spring()) { // Animates category change
                                    selectedCategory = category
                                    searchText = ""  // Reset search text when switching categories
                                }
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
                
                // Content Display with Animation
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
                                    withAnimation(.easeOut) { // Animates selection of an item
                                        selectedItem = item
                                    }
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
                                    withAnimation(.easeOut) {
                                        selectedItem = item
                                    }
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
            .frame(maxWidth: .infinity, maxHeight: .infinity) // Adapts to tablet screen sizes
            .sheet(item: $selectedItem) { item in
                DetailView(item: item) // Opening detail view for selected item
            }
        }
        .navigationViewStyle(StackNavigationViewStyle()) // Optimizes for larger screens like tablets
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
            // Logo or Placeholder Image with Fade-In Animation
            AsyncImage(url: item.logoURL) { image in
                image.resizable().scaledToFit()
            } placeholder: {
                Image(systemName: "photo") // Placeholder if image cannot be loaded
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.gray)
                    .transition(.opacity) // Fade-in animation for placeholder
            }
            .frame(width: 100, height: 100)
            .animation(.easeIn, value: item.logoURL) // Animates image loading
            
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
            // Dynamically loaded logo or placeholder icon with Slide Animation
            AsyncImage(url: item.logoURL) { image in
                image.resizable().scaledToFit()
            } placeholder: {
                Image(systemName: "photo") // Placeholder if logo URL fails
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.gray)
                    .transition(.slide) // Adds slide transition for image load
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
        .animation(.easeInOut(duration: 0.3), value: item.id) // Animates row appearance
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

// Place where you add your sampleData array
// let sampleData = [...]

let sampleData = [
    // Companies - Woke
    CategoryItem(name: "Apple", category: .companies, isWoke: true, wokePercentage: 90, logoURL: URL(string: "https://logo.clearbit.com/apple.com"), evidenceURL: URL(string: "https://example.com/apple-evidence")),
    CategoryItem(name: "Google", category: .companies, isWoke: true, wokePercentage: 85, logoURL: URL(string: "https://logo.clearbit.com/google.com"), evidenceURL: URL(string: "https://example.com/google-evidence")),
    CategoryItem(name: "Microsoft", category: .companies, isWoke: true, wokePercentage: 80, logoURL: URL(string: "https://logo.clearbit.com/microsoft.com"), evidenceURL: URL(string: "https://example.com/microsoft-evidence")),
    CategoryItem(name: "Amazon", category: .companies, isWoke: true, wokePercentage: 75, logoURL: URL(string: "https://logo.clearbit.com/amazon.com"), evidenceURL: URL(string: "https://example.com/amazon-evidence")),
    CategoryItem(name: "Nike", category: .companies, isWoke: true, wokePercentage: 70, logoURL: URL(string: "https://logo.clearbit.com/nike.com"), evidenceURL: URL(string: "https://example.com/nike-evidence")),
    
    // Companies - Not Woke
    CategoryItem(name: "Chick-fil-A", category: .companies, isWoke: false, wokePercentage: 30, logoURL: URL(string: "https://logo.clearbit.com/chick-fil-a.com"), evidenceURL: URL(string: "https://example.com/chickfila-evidence")),
    CategoryItem(name: "Hobby Lobby", category: .companies, isWoke: false, wokePercentage: 20, logoURL: URL(string: "https://logo.clearbit.com/hobbylobby.com"), evidenceURL: URL(string: "https://example.com/hobbylobby-evidence")),
    CategoryItem(name: "Goya", category: .companies, isWoke: false, wokePercentage: 25, logoURL: URL(string: "https://logo.clearbit.com/goya.com"), evidenceURL: URL(string: "https://example.com/goya-evidence")),
    CategoryItem(name: "Home Depot", category: .companies, isWoke: false, wokePercentage: 40, logoURL: URL(string: "https://logo.clearbit.com/homedepot.com"), evidenceURL: URL(string: "https://example.com/homedepot-evidence")),
    CategoryItem(name: "Walmart", category: .companies, isWoke: false, wokePercentage: 35, logoURL: URL(string: "https://logo.clearbit.com/walmart.com"), evidenceURL: URL(string: "https://example.com/walmart-evidence")),
    
    // Countries - Woke
    CategoryItem(name: "Canada", category: .countries, isWoke: true, wokePercentage: 88, logoURL: URL(string: "https://logo.clearbit.com/canada.ca"), evidenceURL: URL(string: "https://example.com/canada-evidence")),
    CategoryItem(name: "Sweden", category: .countries, isWoke: true, wokePercentage: 82, logoURL: URL(string: "https://logo.clearbit.com/sweden.se"), evidenceURL: URL(string: "https://example.com/sweden-evidence")),
    CategoryItem(name: "Germany", category: .countries, isWoke: true, wokePercentage: 78, logoURL: URL(string: "https://logo.clearbit.com/germany.de"), evidenceURL: URL(string: "https://example.com/germany-evidence")),
    CategoryItem(name: "New Zealand", category: .countries, isWoke: true, wokePercentage: 85, logoURL: URL(string: "https://logo.clearbit.com/newzealand.govt.nz"), evidenceURL: URL(string: "https://example.com/newzealand-evidence")),
    CategoryItem(name: "Norway", category: .countries, isWoke: true, wokePercentage: 80, logoURL: URL(string: "https://logo.clearbit.com/norway.no"), evidenceURL: URL(string: "https://example.com/norway-evidence")),
    
    // Countries - Not Woke
    CategoryItem(name: "Russia", category: .countries, isWoke: false, wokePercentage: 40, logoURL: URL(string: "https://logo.clearbit.com/russia.ru"), evidenceURL: URL(string: "https://example.com/russia-evidence")),
    CategoryItem(name: "China", category: .countries, isWoke: false, wokePercentage: 30, logoURL: URL(string: "https://logo.clearbit.com/china.cn"), evidenceURL: URL(string: "https://example.com/china-evidence")),
    CategoryItem(name: "Saudi Arabia", category: .countries, isWoke: false, wokePercentage: 25, logoURL: URL(string: "https://logo.clearbit.com/saudi.gov.sa"), evidenceURL: URL(string: "https://example.com/saudiarabia-evidence")),
    CategoryItem(name: "Iran", category: .countries, isWoke: false, wokePercentage: 15, logoURL: URL(string: "https://logo.clearbit.com/iran.ir"), evidenceURL: URL(string: "https://example.com/iran-evidence")),
    CategoryItem(name: "North Korea", category: .countries, isWoke: false, wokePercentage: 10, logoURL: URL(string: "https://logo.clearbit.com/northkorea.kp"), evidenceURL: URL(string: "https://example.com/northkorea-evidence")),
    
    // Non-Profits - Woke
    CategoryItem(name: "Greenpeace", category: .nonProfits, isWoke: true, wokePercentage: 85, logoURL: URL(string: "https://logo.clearbit.com/greenpeace.org"), evidenceURL: URL(string: "https://example.com/greenpeace-evidence")),
    CategoryItem(name: "Amnesty International", category: .nonProfits, isWoke: true, wokePercentage: 82, logoURL: URL(string: "https://logo.clearbit.com/amnesty.org"), evidenceURL: URL(string: "https://example.com/amnesty-evidence")),
    CategoryItem(name: "Doctors Without Borders", category: .nonProfits, isWoke: true, wokePercentage: 90, logoURL: URL(string: "https://logo.clearbit.com/msf.org"), evidenceURL: URL(string: "https://example.com/doctors-evidence")),
    CategoryItem(name: "Oxfam", category: .nonProfits, isWoke: true, wokePercentage: 78, logoURL: URL(string: "https://logo.clearbit.com/oxfam.org"), evidenceURL: URL(string: "https://example.com/oxfam-evidence")),
    CategoryItem(name: "Red Cross", category: .nonProfits, isWoke: true, wokePercentage: 80, logoURL: URL(string: "https://logo.clearbit.com/redcross.org"), evidenceURL: URL(string: "https://example.com/redcross-evidence")),
    
    // Non-Profits - Not Woke
    CategoryItem(name: "Heritage Foundation", category: .nonProfits, isWoke: false, wokePercentage: 35, logoURL: URL(string: "https://logo.clearbit.com/heritage.org"), evidenceURL: URL(string: "https://example.com/heritage-evidence")),
    CategoryItem(name: "NRA Foundation", category: .nonProfits, isWoke: false, wokePercentage: 20, logoURL: URL(string: "https://logo.clearbit.com/nrafoundation.org"), evidenceURL: URL(string: "https://example.com/nra-evidence")),
    CategoryItem(name: "Family Research Council", category: .nonProfits, isWoke: false, wokePercentage: 25, logoURL: URL(string: "https://logo.clearbit.com/frc.org"), evidenceURL: URL(string: "https://example.com/frc-evidence")),
    CategoryItem(name: "Turning Point USA", category: .nonProfits, isWoke: false, wokePercentage: 30, logoURL: URL(string: "https://logo.clearbit.com/turningpointusa.com"), evidenceURL: URL(string: "https://example.com/tpusa-evidence")),
    CategoryItem(name: "PragerU", category: .nonProfits, isWoke: false, wokePercentage: 15, logoURL: URL(string: "https://logo.clearbit.com/prageru.com"), evidenceURL: URL(string: "https://example.com/prageru-evidence")),
    
    // Educational Institutions - Woke
    CategoryItem(name: "Harvard University", category: .educational, isWoke: true, wokePercentage: 90, logoURL: URL(string: "https://logo.clearbit.com/harvard.edu"), evidenceURL: URL(string: "https://example.com/harvard-evidence")),
    CategoryItem(name: "Stanford University", category: .educational, isWoke: true, wokePercentage: 88, logoURL: URL(string: "https://logo.clearbit.com/stanford.edu"), evidenceURL: URL(string: "https://example.com/stanford-evidence")),
    CategoryItem(name: "MIT", category: .educational, isWoke: true, wokePercentage: 85, logoURL: URL(string: "https://logo.clearbit.com/mit.edu"), evidenceURL: URL(string: "https://example.com/mit-evidence")),
    CategoryItem(name: "University of California, Berkeley", category: .educational, isWoke: true, wokePercentage: 80, logoURL: URL(string: "https://logo.clearbit.com/berkeley.edu"), evidenceURL: URL(string: "https://example.com/ucberkeley-evidence")),
    CategoryItem(name: "Columbia University", category: .educational, isWoke: true, wokePercentage: 82, logoURL: URL(string: "https://logo.clearbit.com/columbia.edu"), evidenceURL: URL(string: "https://example.com/columbia-evidence")),
    
    // Educational Institutions - Not Woke
    CategoryItem(name: "Liberty University", category: .educational, isWoke: false, wokePercentage: 25, logoURL: URL(string: "https://logo.clearbit.com/liberty.edu"), evidenceURL: URL(string: "https://example.com/liberty-evidence")),
    CategoryItem(name: "Hillsdale College", category: .educational, isWoke: false, wokePercentage: 30, logoURL: URL(string: "https://logo.clearbit.com/hillsdale.edu"), evidenceURL: URL(string: "https://example.com/hillsdale-evidence")),
    CategoryItem(name: "Bob Jones University", category: .educational, isWoke: false, wokePercentage: 20, logoURL: URL(string: "https://logo.clearbit.com/bju.edu"), evidenceURL: URL(string: "https://example.com/bobjones-evidence")),
    CategoryItem(name: "Brigham Young University", category: .educational, isWoke: false, wokePercentage: 28, logoURL: URL(string: "https://logo.clearbit.com/byu.edu"), evidenceURL: URL(string: "https://example.com/byu-evidence")),
    CategoryItem(name: "Patrick Henry College", category: .educational, isWoke: false, wokePercentage: 22, logoURL: URL(string: "https://logo.clearbit.com/phc.edu"), evidenceURL: URL(string: "https://example.com/patrickhenry-evidence")),
    
    // Media - Woke
    CategoryItem(name: "CNN", category: .media, isWoke: true, wokePercentage: 88, logoURL: URL(string: "https://logo.clearbit.com/cnn.com"), evidenceURL: URL(string: "https://example.com/cnn-evidence")),
    CategoryItem(name: "BBC", category: .media, isWoke: true, wokePercentage: 84, logoURL: URL(string: "https://logo.clearbit.com/bbc.com"), evidenceURL: URL(string: "https://example.com/bbc-evidence")),
    CategoryItem(name: "New York Times", category: .media, isWoke: true, wokePercentage: 80, logoURL: URL(string: "https://logo.clearbit.com/nytimes.com"), evidenceURL: URL(string: "https://example.com/nyt-evidence")),
    CategoryItem(name: "The Guardian", category: .media, isWoke: true, wokePercentage: 82, logoURL: URL(string: "https://logo.clearbit.com/theguardian.com"), evidenceURL: URL(string: "https://example.com/guardian-evidence")),
    CategoryItem(name: "Al Jazeera", category: .media, isWoke: true, wokePercentage: 78, logoURL: URL(string: "https://logo.clearbit.com/aljazeera.com"), evidenceURL: URL(string: "https://example.com/aljazeera-evidence")),
    
    // Media - Not Woke
    CategoryItem(name: "Fox News", category: .media, isWoke: false, wokePercentage: 35, logoURL: URL(string: "https://logo.clearbit.com/foxnews.com"), evidenceURL: URL(string: "https://example.com/fox-evidence")),
    CategoryItem(name: "Breitbart", category: .media, isWoke: false, wokePercentage: 20, logoURL: URL(string: "https://logo.clearbit.com/breitbart.com"), evidenceURL: URL(string: "https://example.com/breitbart-evidence")),
    CategoryItem(name: "The Daily Wire", category: .media, isWoke: false, wokePercentage: 30, logoURL: URL(string: "https://logo.clearbit.com/dailywire.com"), evidenceURL: URL(string: "https://example.com/dailywire-evidence")),
    CategoryItem(name: "Newsmax", category: .media, isWoke: false, wokePercentage: 28, logoURL: URL(string: "https://logo.clearbit.com/newsmax.com"), evidenceURL: URL(string: "https://example.com/newsmax-evidence")),
    CategoryItem(name: "OANN", category: .media, isWoke: false, wokePercentage: 25, logoURL: URL(string: "https://logo.clearbit.com/oann.com"), evidenceURL: URL(string: "https://example.com/oann-evidence")),
    
    // Government - Woke
    CategoryItem(name: "European Union", category: .government, isWoke: true, wokePercentage: 85, logoURL: URL(string: "https://logo.clearbit.com/europa.eu"), evidenceURL: URL(string: "https://example.com/eu-evidence")),
    CategoryItem(name: "United Nations", category: .government, isWoke: true, wokePercentage: 82, logoURL: URL(string: "https://logo.clearbit.com/un.org"), evidenceURL: URL(string: "https://example.com/un-evidence")),
    CategoryItem(name: "World Health Organization", category: .government, isWoke: true, wokePercentage: 78, logoURL: URL(string: "https://logo.clearbit.com/who.int"), evidenceURL: URL(string: "https://example.com/who-evidence")),
    CategoryItem(name: "World Bank", category: .government, isWoke: true, wokePercentage: 80, logoURL: URL(string: "https://logo.clearbit.com/worldbank.org"), evidenceURL: URL(string: "https://example.com/worldbank-evidence")),
    CategoryItem(name: "NATO", category: .government, isWoke: true, wokePercentage: 79, logoURL: URL(string: "https://logo.clearbit.com/nato.int"), evidenceURL: URL(string: "https://example.com/nato-evidence")),
    
    // Government - Not Woke
    CategoryItem(name: "Department of Defense (USA)", category: .government, isWoke: false, wokePercentage: 35, logoURL: URL(string: "https://logo.clearbit.com/defense.gov"), evidenceURL: URL(string: "https://example.com/dod-evidence")),
    CategoryItem(name: "Department of Justice (USA)", category: .government, isWoke: false, wokePercentage: 30, logoURL: URL(string: "https://logo.clearbit.com/justice.gov"), evidenceURL: URL(string: "https://example.com/doj-evidence")),
    CategoryItem(name: "CIA", category: .government, isWoke: false, wokePercentage: 28, logoURL: URL(string: "https://logo.clearbit.com/cia.gov"), evidenceURL: URL(string: "https://example.com/cia-evidence")),
    CategoryItem(name: "FBI", category: .government, isWoke: false, wokePercentage: 27, logoURL: URL(string: "https://logo.clearbit.com/fbi.gov"), evidenceURL: URL(string: "https://example.com/fbi-evidence")),
    CategoryItem(name: "ICE", category: .government, isWoke: false, wokePercentage: 22, logoURL: URL(string: "https://logo.clearbit.com/ice.gov"), evidenceURL: URL(string: "https://example.com/ice-evidence")),
]
