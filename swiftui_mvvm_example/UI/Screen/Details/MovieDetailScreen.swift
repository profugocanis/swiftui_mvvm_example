import SwiftUI

struct MovieDetailScreen: BaseScreen {
    
    @ObservedObject private var state: MovieDetailState
    private var viewModel: MovieDetailViewModel
    
    init(_ vc: ScreenViewController, movie: Movie) {
        self.viewModel = AppComponent.shared.injectViewModel(vc)
        self.state = self.viewModel.state
        self.viewModel.loadDetail(imdbID: movie.imdbID ?? "")
    }
    
    var body: some View {
        content
    }
    
    // MARK: open
    static func open(_ nv: UINavigationController?, movie: Movie) {
        let vc = ScreenViewController { vc in
            MovieDetailScreen(vc, movie: movie)
        }
        nv?.pushViewController(vc, animated: true)
    }
}

extension MovieDetailScreen {
    
    private var content: some View {
        ZStack {
            // Simplified background
            Color.black
                .ignoresSafeArea()
            
            if state.isLoading {
                loadingView
            } else if let movieDetails = state.movieDetails {
                movieDetailView(movieDetails)
            } else {
                emptyStateView
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .preferredColorScheme(.dark)
    }
    
    private var loadingView: some View {
        VStack(spacing: 24) {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                .scaleEffect(1.2)
            
            Text("Loading movie details...")
                .font(.body)
                .foregroundColor(.white.opacity(0.8))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 24) {
            Image(systemName: "film.stack")
                .font(.system(size: 50))
                .foregroundColor(.white.opacity(0.6))
            
            VStack(spacing: 8) {
                Text("Movie Details Unavailable")
                    .font(.title3)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                
                Text("We couldn't load the details for this movie")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.7))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private func movieDetailView(_ movie: MovieDetails) -> some View {
        ZStack(alignment: .top) {
            AsyncImage(url: URL(string: movie.poster ?? "")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 500)
                    .clipped()
                    .blur(radius: 8)
                    .opacity(0.15)
            } placeholder: {
                Rectangle()
                    .fill(Color.gray.opacity(0.1))
                    .frame(height: 500)
            }
        ScrollView {
            
                VStack(spacing: 0) {
                    // Hero section
                    heroSection(movie)
                    
                    // Content sections with consistent spacing
                    VStack(spacing: 32) {
                        // Quick info pills
                        quickInfoSection(movie)
                        
                        // Plot section
                        plotSection(movie)
                        
                        // Cast and crew
                        castAndCrewSection(movie)
                        
                        // Ratings showcase
                        ratingsShowcase(movie)
                        
                        // Additional details
                        additionalDetailsSection(movie)
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 24)
                    .padding(.bottom, 40)
                }
            }
        }
        .scrollIndicators(.hidden)
    }
    
    // MARK: heroSection
    private func heroSection(_ movie: MovieDetails) -> some View {
        ZStack(alignment: .bottom) {
            HStack(alignment: .bottom, spacing: 20) {
                // Movie poster with better proportions
                AsyncImage(url: URL(string: movie.poster ?? "")) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } placeholder: {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.gray.opacity(0.3))
                        .overlay(
                            Image(systemName: "photo")
                                .font(.system(size: 32))
                                .foregroundColor(.white.opacity(0.6))
                        )
                }
                .frame(width: 120, height: 180)
                .cornerRadius(12)
                .shadow(color: .black.opacity(0.4), radius: 8, x: 0, y: 4)
                
                // Movie info with improved typography
                VStack(alignment: .leading, spacing: 12) {
                    Text(movie.title ?? "Unknown Title")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.leading)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    if let year = movie.year {
                        Text(year)
                            .font(.title3)
                            .foregroundColor(.white.opacity(0.8))
                    }
                    
                    // IMDB Rating with better styling
                    if let imdbRating = movie.imdbRating {
                        HStack(spacing: 6) {
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                                .font(.body)
                            
                            Text(imdbRating)
                                .font(.title3)
                                .fontWeight(.medium)
                                .foregroundColor(.white)
                            
                            Text("/ 10")
                                .font(.body)
                                .foregroundColor(.white.opacity(0.7))
                        }
                    }
                }
            }
            Spacer()
        }
        .padding(.top, 20)
    }
    
    private func quickInfoSection(_ movie: MovieDetails) -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                if let rated = movie.rated {
                    infoPill(icon: "shield.checkered", text: rated, color: .blue)
                }
                
                if let runtime = movie.runtime {
                    infoPill(icon: "clock", text: runtime, color: .green)
                }
                
                if let genre = movie.genre?.components(separatedBy: ", ").first {
                    infoPill(icon: "tag", text: genre, color: .purple)
                }
                
                if let language = movie.language?.components(separatedBy: ", ").first {
                    infoPill(icon: "globe", text: language, color: .orange)
                }
            }
            .padding(.horizontal, 24)
        }
        .padding(.horizontal, -24)
    }
    
    private func infoPill(icon: String, text: String, color: Color) -> some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .font(.caption)
                .foregroundColor(color)
            
            Text(text)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.white)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(color.opacity(0.3), lineWidth: 1)
                )
        )
    }
    
    private func plotSection(_ movie: MovieDetails) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            if let plot = movie.plot, !plot.isEmpty {
                Text("Synopsis")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                
                Text(plot)
                    .font(.body)
                    .lineSpacing(6)
                    .foregroundColor(.white.opacity(0.85))
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private func castAndCrewSection(_ movie: MovieDetails) -> some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Cast & Crew")
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(.white)
            
            VStack(alignment: .leading, spacing: 16) {
                if let director = movie.director {
                    modernInfoRow(title: "Director", value: director, icon: "megaphone")
                }
                
                if let writer = movie.writer {
                    modernInfoRow(title: "Writer", value: writer, icon: "pencil")
                }
                
                if let actors = movie.actors {
                    modernInfoRow(title: "Starring", value: actors, icon: "person.2")
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private func modernInfoRow(title: String, value: String, icon: String) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 10) {
                Image(systemName: icon)
                    .foregroundColor(.white.opacity(0.6))
                    .frame(width: 18)
                
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.white.opacity(0.8))
            }
            
            Text(value)
                .font(.body)
                .foregroundColor(.white)
                .lineSpacing(4)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.leading, 28)
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 20)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white.opacity(0.06))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                )
        )
    }
    
    private func ratingsShowcase(_ movie: MovieDetails) -> some View {
        VStack(alignment: .leading, spacing: 20) {
            if let ratings = movie.ratings, !ratings.isEmpty {
                Text("Ratings")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                
                LazyVGrid(columns: [
                    GridItem(.flexible(), spacing: 12),
                    GridItem(.flexible(), spacing: 12)
                ], spacing: 16) {
                    ForEach(ratings.indices, id: \.self) { index in
                        let rating = ratings[index]
                        ratingCard(rating: rating)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private func ratingCard(rating: Rating) -> some View {
        VStack(spacing: 8) {
            Text(rating.source ?? "Unknown")
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.white.opacity(0.7))
                .multilineTextAlignment(.center)
                .lineLimit(2)
            
            Text(rating.value ?? "N/A")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity, minHeight: 70)
        .padding(.vertical, 16)
        .padding(.horizontal, 12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white.opacity(0.08))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.white.opacity(0.15), lineWidth: 1)
                )
        )
    }
    
    private func additionalDetailsSection(_ movie: MovieDetails) -> some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Details")
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(.white)
            
            LazyVGrid(columns: [
                GridItem(.flexible(), spacing: 12),
                GridItem(.flexible(), spacing: 12)
            ], spacing: 16) {
                if let released = movie.released {
                    detailCard(title: "Released", value: released, icon: "calendar")
                }
                
                if let country = movie.country {
                    detailCard(title: "Country", value: country, icon: "flag")
                }
                
                if let awards = movie.awards {
                    detailCard(title: "Awards", value: awards, icon: "trophy")
                }
                
                if let boxOffice = movie.boxOffice {
                    detailCard(title: "Box Office", value: boxOffice, icon: "dollarsign.circle")
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private func detailCard(title: String, value: String, icon: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.6))
                
                Text(title)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.white.opacity(0.7))
            }
            
            Text(value)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(.white)
                .lineLimit(4)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white.opacity(0.06))
        )
    }
}
