//
//  ProviderLineChartView.swift
//  FransiSRentalHouseProject
//
//  Created by JerryHuang on 2/23/22.
//

import SwiftUI

import SwiftUI

struct ProviderLineChartView: View {
    var dataPoints: [Double] = [300, 2, 7, 16, 32, 39, 5, 3, 25, 21]
    var body: some View {
        ZStack {
            LineView(dataPoints: dataPoints)
            LineChartCircleView(dataPoints: dataPoints, radius: 3.0)
            LineChartCircleView(dataPoints: dataPoints, radius: 1.0)
        }
    }
}

struct LineView: View {
    var dataPoints: [Double] = []
    var heighestPoint: Double {
        let max = dataPoints.max() ?? 1.0
        if max == 0 {
            return 1.0
        }
        return max
    }

    private func ratio(for index: Int) -> Double {
        dataPoints[index] / heighestPoint
    }

    var body: some View {
        GeometryReader { geometry in
            let height = geometry.size.height
            let width = geometry.size.width

            Path { path in
                path.move(to: CGPoint(x: 0, y: height * ratio(for: 0)))

                for index in 1 ..< dataPoints.count {
                    path.addLine(to: CGPoint(
                        x: CGFloat(index) * width / CGFloat(dataPoints.count - 1),
                        y: height * self.ratio(for: index)
                    ))
                }
            }
            .stroke(Color.black, style: StrokeStyle(lineWidth: 2, lineJoin: .round))
        }
        .padding(.vertical)
    }
}

struct LineChartCircleView: View {
    var dataPoints: [Double] = []
    var radius: CGFloat

    var highestPoint: Double {
        let max = dataPoints.max() ?? 1.0
        if max == 0 {
            return 1.0
        }
        return max
    }

    private func ratio(for index: Int) -> Double {
        dataPoints[index] / highestPoint
    }

    var body: some View {
        GeometryReader { geometry in
            let height = geometry.size.height
            let width = geometry.size.width

            Path { path in
                path.move(to: CGPoint(x: 0, y: (height * self.ratio(for: 0)) - radius))
                path.addArc(center: CGPoint(x: 0, y: height * self.ratio(for: 0)),
                            radius: radius,
                            startAngle: .zero,
                            endAngle: .degrees(360.0), clockwise: false)
                for index in 1 ..< dataPoints.count {
                    path.move(to: CGPoint(x: CGFloat(index) * width / CGFloat(dataPoints.count - 1),
                                          y: height * dataPoints[index] / highestPoint))
                    path.addArc(center: CGPoint(
                        x: CGFloat(index) * width / CGFloat(dataPoints.count - 1),
                        y: height * self.ratio(for: index)
                    ),
                    radius: radius,
                    startAngle: .zero,
                    endAngle: .degrees(360.0), clockwise: false)
                }
            }
            .stroke(Color.black, lineWidth: 2)
        }
        .padding(.vertical)
    }
}

struct ProviderLineChartView_Previews: PreviewProvider {
    static var previews: some View {
        ProviderLineChartView()
    }
}
