"
A GeodesicFormulasTest is a test class for testing the behavior of GeodesicFormulas
"
Class {
	#name : #GeodesicFormulasTest,
	#superclass : #TestCase,
	#instVars : [
		'geodesicFormulas'
	],
	#category : #'GeoTools-Tests-Geodesic'
}

{ #category : #testing }
GeodesicFormulasTest class >> isAbstract [ 

	^ self == GeodesicFormulasTest 
]

{ #category : #accessing }
GeodesicFormulasTest >> geodesicFormulasClass [

	self subclassResponsibility 
]

{ #category : #running }
GeodesicFormulasTest >> intializeGeodesicFormulas [

	geodesicFormulas := self geodesicFormulasClass new.
]

{ #category : #running }
GeodesicFormulasTest >> setUp [ 

	super setUp.
	self intializeGeodesicFormulas.
]

{ #category : #tests }
GeodesicFormulasTest >> testAbsoluteCoordinatesAlongGeodesicFromToAtFraction [

	| coordinates |
	coordinates := geodesicFormulas
		               absoluteCoordinatesAlongGeodesicFrom:
		               AbsoluteCoordinates zero
		               to: AbsoluteCoordinates zero
		               atFraction: 0.5.

	self assert: coordinates class identicalTo: AbsoluteCoordinates
]

{ #category : #tests }
GeodesicFormulasTest >> testAbsoluteCoordinatesFromDistanceInMetersAzimuthInRadians [

	| coordinates |
	coordinates := geodesicFormulas
		               absoluteCoordinatesFrom: AbsoluteCoordinates zero
		               distanceInMeters: 1000
		               azimuthInRadians: 0.
	
	self assert: coordinates class identicalTo: AbsoluteCoordinates
]

{ #category : #tests }
GeodesicFormulasTest >> testAzimuthInRadiansFromTo [

	| radians |
	radians := geodesicFormulas
		               azimuthInRadiansFrom: AbsoluteCoordinates zero
		               to: AbsoluteCoordinates zero.

	self assert: radians equals: 0
]

{ #category : #tests }
GeodesicFormulasTest >> testDistanceInMetersFromTo [

	| distance |
	distance := geodesicFormulas
		               distanceInMetersFrom: AbsoluteCoordinates zero
		               to: AbsoluteCoordinates zero.

	self assert: distance equals: 0
]
