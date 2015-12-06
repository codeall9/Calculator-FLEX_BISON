%{
#include <cstdio>
#include <string>
#include <cmath>
#include <map>

extern int yylex();
extern int yyparse();
extern int yylineno;
void yyerror(const char *msg) { printf("line %d: %s\n", yylineno, msg); }
static std::map<std::string, double> myVar;
%}
%error-verbose
%union {
    double (*myMathFunc)(double);
	std::string* varname;
	double floatlit;
}
%token UMINUS INC DEC  
%token<floatlit> NUM
%token<varname> VAR
%token<myMathFunc> FUNC
%type<floatlit> expression
 
%right '='
%left '+' '-'
%left '*' '/' '%'
%nonassoc INC DEC
%right UMINUS
%right '^'
 
%%

line: %empty
        | line expression '\n'          { printf("%d. %g\n", yylineno - 1, $2); }
        | line error '\n'               { yyerrok; }
        | line '\n'
        ;

expression: VAR   { 
                if (myVar.find(*$1) == myVar.end()) {
                    yyerror("Unknown Variables");
                    $$ = 0;
                }
                else {
                    $$ = myVar[*$1];
                }
                delete $1;
            }
            | VAR '=' expression      { $$ = myVar[*$1] = $3; delete $1; }
            | NUM     { $$ = $1; }
            | FUNC '(' expression ')' { $$ = $1($3); }
            | '(' expression ')'    { $$ =  $2; }
            | expression '+' expression     { $$ = $1 + $3; }
            | expression '-' expression     { $$ = $1 - $3; }
            | expression '*' expression     { $$ = $1 * $3; }
            | expression '/' expression     { $$ = $1 / $3; }
            | expression '%' expression     { $$ = $1 - $1 / $3; }
            | '-' expression  %prec UMINUS    { $$ = -$2; }
            | expression '^' expression	{$$ = pow($1, $3); }
            | INC VAR	{ $$ = myVar[*$2] += 1; delete $2; }
            | DEC VAR	{ $$ = myVar[*$2] -= 1; delete $2; }
            | VAR INC	{ $$ = myVar[*$1]; myVar[*$1] += 1; delete $1; }
            | VAR DEC	{ $$ = myVar[*$1]; myVar[*$1] -= 1; delete $1; }          
            ;
%%
int main() { 
    yyparse();
    return 0; 
}