//
//  CelestialBodiesTests.swift
//  SwiftAA
//
//  Created by Cédric Foellmi on 24/02/2017.
//  Copyright © 2017 onekiloparsec. All rights reserved.
//

import XCTest
@testable import SwiftAA

class CelestialBodiesTests: XCTestCase {

    func testParalacticAngleBeforeMeridian() {
        // Taken from iObserve airmass plot...
        let jd = JulianDay(year: 2017, month: 6, day: 14, hour: 2, minute: 0, second: 0.0)

        // gro_j1655_40, see below
        let coords = EquatorialCoordinates(alpha: Hour(.plus, 16, 54, 00.14), delta: Degree(.minus, 39, 50, 44.9))        
        let gro_j1655_40 = AstronomicalObject(name: "GRO J1655-40", coordinates: coords, julianDay: jd)
        
        // http://www.ls.eso.org/lasilla/Telescopes/2p2/D1p5M/
        let la_silla_dfosc = GeographicCoordinates(positivelyWestwardLongitude: Degree(.plus, 70, 44, 7.662), latitude: Degree(.minus, 29, 15, 14.235))
        
        // See https://www.eso.org/sci/observing/tools/calendar/ParAng.html to check values.
        let refAngle = -77.6.degrees
        
        AssertEqual(gro_j1655_40.parallacticAngle(for: la_silla_dfosc), refAngle, accuracy: Degree(0.1))
    }

    func testParalacticAngleAfterMeridian() {
        // Taken from iObserve airmass plot...
        let jd = JulianDay(year: 2017, month: 6, day: 14, hour: 6, minute: 0, second: 0.0)
        
        // gro_j1655_40, see below
        let coords = EquatorialCoordinates(alpha: Hour(.plus, 16, 54, 00.14), delta: Degree(.minus, 39, 50, 44.9))
        let gro_j1655_40 = AstronomicalObject(name: "GRO J1655-40", coordinates: coords, julianDay: jd)
        
        // http://www.ls.eso.org/lasilla/Telescopes/2p2/D1p5M/
        let la_silla_dfosc = GeographicCoordinates(positivelyWestwardLongitude: Degree(.plus, 70, 44, 7.662), latitude: Degree(.minus, 29, 15, 14.235))
        
        // See https://www.eso.org/sci/observing/tools/calendar/ParAng.html to check values.
        let refAngle = 74.4.degrees
        
        AssertEqual(gro_j1655_40.parallacticAngle(for: la_silla_dfosc), refAngle, accuracy: Degree(0.1))
    }
    
    // See AA p.99, Example 14.a
    func testEclipticAndHorizon() {
        // jd is chosen to produce jd.apparentGreenwichSiderealTime = jd.meanLocalSiderealTime(longitude=0) = 5.0h (75º) as in Example 14.a
        let jd = JulianDay(year: 2017, month: 9, day: 21, hour: 4, minute: 58, second: 56.3824345393)
        let geoCoords = GeographicCoordinates(positivelyWestwardLongitude: 0, latitude: Degree(51.0)) // longitude must be consistent with above.
        
        // Valid whatever the CelestialBody
        let moon = Moon(julianDay: jd)
        AssertEqual(moon.eclipticLongitudeOnHorizon(for: geoCoords), Degree(.plus, 349, 21, 0), accuracy: ArcMinute(1).inDegrees)
        AssertEqual(moon.angleBetweenEclipticAndHorizon(for: geoCoords), Degree(62.0), accuracy: Degree(1))
    }
    
    func testAngleBetweenNorthCelestialPoleAndNorthPoleOfEcliptic() {
        // gro_j1655_40, see below
        let starCoords = EquatorialCoordinates(alpha: Hour(.plus, 16, 54, 00.14), delta: Degree(.minus, 39, 50, 44.9))
        
        // AstronomicalObject is also a CelestialBody
        let gro_j1655_40 = AstronomicalObject(name: "GRO J1655-40", coordinates: starCoords, julianDay: JulianDay(Date())) // Date has no effect.
        
        let geoCoords = GeographicCoordinates(positivelyWestwardLongitude: 122.0, latitude: 51.0)
        AssertEqual(gro_j1655_40.angleBetweenNorthCelestialPoleAndNorthPoleOfEcliptic(for: geoCoords), Degree(186.0), accuracy: Degree(1))
    }
    
    func testDiurnalArcsExtremes() {
        // one of the northernmost towns in the world (norway)
        let hammerfest = GeographicCoordinates(positivelyWestwardLongitude: Degree(.minus, 23, 40, 55), latitude: Degree(.plus, 70, 39, 48))

        // northern winter
        let winterSun = Sun(julianDay: JulianDay(year: 2017, month: 1, day: 1))
        let winterArc = winterSun.diurnalArcAngle(for: 0.0, geographicCoordinates: hammerfest) // altitude could be anything > 0
        XCTAssertNil(winterArc.value)
        XCTAssertEqual(winterArc.error, .alwaysBelowAltitude)
        
        // northern summer
        let summerSun = Sun(julianDay: JulianDay(year: 2017, month: 7, day: 1))
        let summerArc = summerSun.diurnalArcAngle(for: 0.0, geographicCoordinates: hammerfest)
        XCTAssertNil(summerArc.value)
        XCTAssertEqual(summerArc.error, .alwaysAboveAltitude)
    }
}
