Class {
	#name : #SpecOfObjectStateTests,
	#superclass : #TestCase,
	#category : 'StateSpecs-Specs-Tests'
}

{ #category : #tests }
SpecOfObjectStateTests >> testAsStateSpec [
	| stateSpec |
	stateSpec := SpecOfObjectState new.
	self assert: stateSpec asStateSpec == stateSpec
]

{ #category : #tests }
SpecOfObjectStateTests >> testCollectionEnumerationSelect [

	| spec |

	spec :=
		(SpecOfGreaterMagnitude than: 2 strong: true)
			& (SpecOfLesserMagnitude than: 5 strong: true).

	self
		assert: (#(1 2 3 4 5) select: spec)
		equals: #(3 4)
]

{ #category : #tests }
SpecOfObjectStateTests >> testCollectionEnumerationXyzSatisfy [
	| spec |

	spec := SpecOfGreaterMagnitude than: 2 strong: true.

	self assert: (#(1 2 3) anySatisfy: spec).
	self deny: (#(1 2) anySatisfy: spec).
	self assert: (#(3 4) allSatisfy: spec).
	self deny: (#(2 3) allSatisfy: spec).
]

{ #category : #tests }
SpecOfObjectStateTests >> testDescriptionWithTitle [
	| stateSpec result |
	stateSpec := SpecOfObjectState new.
	stateSpec title: 'some title'.
	result := stateSpec description.
	self assert: result = 'should some title'
]

{ #category : #tests }
SpecOfObjectStateTests >> testDescriptionWithTitleButDenial [
	| stateSpec result |
	stateSpec := SpecOfObjectState new.
	stateSpec
		title: 'some title';
		denial: true.
	result := stateSpec description.
	self assert: result = 'should not some title'
]

{ #category : #tests }
SpecOfObjectStateTests >> testDescriptionWithoutTitle [
	| stateSpec result expected |
	stateSpec := SpecOfObjectState new.
	result := stateSpec description.
	expected := 'should satisfy for ' , stateSpec class name.
	self assert: result = expected
]

{ #category : #tests }
SpecOfObjectStateTests >> testDescriptionWithoutTitleAndDenial [
	| stateSpec result expected |
	stateSpec := SpecOfObjectState new.
	stateSpec denial: true.
	result := stateSpec description.
	expected := 'should not satisfy for ' , stateSpec class name.
	self assert: result = expected
]

{ #category : #tests }
SpecOfObjectStateTests >> testIsStateSpec [
	| stateSpec |
	stateSpec := SpecOfObjectState new.
	self assert: stateSpec isStateSpec
]

{ #category : #tests }
SpecOfObjectStateTests >> testNotDenialByDefault [
	| stateSpec |
	stateSpec := SpecOfObjectState new.
	self deny: stateSpec denial
]

{ #category : #tests }
SpecOfObjectStateTests >> testTitleByDefault [
	| stateSpec result expected |
	stateSpec := SpecOfObjectState new.
	result := stateSpec title.
	expected := 'satisfy for ' , stateSpec class name.
	self assert: result = expected
]

{ #category : #tests }
SpecOfObjectStateTests >> testValueDelegatesToMatches [

	| spec |

	spec := SpecOfGreaterMagnitude than: 2 strong: true.

	self
		assert: (spec value: 2)
		equals: (spec matches: 2).
	self
		assert: (spec value: 3)
		equals: (spec matches: 3)
]
