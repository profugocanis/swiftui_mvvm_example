import SwiftUI

struct MovieItemView: View {
    
    let movie: Movie
    @State private var isPressed = false
    private let viewWidth = UIScreen.main.bounds.size.width / 2 - 20
    let onTap: () -> Void
   
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                // Movie poster
                posterView
                
                // Gradient overlay for better text readability
                LinearGradient(
                    gradient: Gradient(colors: [Color.clear, Color.black.opacity(0.8)]),
                    startPoint: .center,
                    endPoint: .bottom
                )
                
                // Movie info overlay
                VStack {
                    Spacer()
                    movieInfoOverlay
                }
            }
            .frame(height: viewWidth * 1.4) // Better aspect ratio for movie posters
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(
                    color: Color.black.opacity(0.15),
                    radius: isPressed ? 4 : 12,
                    x: 0,
                    y: isPressed ? 2 : 6
                )
        )
        .scaleEffect(isPressed ? 0.95 : 1.0)
        .animation(.easeInOut(duration: 0.2), value: isPressed)
        .onTapGesture {
            // Add haptic feedback
            let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
            impactFeedback.impactOccurred()
            
            onTap()
        }
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    withAnimation(.easeInOut(duration: 0.1)) {
                        isPressed = true
                    }
                }
                .onEnded { _ in
                    withAnimation(.easeInOut(duration: 0.1)) {
                        isPressed = false
                    }
                }
        )
    }
    
    private var posterView: some View {
        Group {
            if let poster = movie.poster, let url = URL(string: poster), poster != "N/A" {
                AsyncImage(
                    url: url,
                    content: { image in
                        image.resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .clipped()
                    },
                    placeholder: {
                        placeholderView
                    }
                )
            } else {
                errorPlaceholderView
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var placeholderView: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [Color(.systemGray5), Color(.systemGray6)]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            
            VStack(spacing: 12) {
                ProgressView()
                    .scaleEffect(0.8)
                    .progressViewStyle(CircularProgressViewStyle(tint: .secondary))
                
                Text("Loading...")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
    
    private var errorPlaceholderView: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [Color(.systemGray4), Color(.systemGray5)]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            
            VStack(spacing: 8) {
                Image(systemName: "photo")
                    .font(.system(size: 24, weight: .light))
                    .foregroundColor(.secondary)
                
                Text("No Image")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
    
    private var movieInfoOverlay: some View {
        VStack(alignment: .leading, spacing: 6) {
            // Movie title
            Text(movie.title ?? "Unknown Title")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.white)
                .lineLimit(2)
                .multilineTextAlignment(.leading)
            
            // Year and type info
            HStack(spacing: 8) {
                if let year = movie.year, !year.isEmpty {
                    HStack(spacing: 4) {
                        Image(systemName: "calendar")
                            .font(.system(size: 10))
                        Text(year)
                            .font(.system(size: 11, weight: .medium))
                    }
                    .foregroundColor(.white.opacity(0.9))
                }
                
                if let type = movie.type, !type.isEmpty {
                    HStack(spacing: 4) {
                        Image(systemName: type == "movie" ? "tv" : "play.rectangle")
                            .font(.system(size: 10))
                        Text(type.capitalized)
                            .font(.system(size: 11, weight: .medium))
                    }
                    .foregroundColor(.white.opacity(0.9))
                }
                
                Spacer()
            }
        }
        .padding(.horizontal, 12)
        .padding(.bottom, 12)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
