"
World Geodetic System 1984
References:
https://en.wikipedia.org/wiki/World_Geodetic_System#WGS84
https://fr.wikipedia.org/wiki/WGS_84


"
Class {
	#name : #WGS84,
	#superclass : #Object,
	#classInstVars : [
		'eccentricitySquared',
		'flattening',
		'poleCurveRadius'
	],
	#category : #'GeoTools-Geodesic'
}

{ #category : #cleanup }
WGS84 class >> cleanUp [
	"clean cached properties"

	flattening := nil.
	poleCurveRadius := nil
]

{ #category : #properties }
WGS84 class >> eccentricitySquared [
	"~0.0066943799901413165"

	^ self semiMajorAxisInMeters squared
	  - self semiMinorAxisInMeters squared
	  / self semiMajorAxisInMeters squared
]

{ #category : #properties }
WGS84 class >> flattening [

"	flattening ifNil: [ flattening := 1 / 298.257223563 ]."
	^ 1 / 298.257223563
]

{ #category : #properties }
WGS84 class >> poleCurveRadius [

	poleCurveRadius ifNil: [
		poleCurveRadius := self semiMajorAxisInMeters squared
		                   / self semiMinorAxisInMeters ].

	^ poleCurveRadius
]

{ #category : #properties }
WGS84 class >> secondEccentricitySquared [
	"~0.006739496742333464"

	^ self semiMajorAxisInMeters squared
	  - self semiMinorAxisInMeters squared
	  / self semiMinorAxisInMeters squared
]

{ #category : #properties }
WGS84 class >> semiMajorAxisInMeters [

	^ 6378137.0
]

{ #category : #properties }
WGS84 class >> semiMinorAxisInMeters [

	^ 6356752.314245
]

{ #category : #properties }
WGS84 class >> worldCircumferenceInMeters [

	^ 2 * Float pi * self semiMajorAxisInMeters 
]

{ #category : #'see class side' }
WGS84 >> seeClassSide [ 
]
