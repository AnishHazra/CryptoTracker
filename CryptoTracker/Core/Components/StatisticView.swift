//
//  StatisticView.swift
//  CryptoTracker
//
//  Created by Anish Hazra on 19/06/25.
//

import SwiftUI

struct StatisticView: View {

    let stat: StatisticModel

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(stat.title)
                .font(.caption)
                .foregroundColor(Color.theme.secondaryText)
            Text(stat.value)
                .font(.headline)
                .foregroundColor(Color.theme.accent)
            HStack {
                Image(systemName: "triangle.fill")
                    .font(.caption2)
                    .rotationEffect(
                        Angle(degrees: (stat.percentageChange ?? 0) >= 0 ? 0 : 180)
                    )

                Text((stat.percentageChange?.asNumberString() ?? "") + "%")
                    .font(.caption)
                    .bold()
            }
            .foregroundColor(
                (stat.percentageChange ?? 0) >= 0
                ? Color.theme.green
                :Color.theme.red)
            .opacity(stat.percentageChange == nil ? 0.0 : 1.0)
        }
    }
}

struct StatisticView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            StatisticView(stat: dev.state1)
            StatisticView(stat: dev.state2)
            StatisticView(stat: dev.state3)
        }
    }
}
