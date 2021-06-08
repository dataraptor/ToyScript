%option noyywrap

%{
#include "toy.tab.h"
#include <stdlib.h>

%}

%%

"if"		 return TOKEN_IF;
"else"	 return TOKEN_ELSE;
"while"  return TOKEN_WHILE;
"begin"  return TOKEN_BEGIN;
"end"    return TOKEN_END;
"do"     return TOKEN_DO;
"for"    return TOKEN_FOR;
"switch" return TOKEN_SWITCH;
"case"   return TOKEN_CASE;
"break"	 return TOKEN_BREAK;
"print"	 return TOKEN_PRINT;
"endl"	 return TOKEN_ENDLINE;

"and" 	 {yylval.op = '&'; return TOKEN_OPERATOR;}
"or"		 {yylval.op = '|'; return TOKEN_OPERATOR;}
">="		 {yylval.op = '@'; return TOKEN_OPERATOR;}
"<="		 {yylval.op = '#'; return TOKEN_OPERATOR;}
"=="		 {yylval.op = '$'; return TOKEN_OPERATOR;}
"!="     {yylval.op = 'n'; return TOKEN_OPERATOR;}

"default" return TOKEN_DEFAULT;

[\n]		  return TOKEN_NEWLINE;


\'(\\.|[^'\\])*\' {
	int len = strlen(yytext);   // 10
	yytext[len-1] = 0;
	
	yylval.name = strdup(yytext+1);
	return TOKEN_STRING;
}


[a-zA-Z_][a-zA-Z0-9_]* {yylval.name = strdup(yytext); return TOKEN_ID;}
[0-9]+ 		 {yylval.val = atoi(yytext); return TOKEN_NUMBER;}
[()=:;]    {return *yytext;}
[*/+-<>^%]  {yylval.op = *yytext; return TOKEN_OPERATOR;}
[ \t\n]    {/* suppress the output of the whitespaces from the input file to stdout */}
#.*        {/* one-line comment */}


