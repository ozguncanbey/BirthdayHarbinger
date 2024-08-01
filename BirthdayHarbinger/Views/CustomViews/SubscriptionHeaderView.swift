import SwiftUI

struct SubscriptionHeaderView: View {
    
    var language: Language
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [.gray, .black]),
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .leading, spacing: 10) {
                
                Label {
                    Text("premiumTitle".localized(language))
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.bottom, 10)
                } icon: {
                    Image(systemName: "crown.fill")
                        .foregroundColor(.white)
                        .font(.largeTitle)
                }
                
                Text("Benefit from all features".localized(language))
                    .foregroundStyle(.white.opacity(0.5))
                    .padding(.bottom)
                    .font(.callout)
                
                Label {
                    Text("Unlimited People".localized(language))
                        .foregroundColor(.white)
                        .font(.headline)
                } icon: {
                    Image(systemName: "person.3.fill")
                        .foregroundColor(.white)
                        .padding(.trailing, 1)
                }
                
                Label {
                    Text("Hide Person".localized(language))
                        .foregroundColor(.white)
                        .font(.headline)
                } icon: {
                    Image(systemName: "eye.slash.fill")
                        .foregroundColor(.white)
                        .padding(.trailing, 10)
                }
                
                Label {
                    Text("Widget")
                        .foregroundColor(.white)
                        .font(.headline)
                } icon: {
                    Image(systemName: "rectangle.grid.1x2.fill")
                        .foregroundColor(.white)
                        .padding(.trailing, 14)
                }
            }
            .padding()
        }
    }
}

#Preview {
    SubscriptionHeaderView(language: .turkish)
}
