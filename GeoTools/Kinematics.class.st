"
I am Kinematics model.
I represent information about speed, course and heading.
"
Class {
	#name : #Kinematics,
	#superclass : #Object,
	#instVars : [
		'course',
		'groundSpeed',
		'heading'
	],
	#category : #'GeoTools-Kinematics'
}

{ #category : #copying }
Kinematics >> = aKinematics [
	^ self course = aKinematics course
		and: [ self heading = aKinematics heading  
		and: [ self groundSpeed = aKinematics groundSpeed ]]
]

{ #category : #copying }
Kinematics >> copy [
	| copy |
	copy := self class new.
	
	copy course: self course copy.		
	copy groundSpeed: self groundSpeed copy.		
	copy heading: self heading copy.		
			
	^copy
]

{ #category : #accessing }
Kinematics >> course [
	^ course
]

{ #category : #accessing }
Kinematics >> course: anObject [
	course := anObject
]

{ #category : #accessing }
Kinematics >> courseInDegrees [
	self course ifNil:[^nil].
	^ (self course convertTo: #deg) value
]

{ #category : #accessing }
Kinematics >> courseInDegrees: aDegree [
	aDegree ifNil:[course := nil. ^self].
	course := (aDegree units: #deg).
]

{ #category : #accessing }
Kinematics >> courseInRadians [
	self course ifNil:[^nil].
	^ (self course convertTo: #radians) value
]

{ #category : #accessing }
Kinematics >> courseInRadians: aRadian [
	aRadian ifNil:[course := nil. ^self].
	course := (aRadian units: #radian).
]

{ #category : #accessing }
Kinematics >> groundSpeed [
	^ groundSpeed
]

{ #category : #accessing }
Kinematics >> groundSpeed: anObject [
	groundSpeed := anObject
]

{ #category : #accessing }
Kinematics >> groundSpeedInKnots [
	| metersPerSeconds |
	self groundSpeed ifNil:[^nil].
	self flag:'labordep : Unit does not implement knots'.
	metersPerSeconds := self groundSpeedInMetersPerSecond.
	^metersPerSeconds / 0.51444445
]

{ #category : #accessing }
Kinematics >> groundSpeedInKnots: aNumber [
	| metersPerSeconds |
	aNumber ifNil:[groundSpeed := nil. ^self].
	self flag:'labordep : Unit does not implement knots'.
	metersPerSeconds := aNumber * 0.51444445.
	^self groundSpeedInMetersPerSecond: metersPerSeconds.
]

{ #category : #accessing }
Kinematics >> groundSpeedInMetersPerSecond [
	self groundSpeed ifNil:[^nil].
	^ (self groundSpeed convertTo: (Unit metre / Unit second)) value
]

{ #category : #accessing }
Kinematics >> groundSpeedInMetersPerSecond: aNumber [
	aNumber ifNil:[groundSpeed := nil. ^self].
	groundSpeed := aNumber units: (Unit metre / Unit second).
]

{ #category : #accessing }
Kinematics >> heading [
	^ heading
]

{ #category : #accessing }
Kinematics >> heading: anObject [
	heading := anObject
]

{ #category : #accessing }
Kinematics >> headingInDegrees [
	self heading ifNil:[^nil].
	^ (self heading convertTo: #deg) value
]

{ #category : #accessing }
Kinematics >> headingInDegrees: aDegree [
	aDegree ifNil:[heading := nil. ^self].
	heading := (aDegree units: #deg).
]

{ #category : #accessing }
Kinematics >> headingInRadians [
	self heading ifNil:[^nil].
	^ (self heading convertTo: #radians) value
]

{ #category : #accessing }
Kinematics >> headingInRadians: aRadian [
	aRadian ifNil:[heading := nil. ^self].
	heading := (aRadian units: #radian).
]
