
import SwiftUI

struct NavigationBar: View {
    private let title: String
    private let subtitle: String
    private let image: String
    
    @State private var isShowingPopover = false
    
    init(title: String, subtitle: String, image: String) {
        self.title = title
        self.subtitle = subtitle
        self.image = image
    }
    
    var body: some View {
        VStack {
            HStack {
                Text(title)
                    .frame(height: 32)
                    .foregroundStyle(Color.custBlack)
                    .font(.largeTitle)
                    .bold()
                Spacer()
                
                Button(action: {
                    self.isShowingPopover.toggle()
                }) {
                    Image(systemName: image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                        .foregroundStyle(Color.custTosca)
                }
                .popover(isPresented: $isShowingPopover, arrowEdge: .top, content: {
                    Text("Jumlah set dalam workout berkisar antara 3-6 set\nRepetisi dalam workout tergantung dari target yang diinginkan dan berkaitan dengan kemampuan dalam mengangkat beban.\nStrength : <5 Rep\nMuscle Growth : 5-15 Rep\nMuscle Tone : 15< Rep\nContoh, jka ingin mengambil jumlah repetisi dibawah 5, maka carilah beban yang memang tidak bisa diangkat melebihi 5 repetisi. Begitu juga untuk jumlah repetisi lainnya. Jika beban yang diangkat lebih ringan dari kemampuan yang ada, tidak akan terjadi pertumbuhan pada otot.")
                        .font(.caption)
                        .padding(.horizontal)
                        .frame(height: 200)
                        .presentationCompactAdaptation(.popover)
                        .presentationBackgroundInteraction(.enabled)
                })
                .padding(.trailing)
            }
    
            HStack {
                Text(subtitle)
                    .foregroundStyle(Color.custGray)
                    .frame(height: 8)
                Spacer()
            }
        }
        .padding()
    }
}

#Preview {
    NavigationBar(title: "Workouts", subtitle: "Let's workout!", image: "info.circle")
}
