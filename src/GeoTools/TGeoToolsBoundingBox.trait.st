Trait {
	#name : #TGeoToolsBoundingBox,
	#instVars : [
		'topLatitudeInDegrees',
		'rightLongitudeInDegrees',
		'bottomLatitudeInDegrees',
		'leftLongitudeInDegrees'
	],
	#category : #'GeoTools-Coordinates'
}

{ #category : #accessing }
TGeoToolsBoundingBox >> bottomLatitudeInDegrees [

	^ bottomLatitudeInDegrees
]

{ #category : #accessing }
TGeoToolsBoundingBox >> bottomLatitudeInDegrees: anObject [

	bottomLatitudeInDegrees := anObject
]

{ #category : #corners }
TGeoToolsBoundingBox >> bottomLeftAbsoluteCoordinates [

	^ AbsoluteCoordinates
		  latitudeInDegrees: self bottomLatitudeInDegrees
		  longitudeInDegrees: self leftLongitudeInDegrees
]

{ #category : #corners }
TGeoToolsBoundingBox >> bottomLeftAbsoluteCoordinates: anAbsoluteCoordinates [

	self bottomLatitudeInDegrees: anAbsoluteCoordinates latitudeInDegrees.
	self leftLongitudeInDegrees: anAbsoluteCoordinates longitudeInDegrees
]

{ #category : #corners }
TGeoToolsBoundingBox >> bottomRightAbsoluteCoordinates [ 

	^ AbsoluteCoordinates
		  latitudeInDegrees: self bottomLatitudeInDegrees
		  longitudeInDegrees: self rightLongitudeInDegrees
]

{ #category : #corners }
TGeoToolsBoundingBox >> bottomRightAbsoluteCoordinates: anAbsoluteCoordinates [

	self bottomLatitudeInDegrees: anAbsoluteCoordinates latitudeInDegrees.
	self rightLongitudeInDegrees: anAbsoluteCoordinates longitudeInDegrees
]

{ #category : #accessing }
TGeoToolsBoundingBox >> leftLongitudeInDegrees [

	^ leftLongitudeInDegrees
]

{ #category : #accessing }
TGeoToolsBoundingBox >> leftLongitudeInDegrees: anObject [

	leftLongitudeInDegrees := anObject
]

{ #category : #'limits ' }
TGeoToolsBoundingBox >> maxLatitudeInDegrees [

	^ self topLatitudeInDegrees 
]

{ #category : #'limits ' }
TGeoToolsBoundingBox >> maxLongitudeInDegrees [

	^ self rightLongitudeInDegrees 
]

{ #category : #'limits ' }
TGeoToolsBoundingBox >> minLatitudeInDegrees [

	^ self bottomLatitudeInDegrees 
]

{ #category : #'limits ' }
TGeoToolsBoundingBox >> minLongitudeInDegrees [

	^ self leftLongitudeInDegrees 
]

{ #category : #accessing }
TGeoToolsBoundingBox >> rightLongitudeInDegrees [

	^ rightLongitudeInDegrees
]

{ #category : #accessing }
TGeoToolsBoundingBox >> rightLongitudeInDegrees: anObject [

	rightLongitudeInDegrees := anObject
]

{ #category : #accessing }
TGeoToolsBoundingBox >> topLatitudeInDegrees [

	^ topLatitudeInDegrees
]

{ #category : #accessing }
TGeoToolsBoundingBox >> topLatitudeInDegrees: anObject [

	topLatitudeInDegrees := anObject
]

{ #category : #corners }
TGeoToolsBoundingBox >> topLeftAbsoluteCoordinates [ 

	^ AbsoluteCoordinates
		  latitudeInDegrees: self topLatitudeInDegrees
		  longitudeInDegrees: self leftLongitudeInDegrees
]

{ #category : #corners }
TGeoToolsBoundingBox >> topLeftAbsoluteCoordinates: anAbsoluteCoordinates [

	self topLatitudeInDegrees: anAbsoluteCoordinates latitudeInDegrees.
	self leftLongitudeInDegrees: anAbsoluteCoordinates longitudeInDegrees
]

{ #category : #corners }
TGeoToolsBoundingBox >> topRightAbsoluteCoordinates [ 

	^ AbsoluteCoordinates
		  latitudeInDegrees: self topLatitudeInDegrees
		  longitudeInDegrees: self rightLongitudeInDegrees
]

{ #category : #corners }
TGeoToolsBoundingBox >> topRightAbsoluteCoordinates: anAbsoluteCoordinates [

	self topLatitudeInDegrees: anAbsoluteCoordinates latitudeInDegrees.
	self rightLongitudeInDegrees: anAbsoluteCoordinates longitudeInDegrees
]
