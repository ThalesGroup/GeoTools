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

{ #category : #constructor }
TGeoToolsBoundingBox classSide >> origin: aFromAbsolutePosition corner: aToAbsolutePostion [

	^ self topLeft: aFromAbsolutePosition bottomRight: aToAbsolutePostion
]

{ #category : #constructor }
TGeoToolsBoundingBox classSide >> topLeft: aFromAbsolutePosition bottomRight: aToAbsolutePostion [

	| box |
	box := self new.
	box topLeftAbsoluteCoordinates: aFromAbsolutePosition.
	box bottomRightAbsoluteCoordinates: aToAbsolutePostion.
	^ box
]

{ #category : #accessing }
TGeoToolsBoundingBox >> bottomLatitudeInDegrees [

	^ bottomLatitudeInDegrees
]

{ #category : #accessing }
TGeoToolsBoundingBox >> bottomLatitudeInDegrees: anObject [

	bottomLatitudeInDegrees := anObject
]

{ #category : #points }
TGeoToolsBoundingBox >> bottomLeftAbsoluteCoordinates [

	^ AbsoluteCoordinates
		  latitudeInDegrees: self bottomLatitudeInDegrees
		  longitudeInDegrees: self leftLongitudeInDegrees
]

{ #category : #points }
TGeoToolsBoundingBox >> bottomLeftAbsoluteCoordinates: anAbsoluteCoordinates [

	self bottomLatitudeInDegrees: anAbsoluteCoordinates latitudeInDegrees.
	self leftLongitudeInDegrees: anAbsoluteCoordinates longitudeInDegrees
]

{ #category : #points }
TGeoToolsBoundingBox >> bottomRightAbsoluteCoordinates [ 

	^ AbsoluteCoordinates
		  latitudeInDegrees: self bottomLatitudeInDegrees
		  longitudeInDegrees: self rightLongitudeInDegrees
]

{ #category : #points }
TGeoToolsBoundingBox >> bottomRightAbsoluteCoordinates: anAbsoluteCoordinates [

	self bottomLatitudeInDegrees: anAbsoluteCoordinates latitudeInDegrees.
	self rightLongitudeInDegrees: anAbsoluteCoordinates longitudeInDegrees
]

{ #category : #points }
TGeoToolsBoundingBox >> centerAbsoluteCoordinates [

	| latitude longitude |
	latitude := (self topLatitudeInDegrees isNil or: [
		             self bottomLatitudeInDegrees isNil ])
		            ifTrue: [ nil ]
		            ifFalse: [
		            self topLatitudeInDegrees
		             + self bottomLatitudeInDegrees / 2 ].

	longitude := (self leftLongitudeInDegrees isNil or: [
		              self rightLongitudeInDegrees isNil ])
		             ifTrue: [ nil ]
		             ifFalse: [
			             self leftLongitudeInDegrees
			              + self rightLongitudeInDegrees / 2 ].

	^ AbsoluteCoordinates
		  latitudeInDegrees: latitude
		  longitudeInDegrees: longitude
]

{ #category : #testing }
TGeoToolsBoundingBox >> isValid [

	^ (self topLeftAbsoluteCoordinates notNil and: [
		   self topLeftAbsoluteCoordinates isValid ]) and: [
			  self bottomRightAbsoluteCoordinates notNil and: [
				  self bottomRightAbsoluteCoordinates isValid ] ]
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

{ #category : #points }
TGeoToolsBoundingBox >> topLeftAbsoluteCoordinates [ 

	^ AbsoluteCoordinates
		  latitudeInDegrees: self topLatitudeInDegrees
		  longitudeInDegrees: self leftLongitudeInDegrees
]

{ #category : #points }
TGeoToolsBoundingBox >> topLeftAbsoluteCoordinates: anAbsoluteCoordinates [

	self topLatitudeInDegrees: anAbsoluteCoordinates latitudeInDegrees.
	self leftLongitudeInDegrees: anAbsoluteCoordinates longitudeInDegrees
]

{ #category : #points }
TGeoToolsBoundingBox >> topRightAbsoluteCoordinates [ 

	^ AbsoluteCoordinates
		  latitudeInDegrees: self topLatitudeInDegrees
		  longitudeInDegrees: self rightLongitudeInDegrees
]

{ #category : #points }
TGeoToolsBoundingBox >> topRightAbsoluteCoordinates: anAbsoluteCoordinates [

	self topLatitudeInDegrees: anAbsoluteCoordinates latitudeInDegrees.
	self rightLongitudeInDegrees: anAbsoluteCoordinates longitudeInDegrees
]
