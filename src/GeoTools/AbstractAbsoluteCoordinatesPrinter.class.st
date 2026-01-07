Class {
	#name : #AbstractAbsoluteCoordinatesPrinter,
	#superclass : #Object,
	#classInstVars : [
		'default'
	],
	#category : #'GeoTools-Coordinates'
}

{ #category : #cleanup }
AbstractAbsoluteCoordinatesPrinter class >> cleanUp [

	super cleanUp.
	default := nil
]

{ #category : #accessing }
AbstractAbsoluteCoordinatesPrinter class >> default [

	^ default ifNil: [ default := DMSAbsoluteCoordinatesPrinter new ]
]

{ #category : #testing }
AbstractAbsoluteCoordinatesPrinter class >> isAbstract [

	^ self == AbstractAbsoluteCoordinatesPrinter
]

{ #category : #printing }
AbstractAbsoluteCoordinatesPrinter >> printAbsoluteCoordinates: anAbsoluteCoordinates on: aStream [

	self subclassResponsibility
]

{ #category : #printing }
AbstractAbsoluteCoordinatesPrinter >> printAltitude: anAltitudeUnit on: aStream [

	self subclassResponsibility
]

{ #category : #printing }
AbstractAbsoluteCoordinatesPrinter >> printLatitude: aLatitudeUnit on: aStream [

	self subclassResponsibility
]

{ #category : #printing }
AbstractAbsoluteCoordinatesPrinter >> printLongitude: aLongitudeUnit on: aStream [

	self subclassResponsibility
]
