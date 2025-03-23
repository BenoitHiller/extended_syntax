#!/usr/bin/sed -f

# Putting this at the top because it is unwise to run this file
Q1

# Should be recognized as functions.
e
F
z

# All flags should be highlighted like p and g.
# asdf should show up as a constant.
s/asdf/asdf/pgeiIMmw asdf;
s/asdf/asdf/ig;

# Should highlight arguments as constants.
l1
Q1
q255
R/dev/stdin
ta
Tb
bc
v4.0
W/dev/stdout

# should highlight end of line comments
d #test
ta#test
l1#test
Q1#test
q255#test
R/dev/stdin#test
ta#test
Tb#test
bc#test
v4.0#test
W/dev/stdout#test

# Note that the s command should also support end of line comments but its
# syntax code is a bit of a nightmare so I don't see an easy way to use the
# same trick I'm using for the other functions

# Should highlight everything up to an unescaped newline as plaintext.
eecho 1 \
\
echo 2
etest
c asdf
# semicolon should be ignored here
aasdf; aaaa
a asdf
iasdf
i asdf
casdf\
adf; ddddd\
s
2a\
1234p

# Comments shouldn't work in these constructs
a test#test
i test#test
c test #test
e test #test

# Should Error.
a
c
i
q1a
Q2b
q555
q5555
