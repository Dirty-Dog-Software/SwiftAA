//
//  Saturn.swift
//  SwiftAA
//
//  Created by Cédric Foellmi on 19/06/16.
//  Copyright © 2016 onekiloparsec. All rights reserved.
//

import Foundation

public struct Saturn: Planet, PlanetaryPhenomena, ElementsOfPlanetaryOrbit {
    public var planet: KPCAAPlanet { return .Saturn }
    
    public var julianDay: JulianDay
    public var highPrecision: Bool
    
    public init(julianDay: JulianDay, highPrecision: Bool = true) {
        self.julianDay = julianDay
        self.highPrecision = highPrecision
    }
    
    public static var color: Color {
        get { return Color(red: 0.941, green:0.827, blue:0.616, alpha: 1.0) }
    }
    
    func ringsDetails(highPrecision: Bool = true) -> KPCAASaturnRingDetails {
        return KPCAASaturnRings_Calculate(self.julianDay, highPrecision)
    }
    
    func moonsDetails(highPrecision: Bool = true) -> KPCAASaturnMoonsDetails {
        return KPCAASaturnMoonsDetails_Calculate(self.julianDay, highPrecision)
    }
}
