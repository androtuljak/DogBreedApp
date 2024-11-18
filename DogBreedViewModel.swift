import Combine
import Foundation


class DogBreedViewModel: ObservableObject {
    @Published var breeds: [String] = []
    @Published var searchText: String = ""
    @Published var filteredBreeds: [String] = []
    
    private var service = DogBreedService()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        fetchBreeds()
        setupSearch()
    }
    
    func fetchBreeds() {
        service.fetchBreeds { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let breeds):
                    self.breeds = breeds
                    self.filteredBreeds = breeds
                case .failure(let error):
                    print("Error fetching breeds: \(error)")
                }
            }
        }
    }
    
    private func setupSearch() {
        $searchText
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .sink { [weak self] text in
                self?.filteredBreeds = self?.breeds.filter { $0.contains(text.lowercased()) } ?? []
            }
            .store(in: &cancellables)
    }
}

