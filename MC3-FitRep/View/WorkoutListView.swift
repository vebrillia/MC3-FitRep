
import SwiftUI

struct WorkoutsListView: View {
    @State private var isShowingPopover: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                NavigationBar(title: "Workouts", subtitle: "Build your muscle")
                WorkoutList(title: "Bicep Curl", subtitle: "Arms", image: "BicepPerson", destination: AnyView(GuidanceView()))
                WorkoutListLocked(title: "Push Up", subtitle: "Arms & Chest")
                WorkoutListLocked(title: "Squat", subtitle: "Thighs")
                Spacer()
            }
            .background(Color.custWhite)
            .navigationTitle("Workouts")
            .toolbar(.hidden)
        }
    }
}

#Preview {
    WorkoutsListView()
}
