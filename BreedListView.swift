import SwiftUI

struct BreedListView: View {
    @StateObject private var viewModel = DogBreedViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Search Breeds", text: $viewModel.searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                List(viewModel.filteredBreeds, id: \.self) { breed in
                    NavigationLink(destination: BreedDetailView(breed: breed)) {
                        Text(breed.capitalized)
                    }
                }
            }
            .navigationTitle("Dog Breeds")
        }
    }
}

