#import "sustech-master-thesis/utils/multi-line-equate.typ": equate, equate-ref

#set text(lang: "en")
#set heading(numbering: "1.1")
#show heading: it => {
	counter(math.equation).update(0)
	it
}
#show math.equation: equate.with(debug: true)
#show ref: equate-ref
#set math.equation(numbering: "(1.1.a)")

= Heading

#context counter(math.equation).get()

Simple
$
O(n/t) = 1
$ <->
#context counter(math.equation).get()

Simple 2
$
O(n/t) = 1
$ <simple2>
#context counter(math.equation).get()
@eqt:simple2

Test
$
 F_n &= P(n) \
	&= floor(1 / sqrt(5) phi.alt^n).  #<test2>
$ <test>
#context counter(math.equation).get()
@eqt:test, @eqt:test-test2

Test no label
$
 F_n &= P(n) \
	&= floor(1 / sqrt(5) phi.alt^n).
$ <->
#context counter(math.equation).get()
$
 F_n &= P(n) \
	&= floor(1 / sqrt(5) phi.alt^n). #<specific>
$ <->
#context counter(math.equation).get()
@eqt:specific
$
 F_n &= P(n)  #<new1> \
	&= floor(1 / sqrt(5) phi.alt^n). #<new2>
$ <->
#context counter(math.equation).get()
@eqt:new1, @eqt:new2

#pagebreak()
= Heading

#context counter(math.equation).get()

Simple
$
O(n/t) = 1
$ <->
#context counter(math.equation).get()

Simple 2
$
O(n/t) = 1
$ <2-simple2>
#context counter(math.equation).get()
@eqt:2-simple2

Test
$
 F_n &= P(n) \
	&= floor(1 / sqrt(5) phi.alt^n).  #<test2>
$ <2-test>
#context counter(math.equation).get()
@eqt:2-test, @eqt:2-test-test2

Test no label
$
 F_n &= P(n) \
	&= floor(1 / sqrt(5) phi.alt^n).
$ <->
#context counter(math.equation).get()
$
 F_n &= P(n) #<2-specific> \
	&= floor(1 / sqrt(5) phi.alt^n).
$ <->
#context counter(math.equation).get()
@eqt:2-specific
$
 F_n &= P(n)  #<2-new1> \
	&= floor(1 / sqrt(5) phi.alt^n). #<2-new2>
$ <->
#context counter(math.equation).get()
@eqt:2-new1, @eqt:2-new2
