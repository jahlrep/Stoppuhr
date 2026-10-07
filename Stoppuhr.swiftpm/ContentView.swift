import SwiftUI

struct FloatingStopwatchView: View {
    @State private var timeElapsed: TimeInterval = 0
    @State private var isRunning = false
    @State private var timer: Timer? = nil
    
    // Position für das freie Verschieben auf dem Bildschirm
    @State private var offset: CGSize = .zero
    @State private var lastOffset: CGSize = .zero
    
    var body: some View {
        ZStack {
            // Hintergrund für das Testen der Transparenz/Schwebe-Optik
            Color.black.opacity(0.1)
                .ignoresSafeArea()
            
            // Stoppuhr-Fenster
            VStack(spacing: 12) {
                // Drag-Indikator oben
                Capsule()
                    .fill(Color.gray.opacity(0.5))
                    .frame(width: 36, height: 5)
                    .padding(.top, 4)
                
                // Zeitanzeige (Minuten:Sekunden:Hundertstel)
                Text(formatTime(timeElapsed))
                    .font(.system(size: 32, weight: .bold, design: .monospaced))
                    .foregroundColor(.white)
                    .minimumScaleFactor(0.5)
                
                // Steuerungsknöpfe
                HStack(spacing: 16) {
                    // Start / Stopp
                    Button(action: toggleTimer) {
                        Image(systemName: isRunning ? "pause.fill" : "play.fill")
                            .font(.title2)
                            .foregroundColor(.white)
                            .frame(width: 44, height: 44)
                            .background(isRunning ? Color.orange : Color.green)
                            .clipShape(Circle())
                    }
                    
                    // Reset
                    Button(action: resetTimer) {
                        Image(systemName: "arrow.counterclockwise")
                            .font(.title2)
                            .foregroundColor(.white)
                            .frame(width: 44, height: 44)
                            .background(Color.gray.opacity(0.6))
                            .clipShape(Circle())
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 14)
            .background(.ultraThinMaterial) // Transparenter Glas-Effekt
            .cornerRadius(20)
            .shadow(color: Color.black.opacity(0.3), radius: 10, x: 0, y: 5)
            .offset(offset)
            // Gestensteuerung zum Verschieben mit dem Finger
            .gesture(
                DragGesture()
                    .onChanged { value in
                        offset = CGSize(
                            width: lastOffset.width + value.translation.width,
                            height: lastOffset.height + value.translation.height
                        )
                    }
                    .onEnded { _ in
                        lastOffset = offset
                    }
            )
        }
    }
    
    // MARK: - Timer Funktionen
    
    private func toggleTimer() {
        if isRunning {
            timer?.invalidate()
            timer = nil
        } else {
            timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { _ in
                timeElapsed += 0.01
            }
        }
        isRunning.toggle()
    }
    
    private func resetTimer() {
        timer?.invalidate()
        timer = nil
        isRunning = false
        timeElapsed = 0
    }
    
    private func formatTime(_ time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        let fraction = Int((time.truncatingRemainder(dividingBy: 1)) * 100)
        return String(format: "%02d:%02d,%02d", minutes, seconds, fraction)
    }
}

// Vorschau / Haupteinstiegspunkt
struct ContentView: View {
    var body: some View {
        FloatingStopwatchView()
    }
}

