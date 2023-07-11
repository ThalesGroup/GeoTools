Extension { #name : #Point }

{ #category : #'*GeoTools' }
Point >> asAbsoluteCoordinates [

	^AbsoluteCoordinates latitudeInDegrees: self x longitudeInDegrees: self y
]

{ #category : #'*GeoTools' }
Point >> asCartesianCoordinates [

	^CartesianCoordinates xInMeters: self x yInMeters: self y
]

{ #category : #'*GeoTools' }
Point >> asPolarCoordinates [

	^PolarCoordinates azimuthInRadians: self x distanceInMeters: self y 
]
