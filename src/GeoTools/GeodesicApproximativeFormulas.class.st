Class {
	#name : #GeodesicApproximativeFormulas,
	#superclass : #GeodesicFormulas,
	#category : #'GeoTools-Geodesic'
}

{ #category : #tools }
GeodesicApproximativeFormulas >> absoluteCoordinatesAlongGeodesicFrom: aFromAbsoluteCoordinate to: aToAbsoluteCoordinate atFraction: aFraction [

	| lat1 lon1 lat2 lon2 lat lon |
	lat1 := aFromAbsoluteCoordinate latitudeInDegrees.
	lon1 := aFromAbsoluteCoordinate longitudeInDegrees.
	lat2 := aToAbsoluteCoordinate latitudeInDegrees.
	lon2 := aToAbsoluteCoordinate longitudeInDegrees.

	lat := (lat1 + (lat2 - lat1)) * aFraction.
	lon := (lon1 + (lon2 - lon1)) * aFraction.

	^ AbsoluteCoordinates latitudeInDegrees: lat longitudeInDegrees: lon
]

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

{ #category : #tools }
GeodesicApproximativeFormulas >> azimuthInRadiansFrom: aFromAbsoluteCoordinate to: aToAbsoluteCoordinate [
    | lat1 lon1 lat2 lon2 dLon x y azimuth |

    lat1 := aFromAbsoluteCoordinate latitudeInRadians.
    lon1 := aFromAbsoluteCoordinate longitudeInRadians.
    lat2 := aToAbsoluteCoordinate latitudeInRadians.
    lon2 := aToAbsoluteCoordinate longitudeInRadians.

    dLon := lon2 - lon1.
    x := (dLon sin) * (lat2 cos).
    y := ((lat2 sin) * (lat1 cos)) - ((lat1 sin) * (lat2 cos) * (dLon cos)).

    azimuth := y arcTan2: x.

    azimuth < 0 ifTrue: [ azimuth := azimuth + (2 * Float pi) ].

    ^ azimuth
]

{ #category : #tools }
GeodesicApproximativeFormulas >> distanceInMetersFrom: aFromAbsoluteCoordinate to: anEndAbsoluteCoordinate [

	^ self haversineDistanceFrom: aFromAbsoluteCoordinate to: anEndAbsoluteCoordinate
]
