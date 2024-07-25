
import SwiftUI

struct NavigationBar: View {
    let title: String
    let subtitle: String
    
    @State private var isShowingPopover = false
    
    var leftItem: AnyView = AnyView(EmptyView())
    var rightItem: AnyView = AnyView(EmptyView())
    
    init(title: String, subtitle: String, rightItem: AnyView) {
        self.title = title
        self.subtitle = subtitle
        self.leftItem = AnyView(EmptyView())
        self.rightItem = rightItem
    }
    
    init(title: String, subtitle: String) {
        self.title = title
        self.subtitle = subtitle
    }
    
    var body: some View {
        VStack {
            
            HStack {
                leftItem
                Spacer()
                rightItem
            }
            
            HStack {
                Text(title)
                    .frame(height: 32)
                    .foregroundStyle(Color.custBlack)
                    .font(.largeTitle)
                    .bold()
                Spacer()
            }
    
            if !subtitle.isEmpty {
                HStack {
                    Text(subtitle)
                        .foregroundStyle(Color.custGray)
                        .frame(height: 8)
                    Spacer()
                }
            }
        }
        .padding()
    }
}

#Preview {
    NavigationBar(title: "Workouts", subtitle: "Let's workout!")
}
