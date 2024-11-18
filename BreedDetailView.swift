import SwiftUI

struct BreedDetailView: View {
    let breed: String
    @State private var imageUrl: String? = nil
    
    var body: some View {
        VStack {
            if let imageUrl = imageUrl, let url = URL(string: imageUrl) {
                AsyncImage(url: url) { image in
                    image.resizable()
                        .aspectRatio(contentMode: .fit)
                } placeholder: {
                    ProgressView()
                }
            } else {
                ProgressView()
                    .onAppear {
                        fetchImage()
                    }
            }
            Text(breed.capitalized)
                .font(.title)
                .padding()
        }
    }
    
    private func fetchImage() {
        let service = DogBreedService()
        service.fetchRandomImage(for: breed) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let url):
                    self.imageUrl = url
                case .failure(let error):
                    print("Error fetching image: \(error)")
                }
            }
        }
    }
}

