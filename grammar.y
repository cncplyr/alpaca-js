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
[0-9]+?\b       { return 'NUMBER' }
[\^v<>]         { return 'ARROW' }
\".\"           { return 'QUOTED-CHAR' }
'.'             { return '.' }
','             { return ',' }
';'             { return ';' }
'('             { return '(' }
')'             { return ')' }
'='             { return '=' }
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
/*    | STATE stateId rules*/
    | STATE stateId QUOTED-CHAR
/*    | STATE stateId QUOTED-CHAR rules*/
    | STATE stateId membershipDecl
/*    | STATE stateId membershipDecl rules*/
    | STATE stateId QUOTED-CHAR membershipDecl
/*    | STATE stateId QUOTED-CHAR membershipDecl rules*/
    ;

classDefn
    : CLASS classId
/*    | CLASS classId rules*/
    | CLASS classId membershipDecl
/*    | CLASS classId membershipDecl rules*/
    ;

nbhdDefn
    : NEIGHBOURHOOD nbhdId neighbourhood
    ;

classId
    : IDENTIFIER
    ;

stateId
    : IDENTIFIER
    ;

nbhdId
    : IDENTIFIER
    ;

membershipDecl
    : classRef
    ;

classRef
    : IS classId
    ;

rules
    : rule
    | rule ',' rules
    ;

rule
    : TO stateRef
    | TO stateRef WHEN expression
    ;

stateRef
    : stateId
    | arrow-chain
    | ME
    ;

arrow-chain
    : ARROW
    | ARROW arrow-chain
    ;

expression
    : term
    | term AND term
    | term OR term
    | term XOR term
    ;

term
    : adjacencyPred
    | '(' expression ')'
    | NOT term
    | boolPrimitive
    | relationalPred
    ;

relationalPred
    : stateRef '=' stateRef
    | stateRef '=' classRef
    ;

adjacencyPred
    : NUMBER IN neighbourhood stateId
    | NUMBER IN neighbourhood classId
    | NUMBER IN nbhdId stateId
    | NUMBER IN nbhdId classId
    ;

boolPrimitive
    : TRUE
    | FALSE
    | GUESS
    ;

neighbourhood
    : '(' arrow-chain ')'
    ;
