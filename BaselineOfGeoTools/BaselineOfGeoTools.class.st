Class {
	#name : #BaselineOfGeoTools,
	#superclass : #BaselineOf,
	#category : #BaselineOfGeoTools
}

{ #category : #baselines }
BaselineOfGeoTools >> baseline: spec [

	<baseline>
	"Common basline for all Pharo versions"
	spec for: #common do: [ self baselineForCommon: spec ]
]

{ #category : #baselines }
BaselineOfGeoTools >> baselineForCommon: spec [
	<baseline>
	
	spec preLoadDoIt: #'preload:package:'.
	spec postLoadDoIt: #'postload:package:'.
	
	"Dependencies"
	self coreDependencies: spec.
	
	"Packages"
	self corePackages: spec.
]

{ #category : #baselines }
BaselineOfGeoTools >> coreDependencies: spec [

	spec
		baseline: 'Units'
		with: [ spec repository: 'github://zweidenker/Units' ].
]

{ #category : #baselines }
BaselineOfGeoTools >> corePackages: spec [

	spec
		package: 'GeoTools' with: [ spec requires: #('Units') ].
		
	"tests packages"
	spec 
		package: 'GeoTools-Tests' with: [ spec requires: #( 'GeoTools' ) ].
]

{ #category : #baselines }
BaselineOfGeoTools >> postload: loader package: packageSpec [

	"do nothing"
]

{ #category : #baselines }
BaselineOfGeoTools >> preload: loader package: packageSpec [

	"do nothing"
]
