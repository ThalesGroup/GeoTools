"
A WGS84Test is a test class for testing the behavior of WGS84
"
Class {
	#name : #WGS84Test,
	#superclass : #TestCase,
	#category : #'GeoTools-Tests-Geodesic'
}

{ #category : #running }
WGS84Test >> tearDown [

	WGS84 cleanUp.
	super tearDown
]

{ #category : #running }
WGS84Test >> testEccentricitySquared [

	self assert: WGS84 eccentricitySquared notNil
]

{ #category : #running }
WGS84Test >> testFlattening [

	self assert: WGS84 flattening notNil
]

{ #category : #running }
WGS84Test >> testPoleCurveRadius [

	self assert: WGS84 poleCurveRadius notNil
]

{ #category : #running }
WGS84Test >> testSemiMajorAxisInMeters [

	self assert: WGS84 semiMajorAxisInMeters notNil
]

{ #category : #running }
WGS84Test >> testSemiMinorAxisInMeters [

	self assert: WGS84 semiMinorAxisInMeters notNil
]
