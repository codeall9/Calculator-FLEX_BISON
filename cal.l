%{
#include <cstdlib>
#include <string>
#include <cmath>
#include "cal.tab.h"

double myneg (double var) {	return var * -1; }
double myabs (double var) { return (var * ((var < 0) ? (-1):(1)));}
%}
%option yylineno

Id              [_[:alpha:]][_[:alnum:]]*
IntLit          [[:digit:]]+
FloatLit        [[:digit:]]+\.[[:digit:]]+
%%

abs                           { yylval.myMathFunc = myabs; return FUNC; }
cos                           { yylval.myMathFunc = cos; return FUNC; }
sin                           { yylval.myMathFunc = sin; return FUNC; }
log                           { yylval.myMathFunc = log10; return FUNC; }
neg                           { yylval.myMathFunc = myneg; return FUNC; }
{Id}                          { yylval.varname = new std::string(yytext);  return VAR; }
{IntLit} |
{FloatLit}                    { yylval.floatlit = strtod(yytext, NULL); return NUM; }
\+\+                          { return INC; }
\-\-                          { return DEC; }
[ \t]+                        { }
\n							  { return '\n'; }
[-+*/%^=)(]                   { return *yytext; }
.                             { printf("line %d: syntax error, unexpected %c\n", yylineno, *yytext);}
%%

int yywrap() {
    return 1;
}