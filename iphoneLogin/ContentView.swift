//
//  ContentView.swift
//  iphoneLogin
//
//  Created by Dixit Rathod on 26/07/24.
//

import SwiftUI

struct ContentView: View {
    @State private var isAnimating = true
    @State private var isRotating = false
    @State private var selectedIndex: Int = 1
    @Namespace var namespace
    @State private var count = 16
    
    let timer = Timer.publish(every: 2, on: .main, in: .common).autoconnect()

    var foreverAnimation: Animation {
        Animation.linear(duration: 12.0)
                .repeatForever(autoreverses: false)
        }
    
    var body: some View {
        let border = [
            "fourth_\(selectedIndex+1)",
            "third_\(selectedIndex+1)",
            "third_\(selectedIndex+2)",
            "second_\(selectedIndex+1)",
            "first_\(selectedIndex+1)",
            "second_\(selectedIndex)",
            "first_\(selectedIndex)",
            "second_\(selectedIndex-1)",
            "third_\(selectedIndex-1)",
            "third_\(selectedIndex)",
            "fourth_\(selectedIndex-1)",
        ]
        
        let sizes: [CGFloat] = [9,7,8,6,4,6,4,6,8,7,9]
        
        LinearGradient(colors: [Color.orange, Color.green], startPoint: .topLeading, endPoint: .bottomTrailing)
            .mask {
                ZStack {
                    RadialLayout {
                        ForEach(0..<25, id: \.self) { index in
                            if (isAnimating && !border.contains("first_\(index)")) || !isAnimating {
                                Circle()
                                    .fill(Color.red)
                                    .frame(width: 7, height: 7)
                                    .matchedGeometryEffect(id: "first_\(index)", in: namespace, properties: .position)
                            } else {
                                Circle()
                                    .fill(Color.clear)
                                    .frame(width: 5, height: 5)
                            }
                        }
                    }
                    .frame(width: 135)
                    
                    RadialLayout {
                        ForEach(0..<25, id: \.self) { index in
                            if (isAnimating && !border.contains("second_\(index)")) || !isAnimating {
                                Circle()
                                    .fill(Color.red)
                                    .frame(width: 9, height: 9)
                                    .matchedGeometryEffect(id: "second_\(index)", in: namespace, properties: .position)
                            } else {
                                Circle()
                                    .fill(Color.clear)
                                    .frame(width: 5, height: 5)
                            }
                        }
                    }
                    .rotationEffect(.degrees((360/25)/2))
                    .frame(width: 155)
                    
                    RadialLayout {
                        ForEach(0..<25, id: \.self) { index in
                            if (isAnimating && !border.contains("third_\(index)")) || !isAnimating {
                                Circle()
                                    .fill(Color.red)
                                    .frame(width: 10, height: 10)
                                    .matchedGeometryEffect(id: "third_\(index)", in: namespace, properties: .position)
                            } else {
                                Circle()
                                    .fill(Color.clear)
                                    .frame(width: 5, height: 5)
                            }
                        }
                    }
                    .frame(width: 175)
                    
                    let angle: Double = (360/25)
                    RadialLayout {
                        ForEach(0..<25, id: \.self) { index in
                            let circleSize: CGFloat = isAnimating && index == selectedIndex ? 4.5 : 1
                            
                            ZStack {
                                if (isAnimating && !border.contains("fourth_\(index)")) || !isAnimating {
                                    Circle()
                                        .fill(Color.red)
                                        .frame(width: 11, height: 11)
                                        .scaleEffect(circleSize, anchor: .center)
                                        .matchedGeometryEffect(id: "fourth_\(index)", in: namespace)
                                } else {
                                    Circle()
                                        .fill(Color.clear)
                                        .frame(width: 11, height: 11)
                                }
                                
                                
                                if (isAnimating && index == selectedIndex) {
                                    HalfRadialLayout {
                                        ForEach(Array(border.enumerated()), id: \.offset) { (index, border) in
                                            Circle().fill(Color.red)
                                                .frame(width: sizes[index], height: sizes[index])
                                                .matchedGeometryEffect(id: border, in: namespace, properties: .position)
                                        }
                                    }
                                    .rotationEffect(.degrees(angle * (Double(selectedIndex))), anchor: .center)
                                    .frame(width: 12 * 5.5, height: 12 * 5.5)
                                }
                            }
                        }
                    }
                    .rotationEffect(.degrees(angle/2))
                    .frame(width: 195)
                }
                
            }
            .overlay(content: {
                let angle: Double = (360/25)
                RadialLayout {
                    ForEach(0..<25, id: \.self) { index in
                        let circleSize: CGFloat = isAnimating && index == selectedIndex ? 4.5 : 1
                        let circleColor = isAnimating && index == selectedIndex ? Color(red: 244/255, green: 244/255, blue: 244/255) : Color.clear
                        let iconOpacity: CGFloat = isAnimating && index == selectedIndex ? 1 : 0
                        
                        ZStack {
                            if (isAnimating && !border.contains("fourth_\(index)")) {
                                Circle()
                                    .fill(circleColor)
                                    .frame(width: 11, height: 11)
                                    .overlay {
                                        Image(systemName: "apple.logo")
                                            .resizable()
                                            .scaledToFit()
                                            .padding(2)
                                            .opacity(iconOpacity)
                                    }
                                    .scaleEffect(circleSize, anchor: .center)
                                
                            } else {
                                Circle()
                                    .fill(Color.clear)
                                    .frame(width: 11, height: 11)
                            }
                        }
                        .rotationEffect(Angle(degrees: self.isRotating ? -360 : 0.0))
                        .animation(self.isRotating ? foreverAnimation : .default, value: isRotating)
                    }
                }
                .rotationEffect(.degrees(angle/2))
                .frame(width: 195)
            })
            .frame(width: 250, height: 250)
            .rotationEffect(Angle(degrees: self.isRotating ? 360 : 0.0))
            .animation(self.isRotating ? foreverAnimation : .default, value: isRotating)
            .overlay {
                Image(systemName: "apple.logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50)
            }
            .onAppear { self.isRotating = true }
            .onReceive(timer) { _ in
                withAnimation(.spring(.bouncy(duration: 0.5, extraBounce: 0.1))) {
                    if (selectedIndex + 2) < 24 {
                        selectedIndex += 2
                    } else {
                        selectedIndex = 2
                    }
                }
            }
        
    }
    
    func getCirclePosition(of rectSize: CGFloat, point: CGFloat) -> CGPoint? {
        return Circle().trim(from: 0, to: point).fill().shape.path(in: CGRect(origin: .zero, size: CGSize(width: rectSize, height: rectSize))).currentPoint
    }
}

#Preview {
    ContentView()
}


struct RadialLayout: Layout {
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        proposal.replacingUnspecifiedDimensions()
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        // calculate the radius of our bounds
        let radius = min(bounds.size.width, bounds.size.height) / 2
        
        // figure out the angle between each subview on our circle
        let angle = Angle.degrees(360 / Double(subviews.count)).radians
        
        for (index, subview) in subviews.enumerated() {
            // ask this view for its ideal size
//            let viewSize = subview.sizeThatFits(.unspecified)
            
            // calculate the X and Y position so this view lies inside our circle's edge
            let xPos = cos(angle * Double(index) - .pi / 2) * (radius)
            let yPos = sin(angle * Double(index) - .pi / 2) * (radius)
            
            // position this view relative to our centre, using its natural size ("unspecified")
            let point = CGPoint(x: bounds.midX + xPos, y: bounds.midY + yPos)
            subview.place(at: point, anchor: .center, proposal: .unspecified)
        }
    }
}

struct HalfRadialLayout: Layout {
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        proposal.replacingUnspecifiedDimensions()
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        // calculate the radius of our bounds
        let radius = min(bounds.size.width, bounds.size.height) / 2
        
        // figure out the angle between each subview on our circle
        let angle = Angle.degrees(225 / Double(subviews.count)).radians
        
        for (index, subview) in subviews.enumerated() {
            // ask this view for its ideal size
//            let viewSize = subview.sizeThatFits(.unspecified)
            
            // calculate the X and Y position so this view lies inside our circle's edge
            let xPos = cos(angle * Double(index) - Double.pi/10) * (radius)
            let yPos = sin(angle * Double(index) - Double.pi/10) * (radius)
            
            // position this view relative to our centre, using its natural size ("unspecified")
            let point = CGPoint(x: bounds.midX + xPos, y: bounds.midY + yPos)
            subview.place(at: point, anchor: .center, proposal: .unspecified)
        }
    }
}


