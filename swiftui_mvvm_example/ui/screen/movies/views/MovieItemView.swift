import SwiftUI

struct MovieItemView: View {
    
    let movie: Movie
    private let viewWidth = UIScreen.main.bounds.size.width / 2
   
    var body: some View {
        ZStack {
            if let poster = movie.poster, let url = URL(string: poster) {
                AsyncImage(
                    url: url,
                    content: { image in
                        image.resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: viewWidth)
                            .frame(maxWidth: .infinity)
                            .clipped()
                    },
                    placeholder: {
                        ProgressView()
                            .frame(height: viewWidth)
                            .frame(maxWidth: .infinity)
                    }
                )
                .frame(maxWidth: .infinity)
            }
            
            VStack {
                Spacer()
                Text("\(movie.title ?? "") (\(movie.year ?? ""))")
                    .font(.system(size: 14))
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(4)
                    .background(Color.black.opacity(0.6))
            }
        }
    }
}
