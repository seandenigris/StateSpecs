"
I am the root of the hierarchy of object state specifications.

I provide three methods to check objects. One is #matches:, which returns true or false. Another is #validate:, which returns an object validation result with detailed information about failures (if the object doesn't satisfy the spec). Finally, there is #value:, which lets me replace single argument testing blocks; one of the more exciting applications of this is the collection enumeration API.

My subclasses should define at least a #basicMatches: method to check if rthe given object satisfies the specification or not.

I have a denial variable which is used to mark me as the opposite specification of my original purpose. The #matches: method takes it into account, but implementors of basicMatches: shouldn't worry about it. 

Also subclasses can override the #validate: method to retrive more specific  information about given objects. 

Public API and Key Messages

- matches: anObject 
Checks if anObject matches specification or not.   It returns true or false.

- validate: anObject 
Checks if anObject matches specification or not.   It returns SpecOfValidationResult instance which can be success or failure.

- value: anObject
Like #matches: (actually delegates to it), but adapts the specification to Pharo's one-argument valuable protocol. This allows specifications to be supplied directly, for example, to collection enumeration APIs such as #select:, #detect:, #anySatisfy: and #allSatisfy: without wrapping them in adapter blocks.

-not
Creates my copy with negation behaviour

-&
It creates SpecOfAndConjunction instance with me and my argument

-| 
Creates SpecOfOrDisjunction instance with me and my argument

-title:
Sets special name of me. There is defaultTitle by default

-failureDescription:
Sets special description for validation failure


   One simple example is simply gorgeous.
 
Internal Representation and Key Implementation Points.

    Instance Variables
	denial:		<Boolean>
	title:		<String>
	failureDescription:		<String>

"
Class {
	#name : #SpecOfObjectState,
	#superclass : #Object,
	#instVars : [
		'denial',
		'title',
		'failureDescription'
	],
	#category : 'StateSpecs-Specs'
}

{ #category : #'specs composition' }
SpecOfObjectState >> & aStateSpec [ 
	^SpecOfAndConjunction of: self and: aStateSpec
]

{ #category : #converting }
SpecOfObjectState >> asStateSpec [
	^self
]

{ #category : #testing }
SpecOfObjectState >> basicMatches: anObject [ 
	self subclassResponsibility
]

{ #category : #debugging }
SpecOfObjectState >> debugValidationFailingOver: aSpecFailed [
	UnhandledError signalForException: aSpecFailed
]

{ #category : #printing }
SpecOfObjectState >> defaultTitle [
	^'satisfy for ' , self class name
]

{ #category : #accessing }
SpecOfObjectState >> denial [
	^denial
]

{ #category : #accessing }
SpecOfObjectState >> denial: aBoolean [ 
	denial == aBoolean ifTrue: [ ^self ].
	self invert
]

{ #category : #printing }
SpecOfObjectState >> description [
	^self shouldPrefixPhrase , ' ' , self title
]

{ #category : #accessing }
SpecOfObjectState >> failureDescription [
	^ failureDescription
]

{ #category : #accessing }
SpecOfObjectState >> failureDescription: anObject [
	failureDescription := anObject
]

{ #category : #'initialize-release' }
SpecOfObjectState >> initialize [
	denial := false
]

{ #category : #accessing }
SpecOfObjectState >> invert [
	denial := denial not.
	self invertChildren
]

{ #category : #accessing }
SpecOfObjectState >> invertChildren [
]

{ #category : #testing }
SpecOfObjectState >> isSimpleValue [
	^false
]

{ #category : #testing }
SpecOfObjectState >> isStateSpec [
	^true
]

{ #category : #testing }
SpecOfObjectState >> matches: anObject [ 
	^(self basicMatches: anObject) ~= denial
]

{ #category : #'specs composition' }
SpecOfObjectState >> not [
	^self copy invert; yourself
]

{ #category : #printing }
SpecOfObjectState >> printOn: aStream [
	super printOn: aStream.
	aStream << $( << self description << $)
]

{ #category : #printing }
SpecOfObjectState >> printSimpleValue [

	^self isSimpleValue 
			ifTrue: [ self asSimpleValue stringForSpecTitle ]
			ifFalse: [ '(', self title , ')' ]
]

{ #category : #printing }
SpecOfObjectState >> shouldPrefixPhrase [
	^'should' , (denial ifTrue: [' not'] ifFalse: [''])
]

{ #category : #accessing }
SpecOfObjectState >> title [
	^title ifNil: [title := self defaultTitle]
]

{ #category : #accessing }
SpecOfObjectState >> title: aString [ 
	title := aString
]

{ #category : #validation }
SpecOfObjectState >> validate: anObject [ 
	(self matches: anObject) ifTrue: [^SpecOfValidationResult success].
	^self validationFailureFor: anObject
]

{ #category : #validation }
SpecOfObjectState >> validationFailureFor: anObject [

	^SpecOfValidationResult failed: self for: anObject 
]

{ #category : #compatibility }
SpecOfObjectState >> value: anObject [
	"By implementing Pharo's one-argument valuable protocol, every specification becomes a drop-in replacement for a predicate block in APIs such as #select:, #detect: and #anySatisfy:. This tiny bridge lets callers reuse the same first-class, composable and explainable specification throughout the image instead of hiding it inside an adapter block. #matches: remains my semantic protocol."

	^ self matches: anObject
]

{ #category : #'specs composition' }
SpecOfObjectState >> | aStateSpec [ 
	^SpecOfOrDisjunction of: self and: aStateSpec
]
