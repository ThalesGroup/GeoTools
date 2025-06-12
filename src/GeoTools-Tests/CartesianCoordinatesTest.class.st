"
A CartesianCoordinatesTest is a test class for testing the behavior of CartesianCoordinates
"
Class {
	#name : #CartesianCoordinatesTest,
	#superclass : #TestCase,
	#category : #'GeoTools-Tests-Coordinates'
}

{ #category : #tests }
CartesianCoordinatesTest >> testCartesianCoordinates [
	| coord |
	coord := CartesianCoordinates new.
	self assert: coord isEmpty equals: true.
	self assert: coord isValid equals: false.
	self assert: coord xInMeters isNil.
	self assert: coord yInMeters isNil.
	self assert: coord zInMeters isNil.
	
	coord xInMeters: 45.
	self assert: coord isEmpty equals: false.
	self assert: coord isValid equals: false.
	self assert: coord xInMeters equals: 45.

	coord yInMeters: 90.
	self assert: coord isEmpty equals: false.
	self assert: coord isValid equals: true.
	self assert: coord yInMeters equals: 90.
	
	coord zInMeters: 100.
	self assert: coord isEmpty equals: false.
	self assert: coord isValid equals: true.
	self assert: coord zInMeters equals: 100.
]

{ #category : #tests }
CartesianCoordinatesTest >> testCartesianCoordinatesConstructor [
	| coord |
	coord := CartesianCoordinates xInMeters: 16 yInMeters: 8.
	self assert: coord xInMeters equals: 16.
	self assert: coord yInMeters equals: 8.
	self assert: coord zInMeters equals: nil.
	
	coord := CartesianCoordinates xInMeters: 16 yInMeters: 8 zInMeters: 0.
	self assert: coord xInMeters equals: 16.
	self assert: coord yInMeters equals: 8.
	self assert: coord zInMeters equals: 0.
]

{ #category : #tests }
CartesianCoordinatesTest >> testCartesianCoordinatesCopy [
	| coord copy |
	coord := CartesianCoordinates new.
	copy := coord copy.
	self assert: copy ~~ coord.
	self assert: copy equals: coord.
	
	coord := CartesianCoordinates zero.
	copy := coord copy.
	self assert: copy ~~ coord.
	self assert: copy equals: coord.
]

{ #category : #tests }
CartesianCoordinatesTest >> testCartesianCoordinatesPrintOn [
	| coord |
	coord := CartesianCoordinates new.
	self assert: coord printString equals: 'a CartesianCoordinates x --m y --m z --m'.
	
	coord := CartesianCoordinates zero.
	self assert: coord printString equals: 'a CartesianCoordinates x 0m y 0m z 0m'.
		
	coord := CartesianCoordinates xInMeters: 50 yInMeters: 3500 zInMeters: 52.
	self assert: coord printString equals: 'a CartesianCoordinates x 50m y 3500m z 52m'.
]

{ #category : #tests }
CartesianCoordinatesTest >> testCartesianCoordinatesZero [
	| coord |
	coord := CartesianCoordinates zero.
	self assert: coord xInMeters equals: 0.
	self assert: coord yInMeters equals: 0.
	self assert: coord zInMeters equals: 0.
]
