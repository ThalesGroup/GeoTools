Class {
	#name : #CoordinatesTest,
	#superclass : #TestCase,
	#category : #'GeoTools-Tests-Coordinates'
}

{ #category : #tests }
CoordinatesTest >> testCoordinatesPointConversion [
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
