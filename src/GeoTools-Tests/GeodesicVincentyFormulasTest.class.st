"
A GeodesicVincentyFormulasTest is a test class for testing the behavior of GeodesicVincentyFormulas
"
Class {
	#name : #GeodesicVincentyFormulasTest,
	#superclass : #GeodesicFormulasTest,
	#category : #'GeoTools-Tests-Geodesic'
}

{ #category : #accessing }
GeodesicVincentyFormulasTest >> geodesicFormulasClass [

	^ GeodesicVincentyFormulas 
]

{ #category : #tests }
GeodesicVincentyFormulasTest >> testIterationsLimit [

	self assert: geodesicFormulas iterationsLimit equals: GeodesicVincentyFormulas defaultIterationsLimit.
	self assert: geodesicFormulas iterationsLimit equals: 100.
	
	geodesicFormulas iterationsLimit: 1.
	self assert: geodesicFormulas iterationsLimit equals: 1.
	
	geodesicFormulas iterationsLimit: nil.
	self assert: geodesicFormulas iterationsLimit equals: GeodesicVincentyFormulas defaultIterationsLimit.
]

{ #category : #tests }
GeodesicVincentyFormulasTest >> testPrecision [

	self assert: geodesicFormulas precision equals: GeodesicVincentyFormulas defaultPrecision.
	self assert: geodesicFormulas precision equals: 1e-12.
	
	geodesicFormulas precision: 1.
	self assert: geodesicFormulas precision equals: 1.
	
	geodesicFormulas precision: nil.
	self assert: geodesicFormulas precision equals: GeodesicVincentyFormulas defaultPrecision.
]
