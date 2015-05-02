/* lexical grammar */
%lex
%%

\s+             { /* ignore */ }
'and'           { return 'AND' }
'begin'         { return 'BEGIN' }
'class'         { return 'CLASS' }
'false'         { return 'FALSE' }
'guess'         { return 'GUESS' }
'in'            { return 'IN' }
'is'            { return 'IS' }
'me'            { return 'ME' }
'neighbourhood' { return 'NEIGHBOURHOOD' }
'not'           { return 'NOT' }
'or'            { return 'OR' }
'state'         { return 'STATE' }
'to'            { return 'TO' }
'true'          { return 'TRUE' }
'when'          { return 'WHEN' }
'xor'           { return 'XOR' }
[a-zA-Z]+       { return 'IDENTIFIER' }
\".\"           { return 'QUOTED-CHAR' }
'.'             { return '.' }
';'             { return ';' }
<<EOF>>         { return 'EOF' }
.               { return 'INVALID' }
/lex

%start alpaca

%% /* language grammar */

alpaca
    : defns '.' EOF
    | defns BEGIN initial-configuration EOF
    ;

defns
    : defn 
    | defn ';' defns
    ;

defn
    : stateDefn
    | classDefn
    | nbhdDefn
    ;

stateDefn
    : STATE stateId
        { $$ = 'state' + $2; }
    | STATE stateId QUOTED-CHAR
        { $$ = 'state' + $2 + $3; }
    ;

stateId
    : IDENTIFIER
        { $$ = $1; }
    ;