/* Definition section */
%{
	#include <stdio.h>
	#include <stdlib.h>
	int line_num = 0;
	int commemt_num = 0;
%}

/* Define regular expression label */

letter 		[a-zA-Z]
digit		[0-9]
number 		{digit}+
IntNumber	{digit}+
FloatNUmber ({digit}+\.{digit}*)
id 			{letter}+({letter}|{digit})*
ws 			[ \t]+

%x CMT
%x CMT2
%x QUO
%x Q1


/* Rules section */
%%



"//"		{ BEGIN(CMT2); printf("%s", yytext); commemt_num++; line_num++;}
<CMT2>.  	{ printf("%s", yytext);}
<CMT2>\n  	{ BEGIN(INITIAL); printf(" \t C++ Comment\n");}

"/*"		{ BEGIN(CMT); printf("%s", yytext); }
<CMT>\n  	{ printf("%s", yytext); commemt_num++; line_num++;}
<CMT>"*"  	{ printf("%s", yytext); }
<CMT>.  	{ printf("%s", yytext);}
<CMT>"*/"  	{ BEGIN(INITIAL); printf("%s \t C Comment\n", yytext); commemt_num++;}

"\"" 		{ BEGIN(QUO); printf("%s \t QUOTA\n",yytext); }
<QUO>"\\" 	{ BEGIN(Q1); printf("%s",yytext); }
<QUO>"\"" 	{ BEGIN(INITIAL); printf(" \t STR_CONST\n%s \t QUOTA\n",yytext); }
<QUO>.		{ printf("%s", yytext); }

<Q1>.	{BEGIN(QUO); printf("%s",yytext);}

" "		{;}
\t 		{;}
\n 		{line_num++;}

"+" 	{ printf("%s \t ADD\n", yytext); }
"-"		{ printf("%s \t SUB\n", yytext); }
"*" 	{printf("%s \t MUL\n",yytext);}
"/" 	{printf("%s \t DIV\n",yytext);}
"%" 	{printf("%s \t MOD\n",yytext);}
"++" 	{printf("%s \t INC\n",yytext);}
"--" 	{printf("%s \t DEC\n",yytext);}
">" 	{printf("%s \t MT\n",yytext);}
"<" 	{printf("%s \t LT\n",yytext);}
">=" 	{printf("%s \t MTE\n",yytext);}
"<=" 	{printf("%s \t LTE\n",yytext);}
"==" 	{printf("%s \t EQ\n",yytext);}
"!=" 	{printf("%s \t NE\n",yytext);}
"[" 	{printf("%s \t LSB\n",yytext);}
"]" 	{printf("%s \t RSB\n",yytext);}
"," 	{printf("%s \t COMMA\n",yytext);}
";" 	{printf("%s \t SEMICOLON\n",yytext);}
"print" 	{printf("%s \t PRINT\n",yytext);}
"if" 	{printf("%s \t IF\n",yytext);}
"else" 	{printf("%s \t ELSE\n",yytext);}
"for" 	{printf("%s \t FOR\n",yytext);}
"while" 	{printf("%s \t WHILE\n",yytext);}
"int" 		{printf("%s \t INT\n",yytext);}
"float" 	{printf("%s \t FLOAT\n",yytext);}
"string" 	{printf("%s \t STRING\n",yytext);}

"="		{printf("%s \t ASGN\n", yytext); }
"+="	{printf("%s \t ADDASGN\n", yytext); }
"-="	{printf("%s \t SUBASGN\n", yytext); }
"*="	{printf("%s \t MULASGN\n", yytext); }
"/="	{printf("%s \t DIVASGN\n", yytext); }
"%="	{printf("%s \t MODASGN\n", yytext); }
"&&"	{printf("%s \t AND\n", yytext); }
"||"	{printf("%s \t OR\n", yytext); }
"!"		{printf("%s \t NOT\n", yytext); }
"("		{printf("%s \t LB\n", yytext); }
")"		{printf("%s \t RB\n", yytext); }
"{"		{printf("%s \t LCB\n", yytext); }
"}"		{printf("%s \t RCB\n", yytext); }

"void"		{printf("%s \t VOID\n", yytext); }
"bool"		{printf("%s \t BOOL\n", yytext); }
"true"		{printf("%s \t TRUE\n", yytext); }
"false"		{printf("%s \t FALSE\n", yytext); }
"return"	{printf("%s \t RET\n", yytext); }
"continue"	{printf("%s \t CONT\n", yytext); }
"break"		{printf("%s \t BREAK\n", yytext); }
{IntNumber}			{printf("%s \t I_CONST\n", yytext); }
{FloatNUmber}		{printf("%s \t F_CONST\n", yytext); }
{id}	{ printf("%s \t ID\n", yytext); }





%%

/*	C Code section */
int yywrap(void)
{
    return 1;
}

int main(int argc,char *argv[])
{
	yyin = fopen(argv[1],"r");
	yylex();
	printf("\nParse over, the line number is %d.\n\n", line_num);
	printf("comment: %d lines\n\n", commemt_num);

	return 0;
}