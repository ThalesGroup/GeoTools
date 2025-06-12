"
A PolarCoordinatesTest is a test class for testing the behavior of PolarCoordinates
"
Class {
	#name : #PolarCoordinatesTest,
	#superclass : #TestCase,
	#category : #'GeoTools-Tests-Coordinates'
}

{ #category : #tests }
PolarCoordinatesTest >> testPolarCoordinates [
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
PolarCoordinatesTest >> testPolarCoordinatesPrintOn [
	| coord |
	coord := PolarCoordinates new.
	self assert: coord printString equals: 'a PolarCoordinates az --radians dist --m ele --m'.
	
	coord := PolarCoordinates zero.
	self assert: coord printString equals: 'a PolarCoordinates az 0radians dist 0m ele 0m'.
		
	coord := PolarCoordinates azimuthInRadians: 0.2 distanceInMeters: 100 elevationInMeters: 250.
	self assert: coord printString equals: 'a PolarCoordinates az 0.2radians dist 100m ele 250m'.
]

{ #category : #tests }
PolarCoordinatesTest >> testPolarCoordinatesZero [
	| coord |
	coord := PolarCoordinates zero.
	self assert: coord azimuthInRadians equals: 0.
	self assert: coord distanceInMeters equals: 0.
	self assert: coord elevationInMeters equals: 0.
]
