Class {
	#name : #CoordinatesTests,
	#superclass : #TestCase,
	#category : #'GeoTools-Tests'
}

{ #category : #tests }
CoordinatesTests >> testAbsoluteCoordinates [
	| coord |
	coord := AbsoluteCoordinates new.
	self assert: coord isEmpty equals: true.
	self assert: coord isValid equals: false.
	self assert: coord latitudeInDegrees isNil.
	self assert: coord latitude isNil.
	self assert: coord longitudeInDegrees isNil.
	self assert: coord longitude isNil.
	self assert: coord altitudeInMeters isNil.
	self assert: coord altitude isNil.
	
	coord latitudeInDegrees: 45.
	self assert: coord isEmpty equals: false.
	self assert: coord isValid equals: false.
	self assert: coord latitudeInDegrees equals: 45.
	self assert: coord latitudeInRadians equals: 0.7853981633974483.
	self assert: coord latitude equals: (45 units: #arcdegree).
	
	coord longitudeInDegrees: 90.
	self assert: coord isEmpty equals: false.
	self assert: coord isValid equals: true.
	self assert: coord longitudeInDegrees equals: 90.
	self assert: coord longitudeInRadians equals: 1.5707963267948966.
	self assert: coord longitude equals: (90 units: #arcdegree).
	
	coord altitudeInMeters: 100.
	self assert: coord isEmpty equals: false.
	self assert: coord isValid equals: true.
	self assert: coord altitudeInMeters equals: 100.
	self assert: coord altitude equals: (100 units: #meters).
]

{ #category : #tests }
CoordinatesTests >> testAbsoluteCoordinatesAsPoint [
	| coord |
	coord := AbsoluteCoordinates new.
	self assert: coord asPoint isNil.
	self assert: coord asLatLonRadiansPoint isNil.
	self assert: coord asLatLonDegreesPoint isNil.
	
	coord := AbsoluteCoordinates frBrest.
	self assert: coord asPoint equals: (48.3897@ -4.48333).
	self assert: coord asLatLonRadiansPoint equals: (0.8445595890523@ -0.07824886995343737).
	self assert: coord asLatLonDegreesPoint equals: (48.3897@ -4.48333).
]

{ #category : #tests }
CoordinatesTests >> testAbsoluteCoordinatesConstructor [
	| coord |
	coord := AbsoluteCoordinates latitudeInDegrees: 16 longitudeInDegrees: 8.
	self assert: coord latitudeInDegrees equals: 16.
	self assert: coord longitudeInDegrees equals: 8.
	self assert: coord altitudeInMeters equals: nil.
	
	coord := AbsoluteCoordinates latitudeInDegrees: 16 longitudeInDegrees: 8 altitudeInMeters: 0.
	self assert: coord latitudeInDegrees equals: 16.
	self assert: coord longitudeInDegrees equals: 8.
	self assert: coord altitudeInMeters equals: 0.
	
	coord := AbsoluteCoordinates latitudeInRadians: 0.5 longitudeInRadians: 0.75.
	self assert: coord latitudeInRadians equals: 0.5.
	self assert: coord longitudeInRadians equals: 0.75.
	self assert: coord altitudeInMeters equals: nil.
	
	coord := AbsoluteCoordinates latitudeInRadians: 0.5 longitudeInRadians: 0.75 altitudeInMeters: 0.
	self assert: coord latitudeInRadians equals: 0.5.
	self assert: coord longitudeInRadians equals: 0.75.
	self assert: coord altitudeInMeters equals: 0.
]

{ #category : #tests }
CoordinatesTests >> testAbsoluteCoordinatesCopy [
	| coord copy |
	coord := AbsoluteCoordinates new.
	copy := coord copy.
	self assert: copy ~~ coord.
	self assert: copy equals: coord.
	
	coord := AbsoluteCoordinates zero.
	copy := coord copy.
	self assert: copy ~~ coord.
	self assert: copy equals: coord.
]

{ #category : #tests }
CoordinatesTests >> testAbsoluteCoordinatesEnums [
	| coord |
	coord := AbsoluteCoordinates frBrest.
	self assert: (AbsoluteCoordinates latitudeInDegrees: 48.3897 longitudeInDegrees: -4.48333 altitudeInMeters: 52) equals: coord.
	
	coord := AbsoluteCoordinates frParis.
	self assert: (AbsoluteCoordinates latitudeInDegrees: 48.8667 longitudeInDegrees: 2.33333 altitudeInMeters: 79) equals: coord.
	
	coord := AbsoluteCoordinates frBordeaux.
	self assert: (AbsoluteCoordinates latitudeInDegrees: 44.8378 longitudeInDegrees: -0.594 altitudeInMeters: 22) equals: coord.
	
	coord := AbsoluteCoordinates frElancourt.
	self assert: (AbsoluteCoordinates latitudeInDegrees: 48.7839 longitudeInDegrees: 1.95806 altitudeInMeters: 138) equals: coord.
	
	coord := AbsoluteCoordinates frLyon.
	self assert: (AbsoluteCoordinates latitudeInDegrees: 45.7589 longitudeInDegrees: 4.84139 altitudeInMeters: 237) equals: coord.
	
	coord := AbsoluteCoordinates frMarseille.
	self assert: (AbsoluteCoordinates latitudeInDegrees: 43.2967 longitudeInDegrees: 5.37639 altitudeInMeters: 320) equals: coord.
	
	coord := AbsoluteCoordinates frNevers.
	self assert: (AbsoluteCoordinates latitudeInDegrees: 46.9925 longitudeInDegrees: 3.15667 altitudeInMeters: 203) equals: coord.
	
	coord := AbsoluteCoordinates ausSydney.
	self assert: (AbsoluteCoordinates latitudeInDegrees: -33.86785 longitudeInDegrees: 151.20732 altitudeInMeters: 58) equals: coord.
	
	coord := AbsoluteCoordinates usaNewYork.
	self assert: (AbsoluteCoordinates latitudeInDegrees: 40.71427 longitudeInDegrees: -74.00597 altitudeInMeters: 57) equals: coord.
	
	coord := AbsoluteCoordinates usaLosAngeles.
	self assert: (AbsoluteCoordinates latitudeInDegrees: 34.05223 longitudeInDegrees: -118.24368 altitudeInMeters: 96) equals: coord.
	
	coord := AbsoluteCoordinates usaSeattle.
	self assert: (AbsoluteCoordinates latitudeInDegrees: 47.60621 longitudeInDegrees: -122.33207 altitudeInMeters: 56) equals: coord.
]

{ #category : #tests }
CoordinatesTests >> testAbsoluteCoordinatesLimitations [
	| coord |
	coord := AbsoluteCoordinates latitudeInDegrees: 45 longitudeInDegrees: 90 altitudeInMeters: 100.
	
	coord latitudeInDegrees: 500.
	self assert: coord latitudeInDegrees equals: 90.
	self assert: coord longitudeInDegrees equals: 90.
	self assert: coord altitudeInMeters equals: 100.
	coord latitudeInDegrees: -500.
	self assert: coord latitudeInDegrees equals: -90.
	self assert: coord longitudeInDegrees equals: 90.
	self assert: coord altitudeInMeters equals: 100.
	
	coord longitudeInDegrees: 500.
	self assert: coord latitudeInDegrees equals: -90.
	self assert: coord longitudeInDegrees equals: 140.
	self assert: coord altitudeInMeters equals: 100.
	coord longitudeInDegrees: -500.
	self assert: coord latitudeInDegrees equals: -90.
	self assert: coord longitudeInDegrees equals: -140.
	self assert: coord altitudeInMeters equals: 100.
]

{ #category : #tests }
CoordinatesTests >> testAbsoluteCoordinatesPrintOn [
	| coord |
	coord := AbsoluteCoordinates new.
	self assert: coord printString equals: 'an AbsoluteCoordinates lat --° lon --° alt --m'.
	
	coord := AbsoluteCoordinates zero.
	self assert: coord printString equals: 'an AbsoluteCoordinates lat 0° lon 0° alt 0m'.
	
	coord := AbsoluteCoordinates frBrest.
	self assert: coord printString equals: 'an AbsoluteCoordinates lat 48.3897° lon -4.48333° alt 52m'.
]

{ #category : #tests }
CoordinatesTests >> testAbsoluteCoordinatesZero [
	| coord |
	coord := AbsoluteCoordinates zero.
	self assert: coord latitudeInDegrees equals: 0.
	self assert: coord longitudeInDegrees equals: 0.
	self assert: coord altitudeInMeters equals: 0.
]

{ #category : #tests }
CoordinatesTests >> testAbstractCoordinates [
	| coord |
	coord := AbstractCoordinates new.
	self assert: coord isEmpty equals: true.
	self assert: coord isValid equals: false.
	self assert: coord asPoint equals: nil.
]

{ #category : #tests }
CoordinatesTests >> testAbstractCoordinatesCopy [
	| coord copy |
	coord := AbstractCoordinates new.
	copy := coord copy.
	self assert: copy ~~ coord.
]

{ #category : #tests }
CoordinatesTests >> testCartesianCoordinates [
	| coord |
	coord := CartesianCoordinates new.
	self assert: coord isEmpty equals: true.
	self assert: coord isValid equals: false.
	self assert: coord xInMeters isNil.
	self assert: coord yInMeters isNil.
	self assert: coord zInMeters isNil.
	
	coord xInMeters: 45.
	self assert: coord isEmpty equals: false.
	self assert: coord isValid equals: false.
	self assert: coord xInMeters equals: 45.

	coord yInMeters: 90.
	self assert: coord isEmpty equals: false.
	self assert: coord isValid equals: true.
	self assert: coord yInMeters equals: 90.
	
	coord zInMeters: 100.
	self assert: coord isEmpty equals: false.
	self assert: coord isValid equals: true.
	self assert: coord zInMeters equals: 100.
]

{ #category : #tests }
CoordinatesTests >> testCartesianCoordinatesConstructor [
	| coord |
	coord := CartesianCoordinates xInMeters: 16 yInMeters: 8.
	self assert: coord xInMeters equals: 16.
	self assert: coord yInMeters equals: 8.
	self assert: coord zInMeters equals: nil.
	
	coord := CartesianCoordinates xInMeters: 16 yInMeters: 8 zInMeters: 0.
	self assert: coord xInMeters equals: 16.
	self assert: coord yInMeters equals: 8.
	self assert: coord zInMeters equals: 0.
]

{ #category : #tests }
CoordinatesTests >> testCartesianCoordinatesCopy [
	| coord copy |
	coord := CartesianCoordinates new.
	copy := coord copy.
	self assert: copy ~~ coord.
	self assert: copy equals: coord.
	
	coord := CartesianCoordinates zero.
	copy := coord copy.
	self assert: copy ~~ coord.
	self assert: copy equals: coord.
]

{ #category : #tests }
CoordinatesTests >> testCartesianCoordinatesPrintOn [
	| coord |
	coord := CartesianCoordinates new.
	self assert: coord printString equals: 'a CartesianCoordinates x --m y --m z --m'.
	
	coord := CartesianCoordinates zero.
	self assert: coord printString equals: 'a CartesianCoordinates x 0m y 0m z 0m'.
		
	coord := CartesianCoordinates xInMeters: 50 yInMeters: 3500 zInMeters: 52.
	self assert: coord printString equals: 'a CartesianCoordinates x 50m y 3500m z 52m'.
]

{ #category : #tests }
CoordinatesTests >> testCartesianCoordinatesZero [
	| coord |
	coord := CartesianCoordinates zero.
	self assert: coord xInMeters equals: 0.
	self assert: coord yInMeters equals: 0.
	self assert: coord zInMeters equals: 0.
]

{ #category : #tests }
CoordinatesTests >> testCoordinatesPointConversion [
	| coord |
	coord := (16@8) asAbsoluteCoordinates.
	self assert: (coord isKindOf: AbsoluteCoordinates).
	self assert: coord latitudeInDegrees equals: 16.
	self assert: coord longitudeInDegrees equals: 8.
	self assert: coord altitudeInMeters isNil.
	
	coord := (16@8) asCartesianCoordinates.
	self assert: (coord isKindOf: CartesianCoordinates).
	self assert: coord xInMeters equals: 16.
	self assert: coord yInMeters equals: 8.
	self assert: coord zInMeters isNil.
	
	coord := (16@8) asPolarCoordinates.
	self assert: (coord isKindOf: PolarCoordinates).
	self assert: coord azimuthInRadians equals: 16.
	self assert: coord distanceInMeters equals: 8.
	self assert: coord elevationInMeters isNil.
]

{ #category : #tests }
CoordinatesTests >> testPolarCoordinates [
	| coord |
	coord := PolarCoordinates new.
	self assert: coord isEmpty equals: true.
	self assert: coord isValid equals: false.
	self assert: coord azimuthInRadians isNil.
	self assert: coord distanceInMeters isNil.
	self assert: coord elevationInMeters isNil.
	
	coord azimuthInRadians: 45.
	self assert: coord isEmpty equals: false.
	self assert: coord isValid equals: false.
	self assert: coord azimuthInRadians equals: 45.

	coord distanceInMeters: 90.
	self assert: coord isEmpty equals: false.
	self assert: coord isValid equals: true.
	self assert: coord distanceInMeters equals: 90.
	self assert: coord elevationInMeters isNil.
	
	coord elevationInMeters: 100.
	self assert: coord isEmpty equals: false.
	self assert: coord isValid equals: true.
	self assert: coord elevationInMeters equals: 100.
]

{ #category : #tests }
CoordinatesTests >> testPolarCoordinatesPrintOn [
	| coord |
	coord := PolarCoordinates new.
	self assert: coord printString equals: 'a PolarCoordinates az --radians dist --m ele --m'.
	
	coord := PolarCoordinates zero.
	self assert: coord printString equals: 'a PolarCoordinates az 0radians dist 0m ele 0m'.
		
	coord := PolarCoordinates azimuthInRadians: 0.2 distanceInMeters: 100 elevationInMeters: 250.
	self assert: coord printString equals: 'a PolarCoordinates az 0.2radians dist 100m ele 250m'.
]

{ #category : #tests }
CoordinatesTests >> testPolarCoordinatesZero [
	| coord |
	coord := PolarCoordinates zero.
	self assert: coord azimuthInRadians equals: 0.
	self assert: coord distanceInMeters equals: 0.
	self assert: coord elevationInMeters equals: 0.
]
