Extension { #name : #Number }

{ #category : #'*GeoTools' }
Number >> asAzimuthAngle [

	^ 90 - self \\ 360
]

{ #category : #'*GeoTools' }
Number >> asTrigonometricAngle [

	^ self + 270 \\ 360
]
