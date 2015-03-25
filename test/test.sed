#!/usr/bin/sed -f

# Should be recognized as functions.
e
F
L
z

# All flags should be highlighted like p and g.
# asdf should show up as a constant.
s/asdf/asdf/pgeiIMmw asdf;

# Should highlight arguments as constants.
L1
l1
Q1
q256
R/dev/stdin
ta
Tb
bc
v4.0
W/dev/stdout

# Should highlight everything up to an unescaped newline as plaintext.
eecho 1 \
echo 2
c asdf
aasdf; aaaa
a asdf
iasdf
i asdf
casdf\
adf; ddddd\
s

# Should Error.
a
c
i
q1a
Q2b
