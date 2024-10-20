Class {
	#name : #GeoToolsExtensionsTests,
	#superclass : #TestCase,
	#category : #'GeoTools-Tests'
}

{ #category : #'as yet unclassified' }
GeoToolsExtensionsTests >> testAsAzimuthAngle [

	self assert: 0 asAzimuthAngle equals: 90.
	self assert: 90 asAzimuthAngle equals: 0.
	self assert: 180 asAzimuthAngle equals: 270.
	self assert: 270 asAzimuthAngle equals: 180.
	self assert: 360 asAzimuthAngle equals: 90.
]

{ #category : #'as yet unclassified' }
GeoToolsExtensionsTests >> testAsTrigonometricAngle [

	self assert: 0 asTrigonometricAngle equals: 270.
	self assert: 90 asTrigonometricAngle equals: 0.
	self assert: 180 asTrigonometricAngle equals: 90.
	self assert: 270 asTrigonometricAngle equals: 180.
	self assert: 360 asTrigonometricAngle equals: 270.
]
