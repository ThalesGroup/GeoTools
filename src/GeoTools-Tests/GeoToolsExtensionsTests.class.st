Class {
	#name : #GeoToolsExtensionsTests,
	#superclass : #TestCase,
	#category : #'GeoTools-Tests-Extensions'
}

{ #category : #tests }
GeoToolsExtensionsTests >> testAsAzimuthAngle [

	self assert: 0 asAzimuthAngle equals: 90.
	self assert: 90 asAzimuthAngle equals: 0.
	self assert: 180 asAzimuthAngle equals: 270.
	self assert: 270 asAzimuthAngle equals: 180.
	self assert: 360 asAzimuthAngle equals: 90.
]

{ #category : #tests }
GeoToolsExtensionsTests >> testAsTrigonometricAngle [

	self assert: 0 asTrigonometricAngle equals: 270.
	self assert: 90 asTrigonometricAngle equals: 0.
	self assert: 180 asTrigonometricAngle equals: 90.
	self assert: 270 asTrigonometricAngle equals: 180.
	self assert: 360 asTrigonometricAngle equals: 270.
]

{ #category : #tests }
GeoToolsExtensionsTests >> testIsAngleInRadiansBetweenAnd [

	| result |
	result := 0 isAngleInRadiansBetween: 355 degreesToRadians and: 5 degreesToRadians.
	self assert: result equals: true.
	result := 14 degreesToRadians isAngleInRadiansBetween: 340 degreesToRadians and: 15 degreesToRadians.
	self assert: result equals: true.
	result := 341 degreesToRadians isAngleInRadiansBetween: 340 degreesToRadians and: 15 degreesToRadians.
	self assert: result equals: true.
	result := 15 degreesToRadians isAngleInRadiansBetween: 340 degreesToRadians and: 15 degreesToRadians.
	self assert: result equals: true.
	result := 340 degreesToRadians isAngleInRadiansBetween: 340 degreesToRadians and: 15 degreesToRadians.
	self assert: result equals: true.
	result := 16 degreesToRadians isAngleInRadiansBetween: 340 degreesToRadians and: 15 degreesToRadians.
	self assert: result equals: false.
	
	result := 55 degreesToRadians isAngleInRadiansBetween: 15 degreesToRadians and: 91 degreesToRadians.
	self assert: result equals: true.
	result := 155 degreesToRadians isAngleInRadiansBetween: 15 degreesToRadians and: 91 degreesToRadians.
	self assert: result equals: false.
	result := 155 degreesToRadians isAngleInRadiansBetween: 91 degreesToRadians and: 180 degreesToRadians.
	self assert: result equals: true.
	
	result := 180 degreesToRadians isAngleInRadiansBetween: 175 degreesToRadians and: 180 degreesToRadians.
	self assert: result equals: true.
	result := -40 degreesToRadians isAngleInRadiansBetween: 225 degreesToRadians and: 321 degreesToRadians.
	self assert: result equals: true.
	result := 345 degreesToRadians isAngleInRadiansBetween: 215 degreesToRadians and: 321 degreesToRadians.
	self assert: result equals: false.
	
	result := -45 degreesToRadians isAngleInRadiansBetween: 26.21 degreesToRadians and: 89.969 degreesToRadians.
	self assert: result equals: false.
]
