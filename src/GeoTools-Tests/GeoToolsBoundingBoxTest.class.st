"
A TGeoBoundingBoxTest is a test class for testing the behavior of TGeoBoundingBox
"
Class {
	#name : #GeoToolsBoundingBoxTest,
	#superclass : #TestCase,
	#instVars : [
		'boundingBox'
	],
	#category : #'GeoTools-Tests-Coordinates'
}

{ #category : #running }
GeoToolsBoundingBoxTest >> setUp [

	super setUp.

	boundingBox := GeoToolsBoundingBox new
]

{ #category : #running }
GeoToolsBoundingBoxTest >> setUpSmallBox [

	boundingBox
		topLatitudeInDegrees: 1;
		rightLongitudeInDegrees: 1;
		bottomLatitudeInDegrees: -1;
		leftLongitudeInDegrees: -1
]

{ #category : #running }
GeoToolsBoundingBoxTest >> setUpZeroBox [

	boundingBox
		topLatitudeInDegrees: 0;
		rightLongitudeInDegrees: 0;
		bottomLatitudeInDegrees: 0;
		leftLongitudeInDegrees: 0
]

{ #category : #tests }
GeoToolsBoundingBoxTest >> testBottomLatitudeInDegrees [

	self assert: boundingBox bottomLatitudeInDegrees isNil.
	
	boundingBox bottomLatitudeInDegrees: -1.
	self assert: boundingBox bottomLatitudeInDegrees equals: -1.
]

{ #category : #tests }
GeoToolsBoundingBoxTest >> testBottomLeftAbsoluteCoordinates [

	self assert: boundingBox bottomLeftAbsoluteCoordinates isValid not.
	
	self setUpZeroBox.
	self assert: boundingBox bottomLeftAbsoluteCoordinates isValid.
	
	self setUpSmallBox.
	self assert: boundingBox bottomLeftAbsoluteCoordinates isValid.
	
	boundingBox bottomLeftAbsoluteCoordinates: AbsoluteCoordinates zero.
	self assert: boundingBox bottomLeftAbsoluteCoordinates isValid.
	self assert: boundingBox bottomLeftAbsoluteCoordinates isZero.
]

{ #category : #tests }
GeoToolsBoundingBoxTest >> testBottomRightAbsoluteCoordinates [

	self assert: boundingBox bottomRightAbsoluteCoordinates isValid not.
	
	self setUpZeroBox.
	self assert: boundingBox bottomRightAbsoluteCoordinates isValid.
	
	self setUpSmallBox.
	self assert: boundingBox bottomRightAbsoluteCoordinates isValid.
	
	boundingBox bottomRightAbsoluteCoordinates: AbsoluteCoordinates zero.
	self assert: boundingBox bottomRightAbsoluteCoordinates isValid.
	self assert: boundingBox bottomRightAbsoluteCoordinates isZero.
]

{ #category : #tests }
GeoToolsBoundingBoxTest >> testLeftLongitudeInDegrees [

	self assert: boundingBox leftLongitudeInDegrees isNil.
	
	boundingBox leftLongitudeInDegrees: 1.
	self assert: boundingBox leftLongitudeInDegrees equals: 1.
]

{ #category : #tests }
GeoToolsBoundingBoxTest >> testMaxLatitudeInDegrees [

	self assert: boundingBox maxLatitudeInDegrees isNil.
	
	self setUpZeroBox.
	self assert: boundingBox maxLatitudeInDegrees equals: 0.
	
	self setUpSmallBox.
	self assert: boundingBox maxLatitudeInDegrees equals: 1.
]

{ #category : #tests }
GeoToolsBoundingBoxTest >> testMaxLongitudeInDegrees [

	self assert: boundingBox maxLongitudeInDegrees isNil.
	
	self setUpZeroBox.
	self assert: boundingBox maxLongitudeInDegrees equals: 0.
	
	self setUpSmallBox.
	self assert: boundingBox maxLongitudeInDegrees equals: 1.
]

{ #category : #tests }
GeoToolsBoundingBoxTest >> testMinLatitudeInDegrees [

	self assert: boundingBox minLatitudeInDegrees isNil.
	
	self setUpZeroBox.
	self assert: boundingBox minLatitudeInDegrees equals: 0.
	
	self setUpSmallBox.
	self assert: boundingBox minLatitudeInDegrees equals: -1.
]

{ #category : #tests }
GeoToolsBoundingBoxTest >> testMinLongitudeInDegrees [

	self assert: boundingBox minLongitudeInDegrees isNil.
	
	self setUpZeroBox.
	self assert: boundingBox minLongitudeInDegrees equals: 0.
	
	self setUpSmallBox.
	self assert: boundingBox minLongitudeInDegrees equals: -1.
]

{ #category : #tests }
GeoToolsBoundingBoxTest >> testRightLongitudeInDegrees [

	self assert: boundingBox rightLongitudeInDegrees isNil.
	
	boundingBox rightLongitudeInDegrees: 1.
	self assert: boundingBox rightLongitudeInDegrees equals: 1.
]

{ #category : #tests }
GeoToolsBoundingBoxTest >> testTopLatitudeInDegrees [

	self assert: boundingBox topLatitudeInDegrees isNil.
	
	boundingBox topLatitudeInDegrees: 1.
	self assert: boundingBox topLatitudeInDegrees equals: 1.
]

{ #category : #tests }
GeoToolsBoundingBoxTest >> testTopLeftAbsoluteCoordinates [

	self assert: boundingBox topLeftAbsoluteCoordinates isValid not.
	
	self setUpZeroBox.
	self assert: boundingBox topLeftAbsoluteCoordinates isValid.
	
	self setUpSmallBox.
	self assert: boundingBox topLeftAbsoluteCoordinates isValid.
	
	boundingBox topLeftAbsoluteCoordinates: AbsoluteCoordinates zero.
	self assert: boundingBox topLeftAbsoluteCoordinates isValid.
	self assert: boundingBox topLeftAbsoluteCoordinates isZero.
]

{ #category : #tests }
GeoToolsBoundingBoxTest >> testTopRightAbsoluteCoordinates [

	self assert: boundingBox topRightAbsoluteCoordinates isValid not.
	
	self setUpZeroBox.
	self assert: boundingBox topRightAbsoluteCoordinates isValid.
	
	self setUpSmallBox.
	self assert: boundingBox topRightAbsoluteCoordinates isValid.
	
	boundingBox topRightAbsoluteCoordinates: AbsoluteCoordinates zero.
	self assert: boundingBox topRightAbsoluteCoordinates isValid.
	self assert: boundingBox topRightAbsoluteCoordinates isZero.
]
