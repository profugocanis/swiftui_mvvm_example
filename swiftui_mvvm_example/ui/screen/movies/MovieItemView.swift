import SwiftUI

struct MovieItemView: View {
    
    let movie: MoviesSearchResponse.Movie
   
    var body: some View {
        VStack {
            HStack {
                if let poster = movie.poster, let url = URL(string: poster) {
                    AsyncImage(
                        url: url,
                        content: { image in
                            image.resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 100, height: 100)
                        },
                        placeholder: {
                            ProgressView()
                                .frame(width: 100, height: 100)
                        }
                    )
                }
                VStack(alignment: .leading) {
                    Text("\(movie.title ?? "") (\(movie.year ?? ""))")
                }
                Spacer()
            }
            .padding(.horizontal, 8)
            
            Divider()
                .padding(.leading, 108)
        }
        .padding(.top, 2)
    }
}
