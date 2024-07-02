//
//  WeatherConditionView.swift
//  tracker
//
//  Created by Daniel Paymar on 6/26/24.
//

import SwiftUI

struct WeatherConditionView: View {
    @State private var temperature: String = ""
    @State private var weatherCondition: Image?
    
    var body: some View {
        VStack {
            Image(systemName: "sun.max").resizable().frame(width: 40, height: 40)
            Text("\(temperature)ºC")
        }
    }
}

#Preview {
    WeatherConditionView()
}
