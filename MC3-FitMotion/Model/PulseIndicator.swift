//
//  PulseIndicator.swift
//  MC3-FitMotion
//
//  Created by Citta Catherine Gozali on 17/07/24.
//
import SwiftUI

//Pulse ngembang saat ada pergerakan. saat tidak ada pergerakan hanya glow yang kembang kempis. Warna berubah tergantung benar atau salah
struct pulseIndicator : View {
    @State var animatePulse = false
    @State private var poseStatus: String = "idle"
    @State private var sizeStatus: Int = 0 //untuk ngambil data berapa ukuran modifier pulse
    
    
    var body : some View{
        ZStack{
            Circle().fill(pulseColor(poseStatus).opacity(0.25))
                .frame(width: 350, height: 350).scaleEffect(self.animatePulse ? 1:0)
                .glow()
            Circle().fill(pulseColor(poseStatus).opacity(0.35)).frame(width: 250, height: 250).scaleEffect(self.animatePulse ? 1:0)
                .glow()
            Circle().fill(pulseColor(poseStatus).opacity(0.45)).frame(width: 150, height: 150).scaleEffect(self.animatePulse ? 1:0)
                .glow()
            Circle().fill(pulseColor(poseStatus)).frame(width: 50, height: 50).scaleEffect(self.animatePulse ? 1:0)
                .glow()
        }.onAppear{
            withAnimation(Animation.easeInOut(duration: 1.5).repeatCount(2, autoreverses: true)) {
                self.animatePulse.toggle()
                self.animatePulse.toggle()
            print(animatePulse)}
        }
    }
    
//    func pulseSize(status: Int) -> scaleEffect {
//        if status == 0 {
//            sizeStatus =
//        } else if status == 1 {
//            sizeStatus =
//        } else {
//            sizeStatus =
//        }
//       return sizeStatus}
    
    func pulseColor(_ poseStatus: String) -> Color { //nanti untuk kirim data dari ML pose bener atau ngga
        if poseStatus == "Benar" {
            return Color.green
        } else if poseStatus == "Salah" {
            return Color.red
        } else {
            return (Color.gray)
        }
    }
    
}

struct Glow: ViewModifier {
    @State private var throb = false //untuk kontrol pulse glow
    
    func body(content: Content) -> some View{
        ZStack{
            content
                .blur(radius: throb ? 15 : 5)
                .animation(.easeOut(duration:0.5).repeatCount(1), value:throb)
                .onAppear{throb.toggle()}
            content
        }
        
    }
}

extension View {
    func glow() -> some View {modifier (Glow())}
}

#Preview {
    pulseIndicator()
}

