Class {
	#name : #GeodesicApproximativeFormulas,
	#superclass : #GeodesicFormulas,
	#category : #'GeoTools-Geodesic'
}

{ #category : #tools }
GeodesicApproximativeFormulas >> absoluteCoordinatesFrom: anAbsoluteCoordinates distanceInMeters: aDistanceInM azimuthInRadians: anAzimuthInRadians [

	^ self
		  absoluteCoordinatesFrom: anAbsoluteCoordinates
		  distanceInNM: aDistanceInM / 1000 / 1.852
		  azimuthInRadians: anAzimuthInRadians
]

{ #category : #private }
GeodesicApproximativeFormulas >> absoluteCoordinatesFrom: anAbsoluteCoordinates distanceInNM: aDistanceInNM azimuthInRadians: anAzimuthInRadians [ 
	"Formule de transformation tirée du livre de traité de navigation, c'est pourquoi elle fonctionne avec des NM"
	| absoluteCoordinates deltaLat latArr div deltaLong longArr |

	anAbsoluteCoordinates isValid ifFalse:[ ^ nil ].
	
	deltaLat := anAzimuthInRadians cos * aDistanceInNM / 60.0.
	latArr := anAbsoluteCoordinates latitudeInDegrees  + deltaLat.
	
	div := ((latArr + anAbsoluteCoordinates latitudeInDegrees) degreesToRadians / 2.0) cos.
	deltaLong := ((div = 0)
		ifFalse:[(anAzimuthInRadians sin / (div) abs * aDistanceInNM / 60.0)] 
		ifTrue:[0]).

	longArr := anAbsoluteCoordinates longitudeInDegrees + deltaLong.	
		
	absoluteCoordinates := AbsoluteCoordinates latitudeInDegrees: latArr longitudeInDegrees: longArr.
	(absoluteCoordinates longitudeInDegrees < -360 or:[absoluteCoordinates longitudeInDegrees > 360]) ifTrue:[^AbsoluteCoordinates zero].
	(absoluteCoordinates latitudeInDegrees < -360 or:[absoluteCoordinates latitudeInDegrees > 360]) ifTrue:[^AbsoluteCoordinates zero].

	^ absoluteCoordinates
]
