Class {
	#name : #KinematicsTests,
	#superclass : #TestCase,
	#instVars : [
		'kinematics'
	],
	#category : #'GeoTools-Tests-Kinematics'
}

{ #category : #running }
KinematicsTests >> setUp [

	super setUp.

	kinematics := Kinematics new
]

{ #category : #tests }
KinematicsTests >> testCopy [
	| copy |

	kinematics headingInRadians: 10.
	kinematics courseInRadians: 89.
	kinematics groundSpeedInMetersPerSecond: 50.
	copy := kinematics copy.
	
	self assert: copy equals: kinematics.
	self assert: copy ~~ kinematics.
	
	self assert: copy heading equals: 10 radian.
	self assert: copy heading equals: kinematics heading.
	self assert: copy heading ~~ kinematics heading.
	
	self assert: copy course equals: 89 radian.
	self assert: copy course equals: kinematics course.
	self assert: copy course ~~ kinematics course.
	
	self assert: copy groundSpeed equals: (50 units: (Unit metre / Unit second)).
	self assert: copy groundSpeed equals: kinematics groundSpeed.
	self assert: copy groundSpeed ~~ kinematics groundSpeed.
]

{ #category : #tests }
KinematicsTests >> testCourse [
		
	kinematics courseInDegrees: 0.
	self assert: kinematics courseInDegrees equals: 0.
	self assert: kinematics courseInRadians equals: 0.

	kinematics courseInDegrees: 45.
	self assert: kinematics courseInDegrees equals: 45.
	self assert: kinematics courseInRadians equals: 0.7853981633974483.
	
	kinematics courseInRadians: 0.
	self assert: kinematics courseInDegrees equals: 0.
	self assert: kinematics courseInRadians equals: 0.
	
	kinematics courseInRadians: 0.5.
	self assert: kinematics courseInDegrees equals: 28.64788975654116.
	self assert: kinematics courseInRadians equals: 0.5.
]

{ #category : #tests }
KinematicsTests >> testCreate [

	self assert: kinematics course isNil.
	self assert: kinematics groundSpeed isNil.
	self assert: kinematics heading isNil.
]

{ #category : #tests }
KinematicsTests >> testEdit [

	kinematics headingInRadians: 10.
	kinematics courseInRadians: 89.
	kinematics groundSpeedInMetersPerSecond: 50.
	
	self assert: kinematics heading equals: 10 radian.
	self assert: (kinematics heading isKindOf: UnitValue).
	self assert: kinematics headingInRadians equals: 10.
	self assert: kinematics course equals: 89 radian.
	self assert: (kinematics course isKindOf: UnitValue).
	self assert: kinematics courseInRadians equals: 89.
	self assert: kinematics groundSpeed equals: (50 units: (Unit metre / Unit second)).
	self assert: (kinematics groundSpeed isKindOf: UnitValue).
	self assert: kinematics groundSpeedInMetersPerSecond equals: 50.
]

{ #category : #tests }
KinematicsTests >> testGroundSpeed [

	kinematics groundSpeedInMetersPerSecond: 0.
	self assert: kinematics groundSpeedInMetersPerSecond equals: 0.
	self assert: kinematics groundSpeedInKnots equals: 0.

	kinematics groundSpeedInMetersPerSecond: 45.
	self assert: kinematics groundSpeedInMetersPerSecond equals: 45.
	self assert: kinematics groundSpeedInKnots equals: 87.47300121519436.
	
	kinematics groundSpeedInKnots: 0.
	self assert: kinematics groundSpeedInMetersPerSecond equals: 0.
	self assert: kinematics groundSpeedInKnots equals: 0.
	
	kinematics groundSpeedInKnots: 87.47300121519436.
	self assert: kinematics groundSpeedInMetersPerSecond equals: 45.
	self assert: kinematics groundSpeedInKnots equals: 87.47300121519436.
]

{ #category : #tests }
KinematicsTests >> testHeading [
	
	kinematics headingInDegrees: 0.
	self assert: kinematics headingInDegrees equals: 0.
	self assert: kinematics headingInRadians equals: 0.

	kinematics headingInDegrees: 45.
	self assert: kinematics headingInDegrees equals: 45.
	self assert: kinematics headingInRadians equals: 0.7853981633974483.
	
	kinematics headingInRadians: 0.
	self assert: kinematics headingInDegrees equals: 0.
	self assert: kinematics headingInRadians equals: 0.
	
	kinematics headingInRadians: 0.5.
	self assert: kinematics headingInDegrees equals: 28.64788975654116.
	self assert: kinematics headingInRadians equals: 0.5.
]

{ #category : #tests }
KinematicsTests >> testRandom [ 

	kinematics := Kinematics random.

	self assert: kinematics course notNil.
	self assert: kinematics groundSpeed notNil.
	self assert: kinematics heading notNil.
]
