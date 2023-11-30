"
I am an Abstract Coordinates
"
Class {
	#name : #AbstractCoordinates,
	#superclass : #Object,
	#category : #'GeoTools-Coordinates'
}

{ #category : #'instance creation' }
AbstractCoordinates class >> zero [ 
	self subclassResponsibility 
]

{ #category : #testing }
AbstractCoordinates >> asPoint [
	^nil
]

{ #category : #copying }
AbstractCoordinates >> copy [
	| copy |
	copy := self class new.
	^copy
]

{ #category : #testing }
AbstractCoordinates >> isEmpty [ 
	^true
]

{ #category : #testing }
AbstractCoordinates >> isValid [ 
	^false
]
