"
A GeodesicVincentyFormulasTest is a test class for testing the behavior of GeodesicVincentyFormulas
"
Class {
	#name : #GeodesicVincentyFormulasTest,
	#superclass : #GeodesicFormulasTest,
	#category : #'GeoTools-Tests-Geodesic'
}

{ #category : #accessing }
GeodesicVincentyFormulasTest >> geodesicFormulasClass [

	^ GeodesicVincentyFormulas 
]

{ #category : #tests }
GeodesicVincentyFormulasTest >> testDistanceAtThresholdBoundary [
	"Test behavior exactly at the threshold boundary"
	
	| coord1 coord2 distance thresholdInMeters |
	
	"Calculate distance corresponding to 1e-4 radians"
	thresholdInMeters := 1e-4 * WGS84 semiMajorAxisInMeters. "~637 meters"
	
	coord1 := AbsoluteCoordinates latitudeInDegrees: 48.8566 longitudeInDegrees: 2.3522 altitudeInMeters: 0.
	coord2 := AbsoluteCoordinates latitudeInDegrees: (48.8566 + (1e-4 radiansToDegrees)) longitudeInDegrees: 2.3522 altitudeInMeters: 0.
	
	distance := geodesicFormulas distanceInMetersFrom: coord1 to: coord2.
	
	"Should be close to threshold distance"
	self assert: (distance between: (thresholdInMeters * 0.9) and: (thresholdInMeters * 1.1))
]

{ #category : #tests }
GeodesicVincentyFormulasTest >> testDistanceUsesHaversineForClosePoints [
	"Verify that Haversine is used for points closer than the threshold"
	
	| coord1 coord2 distance |
	
	"Two points separated by ~500 meters (less than 1e-4 radians threshold)"
	coord1 := AbsoluteCoordinates latitudeInDegrees: 48.8566 longitudeInDegrees: 2.3522 altitudeInMeters: 0. "Paris"
	coord2 := AbsoluteCoordinates latitudeInDegrees: 48.8610 longitudeInDegrees: 2.3522 altitudeInMeters: 0. "~500m north"
	
	distance := geodesicFormulas distanceInMetersFrom: coord1 to: coord2.
	
	"Should be around 490 meters"
	self assert: (distance between: 480 and: 500)
]

{ #category : #tests }
GeodesicVincentyFormulasTest >> testDistanceUsesVincentyForDistantPoints [
	"Verify that Vincenty is used for points farther than the threshold"
	
	| coord1 coord2 distance |
	
	"Two points separated by ~10 km (more than 1e-4 radians threshold)"
	coord1 := AbsoluteCoordinates latitudeInDegrees: 48.8566 longitudeInDegrees: 2.3522 altitudeInMeters: 0. "Paris"
	coord2 := AbsoluteCoordinates latitudeInDegrees: 48.9566 longitudeInDegrees: 2.3522 altitudeInMeters: 0. "~11 km north"
	
	distance := geodesicFormulas distanceInMetersFrom: coord1 to: coord2.
	
	"Should be around 11 km"
	self assert: (distance between: 11000 and: 11200).
]

{ #category : #tests }
GeodesicVincentyFormulasTest >> testIterationsLimit [

	self assert: geodesicFormulas iterationsLimit equals: GeodesicVincentyFormulas defaultIterationsLimit.
	self assert: geodesicFormulas iterationsLimit equals: 100.
	
	geodesicFormulas iterationsLimit: 1.
	self assert: geodesicFormulas iterationsLimit equals: 1.
	
	geodesicFormulas iterationsLimit: nil.
	self assert: geodesicFormulas iterationsLimit equals: GeodesicVincentyFormulas defaultIterationsLimit.
]

{ #category : #tests }
GeodesicVincentyFormulasTest >> testPrecision [

	self assert: geodesicFormulas precision equals: GeodesicVincentyFormulas defaultPrecision.
	self assert: geodesicFormulas precision equals: 1e-12.
	
	geodesicFormulas precision: 1.
	self assert: geodesicFormulas precision equals: 1.
	
	geodesicFormulas precision: nil.
	self assert: geodesicFormulas precision equals: GeodesicVincentyFormulas defaultPrecision.
]
