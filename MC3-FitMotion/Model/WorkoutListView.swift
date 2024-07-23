
import SwiftUI

struct WorkoutsView: View {
    @State private var path: [Int] = []
    var body: some View {
        NavigationStack(path: $path) {
            VStack {
                NavigationBar(title: "Workouts", subtitle: "Build your muscles!")

                WorkoutList(title: "Bicep Curl", subtitle: "Arms", image: "BicepPerson3") {
                    path.append(1)
                }
                WorkoutListLocked(title: "Push Up", subtitle: "Arms & Chest")
                WorkoutListLocked(title: "Squat", subtitle: "Thighs")
                Spacer()
            }
            .navigationDestination(for: Int.self) { i in
                if i > 0 {
                    BicepCurlView()
                } else {
                    EmptyView()
                }
            }
            .background(Color.custWhite)
//            .navigationTitle("Workout List")
            .toolbar(.hidden)
        }
    }
}

#Preview {
    WorkoutsView()
}
