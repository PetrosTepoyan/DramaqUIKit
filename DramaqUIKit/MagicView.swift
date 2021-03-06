//
//  MagicView.swift
//  DramaqUIKit
//
//  Created by Петрос Тепоян on 1/10/21.
//

import SwiftUI
import CoreData
import Accelerate
import Combine

struct MagicView: View {
    
    @FetchRequest(entity: Record.entity(), sortDescriptors: [])
    var records: FetchedResults<Record>
    
    //    let model = RecordsModel(context: <#T##NSManagedObjectContext#>)
    
    let testInput: [(Color, Double)] = [
        (Color("Food"), 0.4),
        (Color("Entertainment"), 0.3),
        (Color("Shop"), 0.2),
        (Color("Transportation"), 0.05),
        (Color("Beauty"), 0.05)]
    
    @State var offset : CGPoint = CGPoint()
    let startOffset = CGPoint(x: CGFloat.random(in: -40...40),
                              y: CGFloat.random(in: -20...20))
    
    
    
    var body: some View {
        ZStack {
            ForEach(0..<testInput.count) { id in
                let color = testInput[id].0
                let prob  = testInput[id].1
                RadialGradient(gradient:
                                Gradient(colors: [color.darker(by: 0.2),
                                                  color.lighter(by: 0.6)]),
                               center: .center,
                               startRadius: /*@START_MENU_TOKEN@*/5/*@END_MENU_TOKEN@*/,
                               endRadius: 50)
                    .frame(width: 200, height: 150, alignment: .center)
                    .offset(x: startOffset.x, y: startOffset.y)
                    .ignoresSafeArea()
                    .animation(Animation.spring()
                                .repeatForever()
                                .speed(.random(in: 0.05...0.9))
                                .delay(.random(in: 0...2))
                    )
                    
            }
        }
        
    }
}

struct MagicView_Previews: PreviewProvider {
    static var previews: some View {
        MagicView()
            .ignoresSafeArea()
            .frame(width: 90, height: 50, alignment: .center)
            .cornerRadius(15)
            .previewLayout(.sizeThatFits)
        
    }
}



extension Color {
    public func lighter(by amount: CGFloat = 0.2) -> Self { Self(UIColor(self).lighter(by: amount)) }
    public func darker(by amount: CGFloat = 0.2) -> Self { Self(UIColor(self).darker(by: amount)) }
}

extension UIColor {
    func mix(with color: UIColor, amount: CGFloat) -> Self {
        var red1: CGFloat = 0
        var green1: CGFloat = 0
        var blue1: CGFloat = 0
        var alpha1: CGFloat = 0
        
        var red2: CGFloat = 0
        var green2: CGFloat = 0
        var blue2: CGFloat = 0
        var alpha2: CGFloat = 0
        
        getRed(&red1, green: &green1, blue: &blue1, alpha: &alpha1)
        color.getRed(&red2, green: &green2, blue: &blue2, alpha: &alpha2)
        
        return Self(
            red: red1 * CGFloat(1.0 - amount) + red2 * amount,
            green: green1 * CGFloat(1.0 - amount) + green2 * amount,
            blue: blue1 * CGFloat(1.0 - amount) + blue2 * amount,
            alpha: alpha1
        )
    }
    
    func lighter(by amount: CGFloat = 0.2) -> Self { mix(with: .white, amount: amount) }
    func darker(by amount: CGFloat = 0.2) -> Self { mix(with: .black, amount: amount) }
}

protocol ParametricCurve {
    var totalArcLength: CGFloat { get }
    func point(t: CGFloat)->CGPoint
    func derivate(t: CGFloat)->CGVector
    func secondDerivate(t: CGFloat)->CGVector
    func arcLength(t: CGFloat)->CGFloat
    func curvature(t: CGFloat)->CGFloat
}

extension ParametricCurve {
    func arcLength(t: CGFloat)->CGFloat {
        var tmin: CGFloat = .zero
        var tmax: CGFloat = .zero
        if t < .zero {
            tmin = t
        } else {
            tmax = t
        }
        let quadrature = Quadrature(integrator: .qags(maxIntervals: 8), absoluteTolerance: 5.0e-2, relativeTolerance: 1.0e-3)
        let result = quadrature.integrate(over: Double(tmin) ... Double(tmax)) { _t in
            let dp = derivate(t: CGFloat(_t))
            let ds = Double(hypot(dp.dx, dp.dy)) //* x
            return ds
        }
        switch result {
        case .success((let arcLength, _/*, let e*/)):
            //print(arcLength, e)
            return t < .zero ? -CGFloat(arcLength) : CGFloat(arcLength)
        case .failure(let error):
            print("integration error:", error.errorDescription)
            return CGFloat.nan
        }
    }
    func curveParameter(arcLength: CGFloat)->CGFloat {
        let maxLength = totalArcLength == .zero ? self.arcLength(t: 1) : totalArcLength
        guard maxLength > 0 else { return 0 }
        var iteration = 0
        var guess: CGFloat = arcLength / maxLength

        let maxIterations = 10
        let maxErr: CGFloat = 0.1

        while (iteration < maxIterations) {
            let err = self.arcLength(t: guess) - arcLength
            if abs(err) < maxErr { break }
            let dp = derivate(t: guess)
            let m = hypot(dp.dx, dp.dy)
            guess -= err / m
            iteration += 1
        }

        return guess
    }
    func curvature(t: CGFloat)->CGFloat {
        /*
                    x'y" - y'x"
        κ(t)  = --------------------
                 (x'² + y'²)^(3/2)
         */
        let dp = derivate(t: t)
        let dp2 = secondDerivate(t: t)
        let dpSize = hypot(dp.dx, dp.dy)
        let denominator = dpSize * dpSize * dpSize
        let nominator = dp.dx * dp2.dy - dp.dy * dp2.dx

        return nominator / denominator
    }
}

struct Bezier3: ParametricCurve {

    let p0: CGPoint
    let p1: CGPoint
    let p2: CGPoint
    let p3: CGPoint

    let A: CGFloat
    let B: CGFloat
    let C: CGFloat
    let D: CGFloat
    let E: CGFloat
    let F: CGFloat
    let G: CGFloat
    let H: CGFloat


    
    
    public private(set) var totalArcLength: CGFloat = .zero

    init(from: CGPoint, to: CGPoint, control1: CGPoint, control2: CGPoint) {
        p0 = from
        p1 = control1
        p2 = control2
        p3 = to
        A = to.x - 3 * control2.x + 3 * control1.x - from.x
        B = 3 * control2.x - 6 * control1.x + 3 * from.x
        C = 3 * control1.x - 3 * from.x
        D = from.x
        E = to.y - 3 * control2.y + 3 * control1.y - from.y
        F = 3 * control2.y - 6 * control1.y + 3 * from.y
        G = 3 * control1.y - 3 * from.y
        H = from.y
        // mandatory !!!
        totalArcLength = arcLength(t: 1)
    }

    func point(t: CGFloat)->CGPoint {
        let x = A * t * t * t + B * t * t + C * t + D
        let y = E * t * t * t + F * t * t + G * t + H
        return CGPoint(x: x, y: y)
    }

    func derivate(t: CGFloat)->CGVector {
        let dx = 3 * A * t * t + 2 * B * t + C
        let dy = 3 * E * t * t + 2 * F * t + G
        return CGVector(dx: dx, dy: dy)
    }

    func secondDerivate(t: CGFloat)->CGVector {
        let dx = 6 * A * t + 2 * B
        let dy = 6 * E * t + 2 * F
        return CGVector(dx: dx, dy: dy)
    }

}

class AircraftModel: ObservableObject {
    let track: ParametricCurve
    let path: Path
    var aircraft: some View {
        let t = track.curveParameter(arcLength: alongTrackDistance)
        let p = track.point(t: t)
        let dp = track.derivate(t: t)
        let h = Angle(radians: atan2(Double(dp.dy), Double(dp.dx)))
        return Text("􀑓").font(.largeTitle).rotationEffect(h).position(p)
    }
    @Published var alongTrackDistance = CGFloat.zero
    init(from: CGPoint, to: CGPoint, control1: CGPoint, control2: CGPoint) {
        track = Bezier3(from: from, to: to, control1: control1, control2: control2)
        path = Path({ (path) in
            path.move(to: from)
            path.addCurve(to: to, control1: control1, control2: control2)
        })
    }
    
    @Published var flying = false
    var timer: Cancellable? = nil

    func fly() {
        flying = true
        timer = Timer
            .publish(every: 0.02, on: RunLoop.main, in: RunLoop.Mode.default)
            .autoconnect()
            .sink(receiveValue: { (_) in
                self.alongTrackDistance += self.track.totalArcLength / 200.0
                if self.alongTrackDistance > self.track.totalArcLength {
                    self.timer?.cancel()
                    self.flying = false
                }
            })
    }
}

struct ContentView: View {
    @ObservedObject var aircraft = AircraftModel(from: .init(x: 0, y: 0), to: .init(x: 500, y: 600), control1: .init(x: 600, y: 100), control2: .init(x: -300, y: 400))

    var body: some View {
        VStack {
            ZStack {
                aircraft.path.stroke(style: StrokeStyle( lineWidth: 0.5))
                aircraft.aircraft
            }
            Slider(value: $aircraft.alongTrackDistance, in: (0.0 ... aircraft.track.totalArcLength)) {
                Text("along track distance")
            }.padding()
            Button(action: {
                // fly (to be implemented :-))
            }) {
                Text("Fly!")
            }.padding()
        }
    }
}
